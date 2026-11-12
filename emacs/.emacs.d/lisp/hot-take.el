;; ;;; hot-take.el --- Review AI code while it's still hot -*- lexical-binding: t; -*-
;; 
;; ;; Author: (you)
;; ;; Version: 0.1.0
;; ;; Package-Requires: ((emacs "28.1"))
;; ;; Keywords: tools, ai, review
;; 
;; ;;; Commentary:
;; 
;; ;; hot-take — dedicated workspace for reviewing AI-generated changes.
;; ;;
;; ;; One workspace, two states:
;; ;;
;; ;;   chat    — full-screen conversation with the agent
;; ;;   review  — queue | diff | chat, side by side
;; ;;
;; ;; Entry point: M-x hot-take
;; ;;
;; ;; If the working tree already has changes, you land in `review'.
;; ;; If not, you land in `chat'.  C-c C-l toggles between states.
;; ;;
;; ;; Keys in `review':
;; ;;   n / p           — next / previous file
;; ;;   RET (on a hunk) — open the real file in a popup below the diff
;; ;;   C-c C-c (popup) — close popup and refresh diff (keeps your edits)
;; ;;   C-c a / r / d   — accept (git add) / reject (save patch + revert) / discuss
;; ;;   C-c C-s         — send the hunk at point into chat
;; ;;   C-c C-l         — toggle to full-screen chat
;; ;;   Q               — exit workspace
;; ;;
;; ;; Keys in `chat':
;; ;;   C-c C-s         — send a prompt to the agent
;; ;;   C-c C-r         — refresh: re-read changed files (agent may have edited)
;; ;;   C-c C-l         — toggle to review (if files exist)
;; ;;   Q               — exit workspace
;; ;;
;; ;; Configure the backend:
;; ;;   (setq hot-take-backend-command '("llm" "-m" "claude-3-5-sonnet"))
;; ;;   ;; or a Lisp function (prompt -> reply):
;; ;;   (setq hot-take-backend-function #'my-agent-send)
;; ;;
;; ;; Reject never loses data: the diff is saved to .hot-take-rejected/
;; ;; before reverting.
;; 
;; ;;; Code:
;; 
;; (require 'cl-lib)
;; (require 'subr-x)
;; (require 'project)
;; (require 'diff-mode)
;; 
;; ;;;; Customization
;; 
;; (defgroup hot-take nil
;;   "Review AI-generated code while it's still warm."
;;   :group 'tools
;;   :prefix "hot-take-")
;; 
;; (defcustom hot-take-backend-command '("llm" "-m" "gpt-4o")
;;   "Shell command (list) that runs the agent backend.
;; Prompt is written to stdin; reply is read from stdout.
;; Ignored if `hot-take-backend-function' is set."
;;   :type '(repeat string))
;; 
;; (defvar hot-take-backend-function nil
;;   "Function (PROMPT -> STRING) used as the agent backend, or nil.
;; Takes precedence over `hot-take-backend-command'.")
;; 
;; (defcustom hot-take-workspace-kind 'tab
;;   "Where to host the workspace: `tab' or `frame'."
;;   :type '(choice (const tab) (const frame)))
;; 
;; (defcustom hot-take-queue-width 0.20
;;   "Width of the queue side window in `review' state."
;;   :type 'number)
;; 
;; (defcustom hot-take-chat-width 0.30
;;   "Width of the chat side window in `review' state."
;;   :type 'number)
;; 
;; (defcustom hot-take-code-popup-height 0.45
;;   "Height of the code popup, as a fraction of the frame."
;;   :type 'number)
;; 
;; (defcustom hot-take-system-prompt
;;   "You are a senior engineer helping review AI-generated code. Be concise."
;;   "System preamble prepended to every chat prompt."
;;   :type 'string)
;; 
;; (defcustom hot-take-discuss-hook nil
;;   "Hook run when a hunk or file is sent for discussion.
;; Called with three args: FILE, DIFF, HUNK (HUNK may be nil).
;; Point it at gptel / aider / your favorite chat to route the message."
;;   :type 'hook)
;; 
;; ;;;; Session
;; 
;; (cl-defstruct hot-take-session
;;   root files index decisions)
;; 
;; (defvar hot-take--session nil
;;   "Active `hot-take-session', or nil.")
;; 
;; (defvar hot-take--layout nil
;;   "Current layout: `chat' or `review', or nil when inactive.")
;; 
;; (defvar hot-take--frame nil
;;   "Frame we created for the workspace, if using frame kind.")
;; 
;; (defvar hot-take--entered-tab-bar nil
;;   "Non-nil if we enabled `tab-bar-mode' ourselves and should turn it off.")
;; 
;; ;;;; Git helpers (root is explicit; session may not exist yet)
;; 
;; (defun hot-take--root ()
;;   (or (when-let ((p (project-current))) (project-root p))
;;       default-directory))
;; 
;; (defun hot-take--git-in (root &rest args)
;;   "Run git ARGS in ROOT; return stdout.  Signal on failure."
;;   (let ((default-directory root))
;;     (with-temp-buffer
;;       (unless (zerop (apply #'call-process "git" nil t nil args))
;;         (error "git %s failed: %s"
;;                (string-join args " ") (string-trim (buffer-string))))
;;       (buffer-string))))
;; 
;; (defun hot-take--git-optional-in (root &rest args)
;;   "Like `hot-take--git-in' but return nil on non-zero exit."
;;   (let ((default-directory root))
;;     (with-temp-buffer
;;       (when (zerop (apply #'call-process "git" nil t nil args))
;;         (buffer-string)))))
;; 
;; (defun hot-take--changed-files-at (root)
;;   "Return list of files that differ from HEAD under ROOT.
;; Untracked files are marked intent-to-add so they appear in diffs."
;;   (let ((default-directory root))
;;     (dolist (f (split-string
;;                 (or (with-temp-buffer
;;                       (when (zerop (call-process "git" nil t nil
;;                                                  "ls-files" "--others" "--exclude-standard"))
;;                         (buffer-string)))
;;                     "")
;;                 "\n" t))
;;       (ignore-errors (call-process "git" nil nil nil "add" "-N" "--" f))))
;;   (split-string
;;    (string-trim (hot-take--git-in root "diff" "--name-only" "HEAD"))
;;    "\n" t))
;; 
;; (defun hot-take--git (&rest args)
;;   "Run git ARGS in the active session's root."
;;   (apply #'hot-take--git-in (hot-take-session-root hot-take--session) args))
;; 
;; (defun hot-take--git-optional (&rest args)
;;   (apply #'hot-take--git-optional-in (hot-take-session-root hot-take--session) args))
;; 
;; ;;;; Backend
;; 
;; (defun hot-take--send-to-backend (prompt)
;;   "Send PROMPT to the configured backend; return the reply string."
;;   (cond
;;    (hot-take-backend-function
;;     (funcall hot-take-backend-function prompt))
;;    ((null hot-take-backend-command)
;;     "(no backend configured — set `hot-take-backend-command' or `hot-take-backend-function')")
;;    (t
;;     (with-temp-buffer
;;       (insert prompt)
;;       (let ((exit (apply #'call-process-region
;;                          (point-min) (point-max)
;;                          (car hot-take-backend-command) t t nil
;;                          (cdr hot-take-backend-command))))
;;         (if (zerop exit)
;;             (string-trim (buffer-string))
;;           (format "(backend failed: exit %d)" exit)))))))
;; 
;; ;;;; Chat buffer
;; 
;; (define-derived-mode hot-take-chat-mode special-mode "hot-take-chat"
;;   "Log of the conversation with the agent, in review context."
;;   (setq truncate-lines nil)
;;   (setq-local line-spacing 2))
;; 
;; (defun hot-take--ensure-chat-buffer ()
;;   (let ((buf (get-buffer-create "*hot-take chat*")))
;;     (with-current-buffer buf
;;       (unless (derived-mode-p 'hot-take-chat-mode)
;;         (hot-take-chat-mode))
;;       (when (= (point-min) (point-max))
;;         (let ((inhibit-read-only t))
;;           (insert (propertize "hot-take chat\n" 'face 'bold)
;;                   (make-string 40 ?─) "\n\n"
;;                   (propertize "C-c C-s send prompt   C-c C-r refresh files   C-c C-l toggle layout   Q exit\n"
;;                               'face 'italic)
;;                   "\n"))))
;;     buf))
;; 
;; (defun hot-take--chat-append (text)
;;   (with-current-buffer (hot-take--ensure-chat-buffer)
;;     (let ((inhibit-read-only t)
;;           (was-at-end (>= (point) (save-excursion (goto-char (point-max))
;;                                                    (line-beginning-position)))))
;;       (goto-char (point-max))
;;       (insert text)
;;       (when was-at-end (goto-char (point-max))))))
;; 
;; (defun hot-take-chat-send (prompt)
;;   "Send PROMPT to the agent and append the reply to the chat buffer."
;;   (interactive (list (read-string "→ ")))
;;   (when (or (null prompt) (string-empty-p (string-trim prompt)))
;;     (user-error "Empty prompt"))
;;   (hot-take--chat-append
;;    (format "\n%s %s\n" (propertize "You:" 'face 'bold) prompt))
;;   (let ((reply (condition-case err
;;                    (hot-take--send-to-backend
;;                     (format "%s\n\n%s" hot-take-system-prompt prompt))
;;                  (error (format "(error: %s)" err)))))
;;     (hot-take--chat-append
;;      (format "%s %s\n" (propertize "AI:" 'face 'bold) reply)))
;;   (hot-take-refresh)
;;   (let ((n (length (hot-take-session-files hot-take--session))))
;;     (when (> n 0)
;;       (message "%d file(s) changed — C-c C-l to review" n))))
;; 
;; ;;;; Queue buffer
;; 
;; (defface hot-take-current-face
;;   '((t :background "gray20" :weight bold))
;;   "Current row in the queue." :group 'hot-take)
;; (defface hot-take-accept-face
;;   '((t :foreground "green" :weight bold))
;;   "Accepted file." :group 'hot-take)
;; (defface hot-take-reject-face
;;   '((t :foreground "red" :strikethrough t))
;;   "Rejected file." :group 'hot-take)
;; (defface hot-take-discuss-face
;;   '((t :foreground "orange" :weight bold))
;;   "File under discussion." :group 'hot-take)
;; 
;; (defconst hot-take--decision-face
;;   '((accept . hot-take-accept-face)
;;     (reject . hot-take-reject-face)
;;     (discuss . hot-take-discuss-face)))
;; 
;; (define-derived-mode hot-take-queue-mode special-mode "hot-take-queue"
;;   "Queue of files to review."
;;   (setq truncate-lines t))
;; 
;; (defun hot-take--render-queue ()
;;   (with-current-buffer (get-buffer-create "*hot-take queue*")
;;     (let ((inhibit-read-only t))
;;       (erase-buffer)
;;       (insert (format "hot-take — %d file(s), %d/%d\n"
;;                       (length (hot-take-session-files hot-take--session))
;;                       (1+ (hot-take-session-index hot-take--session))
;;                       (max 1 (length (hot-take-session-files hot-take--session))))
;;               (make-string 24 ?─) "\n\n")
;;       (cl-loop
;;        for file in (hot-take-session-files hot-take--session)
;;        for i from 0
;;        for dec = (alist-get file (hot-take-session-decisions hot-take--session)
;;                             nil nil #'string=)
;;        do (let ((start (point)))
;;             (insert (format "%c %s"
;;                             (if (= i (hot-take-session-index hot-take--session))
;;                                 ?> ?\s)
;;                             file))
;;             (when (= i (hot-take-session-index hot-take--session))
;;               (add-face-text-property start (point) 'hot-take-current-face t))
;;             (when dec
;;               (insert " ")
;;               (let ((s (point)))
;;                 (insert (format "[%s]" dec))
;;                 (add-face-text-property s (point)
;;                                         (alist-get dec hot-take--decision-face) t)))
;;             (insert "\n")))
;;       (insert "\nRET focus diff   n/p move   a/r/d decide   Q exit")
;;       (goto-char (point-min)))
;;     (hot-take-queue-mode)
;;     (current-buffer)))
;; 
;; ;;;; Diff buffer
;; 
;; (define-derived-mode hot-take-diff-mode diff-mode "hot-take-diff"
;;   "Diff of the current file with review bindings.")
;; 
;; (defun hot-take--current-file ()
;;   (let* ((files (hot-take-session-files hot-take--session))
;;          (idx   (hot-take-session-index hot-take--session)))
;;     (when (and files (< idx (length files)))
;;       (nth idx files))))
;; 
;; (defun hot-take--refresh-diff ()
;;   (let ((buf (get-buffer-create "*hot-take diff*")))
;;     (with-current-buffer buf
;;       (let ((inhibit-read-only t))
;;         (erase-buffer)
;;         (let ((file (hot-take--current-file)))
;;           (cond
;;            ((null file)
;;             (insert ";; No changes to review.  C-c C-l to return to chat.\n"))
;;            (t
;;             (let ((diff (hot-take--git "diff" "HEAD" "--" file)))
;;               (insert (if (string-empty-p diff)
;;                           (format ";; No diff for %s (already applied?)\n" file)
;;                         diff)))
;;             (setq header-line-format
;;                   (format " %s  [%d/%d]   RET edit   C-c a/r/d decide   C-c C-s send   C-c C-l chat   Q exit "
;;                           file
;;                           (1+ (hot-take-session-index hot-take--session))
;;                           (length (hot-take-session-files hot-take--session))))))))
;;       (hot-take-diff-mode)
;;       (setq-local default-directory (hot-take-session-root hot-take--session))
;;       (goto-char (point-min)))
;;     buf))
;; 
;; (defun hot-take--hunk-target ()
;;   "Return (FILE . LINE) at the hunk at point in a diff buffer."
;;   (save-excursion
;;     (unless (looking-at "^@@")
;;       (condition-case nil (diff-hunk-next)
;;         (error (user-error "Not on a hunk"))))
;;     (beginning-of-line)
;;     (let* ((names (ignore-errors (diff-hunk-file-names)))
;;            (file  (or (cadr names) (car names)))
;;            (hdr   (buffer-substring-no-properties
;;                    (line-beginning-position) (line-end-position)))
;;            (line  (if (string-match "@@ [^+]*\\+\\([0-9]+\\)" hdr)
;;                       (string-to-number (match-string 1 hdr))
;;                     1)))
;;       (unless file (user-error "Not on a hunk"))
;;       (cons file line))))
;; 
;; ;;;; Code popup (real file, editable)
;; 
;; (defvar hot-take-code-mode-map
;;   (let ((map (make-sparse-keymap)))
;;     (define-key map (kbd "C-c C-c") #'hot-take-close-popup)
;;     (define-key map (kbd "C-c C-a") #'hot-take-accept-current)
;;     (define-key map (kbd "C-c C-r") #'hot-take-reject-current)
;;     (define-key map (kbd "C-c C-d") #'hot-take-discuss-current)
;;     (define-key map (kbd "C-c C-s") #'hot-take-send-hunk-to-chat)
;;     (define-key map (kbd "C-c C-l") #'hot-take-toggle-layout)
;;     (define-key map (kbd "Q")       #'hot-take-exit)
;;     map)
;;   "Keymap for `hot-take-code-mode'.")
;; 
;; (define-minor-mode hot-take-code-mode
;;   "Minor mode for the editable popup opened from a hunk."
;;   :lighter " hot-take"
;;   :keymap hot-take-code-mode-map)
;; 
;; (defun hot-take-open-hunk-popup ()
;;   "Open the real file at the hunk in a popup below the diff."
;;   (interactive)
;;   (unless (eq major-mode 'hot-take-diff-mode)
;;     (user-error "Not in a hot-take diff buffer"))
;;   (pcase-let* ((`(,file . ,line) (hot-take--hunk-target))
;;                (root (hot-take-session-root hot-take--session))
;;                (abs  (expand-file-name file root))
;;                (buf  (find-file-noselect abs)))
;;     (with-current-buffer buf
;;       (goto-char (point-min))
;;       (forward-line (1- (max 1 line)))
;;       (recenter 0)
;;       (hot-take-code-mode 1))
;;     (display-buffer buf
;;                     `((display-buffer-below-selected)
;;                       (window-height . ,hot-take-code-popup-height)))
;;     (message "C-c C-c close & refresh   C-c C-a accept   C-c C-r reject   C-c C-d discuss")))
;; 
;; (defun hot-take-close-popup ()
;;   "Close the code popup and refresh the diff to include edits."
;;   (interactive)
;;   (when-let ((win (get-buffer-window (current-buffer))))
;;     (quit-window nil win))
;;   (when (eq hot-take--layout 'review)
;;     (switch-to-buffer (hot-take--refresh-diff))))
;; 
;; ;;;; Send-to-chat from diff
;; 
;; (defun hot-take-send-hunk-to-chat ()
;;   "Send the hunk at point into the chat buffer."
;;   (interactive)
;;   (unless (eq major-mode 'hot-take-diff-mode)
;;     (user-error "Not in a hot-take diff buffer"))
;;   (pcase-let* ((`(,file . ,_) (hot-take--hunk-target))
;;                (hunk (save-excursion
;;                        (diff-hunk-next) (beginning-of-line)
;;                        (let ((beg (point)))
;;                          (diff-hunk-next) (beginning-of-line)
;;                          (buffer-substring-no-properties beg (point))))))
;;     (hot-take--chat-append
;;      (format "\n[%s] %s\n```diff\n%s```\n"
;;              (format-time-string "%H:%M") file hunk))
;;     (when hot-take-discuss-hook
;;       (run-hook-with-args 'hot-take-discuss-hook
;;                           file (hot-take--git "diff" "HEAD" "--" file) hunk))
;;     (message "Hunk sent to chat")))
;; 
;; ;;;; Decisions
;; 
;; (defun hot-take--save-reject-patch (file)
;;   (let* ((root (hot-take-session-root hot-take--session))
;;          (dir  (expand-file-name ".hot-take-rejected" root))
;;          (path (expand-file-name
;;                 (format "%s-%s.patch"
;;                         (format-time-string "%Y%m%d-%H%M%S")
;;                         (replace-regexp-in-string "[/\\]" "_" file))
;;                 dir)))
;;     (make-directory dir t)
;;     (with-temp-file path
;;       (insert (hot-take--git "diff" "HEAD" "--" file)))
;;     path))
;; 
;; (defun hot-take--kill-file-buffer (file)
;;   (when-let ((buf (get-file-buffer
;;                    (expand-file-name file (hot-take-session-root hot-take--session)))))
;;     (with-current-buffer buf
;;       (set-buffer-modified-p nil)
;;       (kill-buffer buf))))
;; 
;; (defun hot-take--decide-current (decision)
;;   (let ((file (hot-take--current-file)))
;;     (unless file (user-error "No current file"))
;;     (cl-pushnew (cons file decision)
;;                 (hot-take-session-decisions hot-take--session)
;;                 :test (lambda (a b) (string= (car a) (car b))))
;;     (pcase decision
;;       ('accept
;;        (when-let ((buf (get-file-buffer
;;                         (expand-file-name file (hot-take-session-root hot-take--session)))))
;;          (when (buffer-modified-p buf)
;;            (with-current-buffer buf (save-buffer))))
;;        (hot-take--git "add" "--" file)
;;        (message "Accepted %s" file))
;;       ('reject
;;        (let ((patch (hot-take--save-reject-patch file))
;;              (exists (hot-take--git-optional "cat-file" "-e" (format "HEAD:%s" file))))
;;          (hot-take--kill-file-buffer file)
;;          (if exists
;;              (hot-take--git "checkout" "HEAD" "--" file)
;;            (let ((abs (expand-file-name file (hot-take-session-root hot-take--session))))
;;              (when (file-exists-p abs) (delete-file abs)))
;;            (ignore-errors
;;              (hot-take--git "rm" "--cached" "--force" "--" file)))
;;          (message "Rejected %s (patch: %s)" file patch)))
;;       ('discuss
;;        (hot-take--chat-append
;;         (format "\n[%s] discuss: %s\n```diff\n%s```\n"
;;                 (format-time-string "%H:%M") file
;;                 (hot-take--git "diff" "HEAD" "--" file)))
;;        (when hot-take-discuss-hook
;;          (run-hook-with-args 'hot-take-discuss-hook
;;                              file (hot-take--git "diff" "HEAD" "--" file) nil))
;;        (message "Marked %s for discussion" file)))
;;     (hot-take--advance)))
;; 
;; (defun hot-take--advance ()
;;   (let* ((files (hot-take-session-files hot-take--session))
;;          (idx   (hot-take-session-index hot-take--session))
;;          (n     (length files)))
;;     (cond
;;      ((< idx (1- n))
;;       (setf (hot-take-session-index hot-take--session) (1+ idx))
;;       (when (eq hot-take--layout 'review)
;;         (hot-take--render-queue)
;;         (switch-to-buffer (hot-take--refresh-diff))))
;;      (t
;;       (hot-take-refresh)
;;       (let* ((new-files (hot-take-session-files hot-take--session))
;;              (new-idx (hot-take-session-index hot-take--session))
;;              (any-pending (cl-some
;;                            (lambda (f)
;;                              (null (alist-get f (hot-take-session-decisions hot-take--session)
;;                                               nil nil #'string=)))
;;                            new-files)))
;;         (if (and new-files any-pending)
;;             (progn
;;               (setf (hot-take-session-index hot-take--session)
;;                     (or new-idx 0))
;;               (hot-take--render-queue)
;;               (switch-to-buffer (hot-take--refresh-diff))
;;               (message "Review continues — %d file(s)" (length new-files)))
;;           (hot-take--setup-chat)
;;           (message "Review complete — discuss with the agent, or Q to exit")))))))
;; 
;; (defun hot-take-accept-current  () (interactive) (hot-take--decide-current 'accept))
;; (defun hot-take-reject-current  () (interactive) (hot-take--decide-current 'reject))
;; (defun hot-take-discuss-current () (interactive) (hot-take--decide-current 'discuss))
;; 
;; ;;;; Refresh
;; 
;; (defun hot-take-refresh ()
;;   "Re-read the changed file list from git and update buffers in place."
;;   (interactive)
;;   (when hot-take--session
;;     (let* ((root   (hot-take-session-root hot-take--session))
;;            (files  (hot-take--changed-files-at root))
;;            (idx    (hot-take-session-index hot-take--session)))
;;       (setf (hot-take-session-files hot-take--session) files)
;;       (when (and files (>= idx (length files)))
;;         (setf (hot-take-session-index hot-take--session)
;;               (max 0 (1- (length files)))))
;;       (when (and (null files)
;;                  (eq hot-take--layout 'review))
;;         (hot-take--setup-chat)
;;         (message "No files left — back to chat"))
;;       (when (get-buffer "*hot-take queue*")
;;         (hot-take--render-queue))
;;       (when (and (eq hot-take--layout 'review) files)
;;         (let ((cur (current-buffer)))
;;           (unless (eq cur (get-buffer "*hot-take diff*"))
;;             (with-current-buffer (hot-take--refresh-diff) nil)))))))
;; 
;; ;;;; Layouts
;; 
;; (defun hot-take--setup-chat ()
;;   "Full-screen chat."
;;   (setq hot-take--layout 'chat)
;;   (delete-other-windows)
;;   (switch-to-buffer (hot-take--ensure-chat-buffer))
;;   (goto-char (point-max))
;;   (message "Chat — C-c C-s send   C-c C-r refresh   C-c C-l review   Q exit"))
;; 
;; (defun hot-take--setup-review ()
;;   "Queue | diff | chat layout."
;;   (hot-take-refresh)
;;   (if (null (hot-take-session-files hot-take--session))
;;       (hot-take--setup-chat)
;;     (setq hot-take--layout 'review)
;;     (delete-other-windows)
;;     (display-buffer-in-side-window
;;      (hot-take--render-queue)
;;      `((side . left) (slot . 0)
;;        (window-width . ,hot-take-queue-width)
;;        (preserve-size . (t . nil))))
;;     (display-buffer-in-side-window
;;      (hot-take--ensure-chat-buffer)
;;      `((side . right) (slot . 0)
;;        (window-width . ,hot-take-chat-width)
;;        (preserve-size . (t . nil))))
;;     (select-window (get-largest-window))
;;     (switch-to-buffer (hot-take--refresh-diff))
;;     (message "Review — RET edit hunk, C-c a/r/d decide, C-c C-s send, C-c C-l chat, Q exit")))
;; 
;; (defun hot-take-toggle-layout ()
;;   "Switch between `chat' and `review'."
;;   (interactive)
;;   (unless hot-take--session (user-error "No active session"))
;;   (pcase hot-take--layout
;;     ('chat
;;      (hot-take-refresh)
;;      (if (hot-take-session-files hot-take--session)
;;          (hot-take--setup-review)
;;        (message "No files to review yet — ask the agent, then C-c C-r")))
;;     ('review (hot-take--setup-chat))
;;     (_ (hot-take--setup-chat))))
;; 
;; ;;;; Entry / exit
;; 
;; (defun hot-take--enter-via-tab ()
;;   (unless tab-bar-mode
;;     (tab-bar-mode 1)
;;     (setq hot-take--entered-tab-bar t))
;;   (tab-bar-new-tab)
;;   (tab-bar-rename-tab "hot-take"))
;; 
;; (defun hot-take--enter-via-frame ()
;;   (setq hot-take--frame
;;         (make-frame '((name . "hot-take")
;;                       (width . 200) (height . 55)
;;                       (minibuffer . nil))))
;;   (select-frame hot-take--frame))
;; 
;; ;;;###autoload
;; (defun hot-take (&optional force-chat)
;;   "Enter the hot-take review workspace.
;; With prefix argument FORCE-CHAT, open chat even if changes exist."
;;   (interactive "P")
;;   (cond
;;    (hot-take--session
;;     (hot-take-refresh)
;;     (if (or force-chat (null (hot-take-session-files hot-take--session)))
;;         (hot-take--setup-chat)
;;       (hot-take--setup-review)))
;;    (t
;;     (let* ((root  (hot-take--root))
;;            (files (hot-take--changed-files-at root)))
;;       (setq hot-take--session
;;             (make-hot-take-session
;;              :root root :files files :index 0 :decisions nil))
;;       (pcase hot-take-workspace-kind
;;         ('frame (hot-take--enter-via-frame))
;;         (_      (hot-take--enter-via-tab)))
;;       (if (or force-chat (null files))
;;           (hot-take--setup-chat)
;;         (hot-take--setup-review))))))
;; 
;; (defun hot-take-exit ()
;;   "Leave the workspace.  Edits already written to disk are kept."
;;   (interactive)
;;   (let* ((files (when hot-take--session
;;                   (hot-take-session-files hot-take--session)))
;;          (modified
;;           (cl-remove-if-not
;;            (lambda (f)
;;              (when-let ((b (get-file-buffer
;;                             (expand-file-name f (hot-take-session-root hot-take--session)))))
;;                (buffer-modified-p b)))
;;            files)))
;;     (when (and modified
;;                (not (yes-or-no-p
;;                      (format "%d buffer(s) modified.  Exit anyway? " (length modified)))))
;;       (user-error "Exit cancelled")))
;;   (setq hot-take--session nil
;;         hot-take--layout nil)
;;   (cond
;;    ((eq hot-take-workspace-kind 'tab)
;;     (when (equal (alist-get 'name (tab-bar--current-tab)) "hot-take")
;;       (tab-bar-close-tab))
;;     (when hot-take--entered-tab-bar
;;       (tab-bar-mode -1)
;;       (setq hot-take--entered-tab-bar nil)))
;;    ((frame-live-p hot-take--frame)
;;     (delete-frame hot-take--frame)
;;     (setq hot-take--frame nil)))
;;   (message "Left hot-take"))
;; 
;; ;;;; Keybindings
;; 
;; ;; Queue
;; (define-key hot-take-queue-mode-map (kbd "n")       #'hot-take-queue-next)
;; (define-key hot-take-queue-mode-map (kbd "p")       #'hot-take-queue-prev)
;; (define-key hot-take-queue-mode-map (kbd "RET")     #'hot-take-queue-focus-diff)
;; (define-key hot-take-queue-mode-map (kbd "a")       #'hot-take-accept-current)
;; (define-key hot-take-queue-mode-map (kbd "r")       #'hot-take-reject-current)
;; (define-key hot-take-queue-mode-map (kbd "d")       #'hot-take-discuss-current)
;; (define-key hot-take-queue-mode-map (kbd "C-c C-l") #'hot-take-toggle-layout)
;; (define-key hot-take-queue-mode-map (kbd "Q")       #'hot-take-exit)
;; 
;; ;; Diff
;; (define-key hot-take-diff-mode-map (kbd "RET")     #'hot-take-open-hunk-popup)
;; (define-key hot-take-diff-mode-map (kbd "C-c C-o") #'hot-take-open-hunk-popup)
;; (define-key hot-take-diff-mode-map (kbd "C-c C-s") #'hot-take-send-hunk-to-chat)
;; (define-key hot-take-diff-mode-map (kbd "C-c C-l") #'hot-take-toggle-layout)
;; (define-key hot-take-diff-mode-map (kbd "C-c a")   #'hot-take-accept-current)
;; (define-key hot-take-diff-mode-map (kbd "C-c r")   #'hot-take-reject-current)
;; (define-key hot-take-diff-mode-map (kbd "C-c d")   #'hot-take-discuss-current)
;; (define-key hot-take-diff-mode-map (kbd "Q")       #'hot-take-exit)
;; 
;; ;; Chat
;; (define-key hot-take-chat-mode-map (kbd "C-c C-s") #'hot-take-chat-send)
;; (define-key hot-take-chat-mode-map (kbd "C-c C-r") #'hot-take-refresh)
;; (define-key hot-take-chat-mode-map (kbd "C-c C-l") #'hot-take-toggle-layout)
;; (define-key hot-take-chat-mode-map (kbd "Q")       #'hot-take-exit)
;; 
;; ;;;; Queue navigation helpers (defined after diff refresh)
;; 
;; (defun hot-take-queue-next ()
;;   (interactive)
;;   (let ((n (length (hot-take-session-files hot-take--session))))
;;     (when (< (hot-take-session-index hot-take--session) (1- n))
;;       (setf (hot-take-session-index hot-take--session)
;;             (1+ (hot-take-session-index hot-take--session)))
;;       (hot-take--render-queue)
;;       (when (eq hot-take--layout 'review)
;;         (hot-take-queue-focus-diff)))))
;; 
;; (defun hot-take-queue-prev ()
;;   (interactive)
;;   (when (> (hot-take-session-index hot-take--session) 0)
;;     (setf (hot-take-session-index hot-take--session)
;;           (1- (hot-take-session-index hot-take--session)))
;;     (hot-take--render-queue)
;;     (when (eq hot-take--layout 'review)
;;       (hot-take-queue-focus-diff))))
;; 
;; (defun hot-take-queue-focus-diff ()
;;   "Focus the diff window and (re)render the current file."
;;   (interactive)
;;   (switch-to-buffer (hot-take--refresh-diff)))
;; 
;; (provide 'hot-take)
;; ;;; hot-take.el ends here




;; ;;; hot-take.el --- Review AI code while it's still hot -*- lexical-binding: t; -*-
;; 
;; (require 'cl-lib)
;; (require 'subr-x)
;; (require 'project)
;; (require 'diff-mode)
;; (require 'evil nil t)
;; 
;; (defgroup hot-take nil "Review AI code." :group 'tools :prefix "hot-take-")
;; 
;; (defcustom hot-take-backend-command '("llm" "-m" "gpt-4o") "Backend command." :type '(repeat string))
;; (defcustom hot-take-queue-width 30 "Queue width." :type 'integer)
;; (defcustom hot-take-chat-width 40 "Chat width." :type 'integer)
;; (defcustom hot-take-code-popup-height 0.45 "Popup height." :type 'number)
;; (defcustom hot-take-system-prompt "You are a senior engineer." "Preamble." :type 'string)
;; (defcustom hot-take-discuss-hook nil "Discuss hook." :type 'hook)
;; 
;; (defvar hot-take-backend-function nil "Lisp function backend.")
;; (defvar hot-take--session nil)
;; (defvar hot-take--layout nil)
;; (defvar hot-take--frame nil)
;; 
;; (cl-defstruct hot-take-session root files index decisions)
;; 
;; ;;;; Git
;; 
;; (defun hot-take--root ()
;;   (or (when-let ((p (project-current))) (project-root p)) default-directory))
;; 
;; (defun hot-take--git-in (root &rest args)
;;   (let ((default-directory root))
;;     (with-temp-buffer
;;       (unless (zerop (apply #'call-process "git" nil t nil args))
;;         (error "git failed"))
;;       (buffer-string))))
;; 
;; (defun hot-take--git-optional-in (root &rest args)
;;   (let ((default-directory root))
;;     (with-temp-buffer
;;       (when (zerop (apply #'call-process "git" nil t nil args))
;;         (buffer-string)))))
;; 
;; (defun hot-take--changed-files-at (root)
;;   (let ((default-directory root))
;;     (dolist (f (split-string
;;                 (or (with-temp-buffer
;;                       (when (zerop (call-process "git" nil t nil "ls-files" "--others" "--exclude-standard"))
;;                         (buffer-string)))
;;                     "")
;;                 "\n" t))
;;       (ignore-errors (call-process "git" nil nil nil "add" "-N" "--" f))))
;;   (split-string (string-trim (hot-take--git-in root "diff" "--name-only" "HEAD")) "\n" t))
;; 
;; (defun hot-take--git (&rest args)
;;   (apply #'hot-take--git-in (hot-take-session-root hot-take--session) args))
;; 
;; (defun hot-take--git-optional (&rest args)
;;   (apply #'hot-take--git-optional-in (hot-take-session-root hot-take--session) args))
;; 
;; ;;;; Backend
;; 
;; (defun hot-take--send-to-backend (prompt)
;;   (cond
;;    (hot-take-backend-function (funcall hot-take-backend-function prompt))
;;    ((null hot-take-backend-command) "(no backend)")
;;    (t
;;     (with-temp-buffer
;;       (insert prompt)
;;       (message "Waiting for AI...")
;;       (let ((exit (apply #'call-process-region (point-min) (point-max)
;;                          (car hot-take-backend-command) t t nil (cdr hot-take-backend-command))))
;;         (if (zerop exit) (string-trim (buffer-string))
;;           (format "(backend failed: %d)" exit)))))))
;; 
;; ;;;; Chat buffer
;; 
;; (define-derived-mode hot-take-chat-mode special-mode "hot-take-chat"
;;   (setq truncate-lines nil)
;;   (setq-local line-spacing 2))
;; 
;; (defun hot-take--ensure-chat-buffer ()
;;   (let ((buf (get-buffer-create "*hot-take chat*")))
;;     (with-current-buffer buf
;;       (unless (derived-mode-p 'hot-take-chat-mode) (hot-take-chat-mode))
;;       (when (= (point-min) (point-max))
;;         (let ((inhibit-read-only t))
;;           (insert (propertize " hot-take chat\n" 'face 'bold)
;;                   (propertize " C-c C-s to send prompt\n\n" 'face 'italic)))))
;;     buf))
;; 
;; (defun hot-take--chat-append (text)
;;   (with-current-buffer (hot-take--ensure-chat-buffer)
;;     (let ((inhibit-read-only t))
;;       (goto-char (point-max))
;;       (insert text))))
;; 
;; (defun hot-take-chat-send (prompt)
;;   (interactive (list (read-string "→ ")))
;;   (when (or (null prompt) (string-empty-p (string-trim prompt))) (user-error "Empty prompt"))
;;   (hot-take--chat-append (format "\n%s %s\n" (propertize "You:" 'face 'bold) prompt))
;;   (let ((reply (condition-case err
;;                    (hot-take--send-to-backend (format "%s\n\n%s" hot-take-system-prompt prompt))
;;                  (error (format "(error: %s)" err)))))
;;     (hot-take--chat-append (format "%s %s\n" (propertize "AI:" 'face 'bold) reply)))
;;   (hot-take-refresh)
;;   (when (> (length (hot-take-session-files hot-take--session)) 0)
;;     (message "Files changed — C-c C-l to review")))
;; 
;; ;;;; Queue
;; 
;; (defface hot-take-current-face '((t :background "gray25" :weight bold :extend t)) "Current row in queue.")
;; (defface hot-take-accept-face  '((t :foreground "green" :weight bold)) "Accepted file.")
;; (defface hot-take-reject-face  '((t :foreground "red" :strikethrough t)) "Rejected file.")
;; (defface hot-take-discuss-face '((t :foreground "orange" :weight bold)) "File under discussion.")
;; 
;; (defconst hot-take--decision-face
;;   '((accept . hot-take-accept-face)
;;     (reject . hot-take-reject-face)
;;     (discuss . hot-take-discuss-face)))
;; 
;; (define-derived-mode hot-take-queue-mode special-mode "hot-take-queue"
;;   (setq truncate-lines t))
;; 
;; (defun hot-take--render-queue ()
;;   (with-current-buffer (get-buffer-create "*hot-take queue*")
;;     (let ((inhibit-read-only t))
;;       (erase-buffer)
;;       (insert (format " QUEUE (%d files)\n" (length (hot-take-session-files hot-take--session)))
;;               (make-string 28 ?-) "\n")
;;       (cl-loop
;;        for file in (hot-take-session-files hot-take--session)
;;        for i from 0
;;        for dec = (alist-get file (hot-take-session-decisions hot-take--session) nil nil #'string=)
;;        do (let ((start (point)))
;;             (insert (format "%c %s" (if (= i (hot-take-session-index hot-take--session)) ?> ?\s) file))
;;             (when (= i (hot-take-session-index hot-take--session))
;;               (add-face-text-property start (point) 'hot-take-current-face t))
;;             (when dec
;;               (insert " ")
;;               (let ((s (point)))
;;                 (insert (format "[%s]" dec))
;;                 (add-face-text-property s (point) (alist-get dec hot-take--decision-face) t)))
;;             (insert "\n")))
;;       (goto-char (point-min)))
;;     (hot-take-queue-mode)
;;     (current-buffer)))
;; 
;; ;;;; Diff
;; 
;; (define-derived-mode hot-take-diff-mode diff-mode "hot-take-diff")
;; 
;; (defun hot-take--current-file ()
;;   (let ((files (hot-take-session-files hot-take--session))
;;         (idx (hot-take-session-index hot-take--session)))
;;     (when (and files (< idx (length files))) (nth idx files))))
;; 
;; (defun hot-take--refresh-diff ()
;;   (let* ((file (hot-take--current-file))
;;          (buf  (get-buffer-create "*hot-take diff*")))
;;     (with-current-buffer buf
;;       (let ((inhibit-read-only t))
;;         (erase-buffer)
;;         (if file
;;             (hot-take--insert-diff-for file)
;;           (insert ";; No files.\n"))
;;         (hot-take-diff-mode)
;;         (setq-local default-directory (hot-take-session-root hot-take--session))
;;         (goto-char (point-min))))
;;     buf))
;; 
;; (defun hot-take--insert-diff-for (file)
;;   (let ((diff (hot-take--git "diff" "HEAD" "--" file)))
;;     (insert (if (string-empty-p diff)
;;                 (format ";; No diff for %s\n" file)
;;               diff)))
;;   (setq header-line-format
;;         (format " DIFF: %s [%d/%d]   (a)ccept (r)eject (d)iscuss   (q)uit"
;;                 file
;;                 (1+ (hot-take-session-index hot-take--session))
;;                 (length (hot-take-session-files hot-take--session)))))
;; 
;; ;;;; Popup
;; 
;; (defvar hot-take-code-mode-map
;;   (let ((map (make-sparse-keymap)))
;;     (define-key map (kbd "C-c C-c") #'hot-take-close-popup)
;;     (define-key map (kbd "C-c C-a") #'hot-take-accept-current)
;;     (define-key map (kbd "C-c C-r") #'hot-take-reject-current)
;;     map))
;; 
;; (define-minor-mode hot-take-code-mode "Popup mode." :lighter " hot-take" :keymap hot-take-code-mode-map)
;; 
;; (defun hot-take--hunk-target ()
;;   (save-excursion
;;     (unless (looking-at "^@@") (diff-hunk-next))
;;     (beginning-of-line)
;;     (let* ((names (ignore-errors (diff-hunk-file-names)))
;;            (file (or (cadr names) (car names)))
;;            (hdr (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
;;            (line (if (string-match "@@ [^+]*\\+\\([0-9]+\\)" hdr) (string-to-number (match-string 1 hdr)) 1)))
;;       (cons file line))))
;; 
;; (defun hot-take-open-hunk-popup ()
;;   (interactive)
;;   (let* ((file-line (hot-take--hunk-target))
;;          (file (car file-line))
;;          (line (cdr file-line)))
;;     (unless file (user-error "Not on a hunk"))
;;     (let* ((root (hot-take-session-root hot-take--session))
;;            (abs (expand-file-name file root))
;;            (buf (find-file-noselect abs)))
;;       (with-current-buffer buf
;;         (goto-char (point-min)) (forward-line (1- (max 1 line))) (recenter 0)
;;         (hot-take-code-mode 1))
;;       (display-buffer buf `((display-buffer-below-selected) (window-height . ,hot-take-code-popup-height))))))
;; 
;; (defun hot-take-close-popup ()
;;   (interactive)
;;   (when-let ((win (get-buffer-window (current-buffer)))) (quit-window nil win))
;;   (switch-to-buffer (hot-take--refresh-diff)))
;; 
;; ;;;; Actions
;; 
;; (defun hot-take--decide-current (decision)
;;   (let ((file (hot-take--current-file)))
;;     (unless file (user-error "No current file"))
;;     (cl-pushnew (cons file decision) (hot-take-session-decisions hot-take--session)
;;                 :test (lambda (a b) (string= (car a) (car b))))
;;     (pcase decision
;;       ('accept
;;        (when-let ((buf (get-file-buffer (expand-file-name file (hot-take-session-root hot-take--session)))))
;;          (when (buffer-modified-p buf) (with-current-buffer buf (save-buffer))))
;;        (hot-take--git "add" "--" file)
;;        (message "Accepted %s" file))
;;       ('reject
;;        (let* ((root (hot-take-session-root hot-take--session))
;;               (dir (expand-file-name ".hot-take-rejected" root))
;;               (basename (replace-regexp-in-string "[/\\]" "_" file))
;;               (patch (expand-file-name (format "%s-%s.patch" (format-time-string "%Y%m%d-%H%M%S") basename) dir))
;;               (exists (hot-take--git-optional "cat-file" "-e" (format "HEAD:%s" file))))
;;          (make-directory dir t)
;;          (with-temp-file patch (insert (hot-take--git "diff" "HEAD" "--" file)))
;;          (if exists
;;              (hot-take--git "checkout" "HEAD" "--" file)
;;            (delete-file (expand-file-name file root))
;;            (ignore-errors (hot-take--git "rm" "--cached" "--force" "--" file)))
;;          (message "Rejected %s" file)))
;;       ('discuss
;;        (hot-take--chat-append (format "\nDiscussing %s\n" file))
;;        (when hot-take-discuss-hook (run-hook-with-args 'hot-take-discuss-hook file (hot-take--git "diff" "HEAD" "--" file) nil))))
;;     (hot-take--advance)))
;; 
;; (defun hot-take--advance ()
;;   (let* ((files (hot-take-session-files hot-take--session))
;;          (idx (hot-take-session-index hot-take--session))
;;          (n (length files)))
;;     (if (< idx (1- n))
;;         (progn
;;           (setf (hot-take-session-index hot-take--session) (1+ idx))
;;           (hot-take--render-queue) (switch-to-buffer (hot-take--refresh-diff)))
;;       (hot-take-refresh)
;;       (if (cl-some (lambda (f) (null (alist-get f (hot-take-session-decisions hot-take--session) nil nil #'string=))) (hot-take-session-files hot-take--session))
;;           (progn (setf (hot-take-session-index hot-take--session) 0)
;;                  (hot-take--render-queue) (switch-to-buffer (hot-take--refresh-diff)))
;;         (hot-take--setup-chat) (message "Review complete — Q to exit")))))
;; 
;; (defun hot-take-accept-current () (interactive) (hot-take--decide-current 'accept))
;; (defun hot-take-reject-current () (interactive) (hot-take--decide-current 'reject))
;; (defun hot-take-discuss-current () (interactive) (hot-take--decide-current 'discuss))
;; 
;; (defun hot-take-refresh ()
;;   (when hot-take--session
;;     (let* ((root (hot-take-session-root hot-take--session))
;;            (files (hot-take--changed-files-at root))
;;            (idx (hot-take-session-index hot-take--session)))
;;       (setf (hot-take-session-files hot-take--session) files)
;;       (when (and files (>= idx (length files)))
;;         (setf (hot-take-session-index hot-take--session) (max 0 (1- (length files)))))
;;       (if (and (null files) (eq hot-take--layout 'review))
;;           (hot-take--setup-chat)
;;         (progn
;;           (when (get-buffer "*hot-take queue*") (hot-take--render-queue))
;;           (when (and (eq hot-take--layout 'review) files)
;;             (unless (eq (current-buffer) (get-buffer "*hot-take diff*"))
;;               (with-current-buffer (hot-take--refresh-diff) nil))))))))
;; 
;; ;;;; Navigation
;; 
;; (defun hot-take-queue-next ()
;;   (interactive)
;;   (when (< (hot-take-session-index hot-take--session) (1- (length (hot-take-session-files hot-take--session))))
;;     (setf (hot-take-session-index hot-take--session) (1+ (hot-take-session-index hot-take--session)))
;;     (hot-take--render-queue) (switch-to-buffer (hot-take--refresh-diff))))
;; 
;; (defun hot-take-queue-prev ()
;;   (interactive)
;;   (when (> (hot-take-session-index hot-take--session) 0)
;;     (setf (hot-take-session-index hot-take--session) (1- (hot-take-session-index hot-take--session)))
;;     (hot-take--render-queue) (switch-to-buffer (hot-take--refresh-diff))))
;; 
;; (defun hot-take-queue-focus-diff ()
;;   (interactive)
;;   (switch-to-buffer (hot-take--refresh-diff)))
;; 
;; ;;;; Layout
;; 
;; (defun hot-take--setup-chat ()
;;   (setq hot-take--layout 'chat)
;;   (delete-other-windows)
;;   (switch-to-buffer (hot-take--ensure-chat-buffer))
;;   (goto-char (point-max))
;;   (message "Chat — C-c C-s send, Q exit"))
;; 
;; (defun hot-take--setup-review ()
;;   (hot-take-refresh)
;;   (if (null (hot-take-session-files hot-take--session))
;;       (hot-take--setup-chat)
;;     (setq hot-take--layout 'review)
;;     (delete-other-windows)
;;     (display-buffer-in-side-window (hot-take--render-queue)
;;       `((side . left) (slot . 0) (window-width . ,hot-take-queue-width)))
;;     (display-buffer-in-side-window (hot-take--ensure-chat-buffer)
;;       `((side . right) (slot . 0) (window-width . ,hot-take-chat-width)))
;;     (select-window (get-largest-window))
;;     (switch-to-buffer (hot-take--refresh-diff))
;;     (message "Review — TAB switch pane, j/k move, a/r/d decide, Q exit")))
;; 
;; (defun hot-take-toggle-layout ()
;;   (interactive)
;;   (unless hot-take--session (user-error "No active session"))
;;   (pcase hot-take--layout
;;     ('chat (if (hot-take-session-files hot-take--session) (hot-take--setup-review) (message "No files.")))
;;     ('review (hot-take--setup-chat))))
;; 
;; (defun hot-take-exit ()
;;   (interactive)
;;   (setq hot-take--session nil hot-take--layout nil)
;;   (when (frame-live-p hot-take--frame) (delete-frame hot-take--frame))
;;   (setq hot-take--frame nil)
;;   (message "Left hot-take"))
;; 
;; ;;;###autoload
;; (defun hot-take (&optional force-chat)
;;   (interactive "P")
;;   (if hot-take--session
;;       (progn (hot-take-refresh)
;;              (if (or force-chat (null (hot-take-session-files hot-take--session)))
;;                  (hot-take--setup-chat) (hot-take--setup-review)))
;;     (let* ((root (hot-take--root)) (files (hot-take--changed-files-at root)))
;;       (setq hot-take--session (make-hot-take-session :root root :files files :index 0 :decisions nil))
;;       (setq hot-take--frame (make-frame '((name . "hot-take") (width . 200) (height . 50) (minibuffer . nil))))
;;       (select-frame hot-take--frame)
;;       (if (or force-chat (null files)) (hot-take--setup-chat) (hot-take--setup-review)))))
;; 
;; ;;;; Keybindings
;; 
;; (define-key hot-take-queue-mode-map (kbd "TAB") #'other-window)
;; (define-key hot-take-diff-mode-map  (kbd "TAB") #'other-window)
;; (define-key hot-take-chat-mode-map  (kbd "TAB") #'other-window)
;; 
;; (define-key hot-take-queue-mode-map (kbd "RET") #'hot-take-queue-focus-diff)
;; (define-key hot-take-queue-mode-map (kbd "C-c C-l") #'hot-take-toggle-layout)
;; (define-key hot-take-queue-mode-map (kbd "Q") #'hot-take-exit)
;; (define-key hot-take-diff-mode-map (kbd "RET") #'hot-take-open-hunk-popup)
;; (define-key hot-take-diff-mode-map (kbd "C-c C-s") #'hot-take-chat-send)
;; (define-key hot-take-diff-mode-map (kbd "Q") #'hot-take-exit)
;; (define-key hot-take-chat-mode-map (kbd "C-c C-s") #'hot-take-chat-send)
;; (define-key hot-take-chat-mode-map (kbd "C-c C-l") #'hot-take-toggle-layout)
;; (define-key hot-take-chat-mode-map (kbd "Q") #'hot-take-exit)
;; 
;; (with-eval-after-load 'evil
;;   (evil-define-key 'normal hot-take-queue-mode-map
;;     (kbd "j") #'hot-take-queue-next
;;     (kbd "k") #'hot-take-queue-prev
;;     (kbd "RET") #'hot-take-queue-focus-diff
;;     (kbd "a") #'hot-take-accept-current
;;     (kbd "r") #'hot-take-reject-current
;;     (kbd "d") #'hot-take-discuss-current
;;     (kbd "q") #'hot-take-exit
;;     (kbd "Q") #'hot-take-exit)
;;   (evil-define-key 'normal hot-take-diff-mode-map
;;     (kbd "RET") #'hot-take-open-hunk-popup
;;     (kbd "a") #'hot-take-accept-current
;;     (kbd "r") #'hot-take-reject-current
;;     (kbd "d") #'hot-take-discuss-current
;;     (kbd "q") #'hot-take-exit
;;     (kbd "Q") #'hot-take-exit)
;;   (evil-define-key 'normal hot-take-code-mode-map
;;     (kbd "q") #'hot-take-close-popup
;;     (kbd "C-c C-c") #'hot-take-close-popup))
;; 
;; (provide 'hot-take)
;; ;;; hot-take.el ends here



;;; hot-take.el --- Review AI code while it's still hot -*- lexical-binding: t; -*-

(require 'cl-lib)
(require 'subr-x)
(require 'project)
(require 'diff-mode)
(require 'evil nil t)

(defgroup hot-take nil "Review AI code." :group 'tools :prefix "hot-take-")

(defcustom hot-take-backend-command '("llm" "-m" "gpt-4o") "Backend command." :type '(repeat string))
(defcustom hot-take-queue-width 30 "Queue width." :type 'integer)
(defcustom hot-take-chat-width 40 "Chat width." :type 'integer)
(defcustom hot-take-code-popup-height 0.45 "Popup height." :type 'number)
(defcustom hot-take-system-prompt "You are a senior engineer." "Preamble." :type 'string)
(defcustom hot-take-discuss-hook nil "Discuss hook." :type 'hook)

(defvar hot-take-backend-function nil "Lisp function backend.")
(defvar hot-take--session nil)
(defvar hot-take--layout nil)
(defvar hot-take--saved-window-config nil
  "Window configuration saved before entering hot-take; restored on exit.")

(cl-defstruct hot-take-session root files index decisions)

;;;; Git

(defun hot-take--root ()
  (or (when-let ((p (project-current))) (project-root p)) default-directory))

(defun hot-take--git-in (root &rest args)
  (let ((default-directory root))
    (with-temp-buffer
      (unless (zerop (apply #'call-process "git" nil t nil args))
        (error "git failed"))
      (buffer-string))))

(defun hot-take--git-optional-in (root &rest args)
  (let ((default-directory root))
    (with-temp-buffer
      (when (zerop (apply #'call-process "git" nil t nil args))
        (buffer-string)))))

(defun hot-take--changed-files-at (root)
  (let ((default-directory root))
    (dolist (f (split-string
                (or (with-temp-buffer
                      (when (zerop (call-process "git" nil t nil "ls-files" "--others" "--exclude-standard"))
                        (buffer-string)))
                    "")
                "\n" t))
      (ignore-errors (call-process "git" nil nil nil "add" "-N" "--" f))))
  (split-string (string-trim (hot-take--git-in root "diff" "--name-only" "HEAD")) "\n" t))

(defun hot-take--git (&rest args)
  (apply #'hot-take--git-in (hot-take-session-root hot-take--session) args))

(defun hot-take--git-optional (&rest args)
  (apply #'hot-take--git-optional-in (hot-take-session-root hot-take--session) args))

;;;; Backend

(defun hot-take--send-to-backend (prompt)
  (cond
   (hot-take-backend-function (funcall hot-take-backend-function prompt))
   ((null hot-take-backend-command) "(no backend)")
   (t
    (with-temp-buffer
      (insert prompt)
      (message "Waiting for AI...")
      (let ((exit (apply #'call-process-region (point-min) (point-max)
                         (car hot-take-backend-command) t t nil (cdr hot-take-backend-command))))
        (if (zerop exit) (string-trim (buffer-string))
          (format "(backend failed: %d)" exit)))))))

;;;; Chat buffer

(define-derived-mode hot-take-chat-mode special-mode "hot-take-chat"
  (setq truncate-lines nil)
  (setq-local line-spacing 2))

(defun hot-take--ensure-chat-buffer ()
  (let ((buf (get-buffer-create "*hot-take chat*")))
    (with-current-buffer buf
      (unless (derived-mode-p 'hot-take-chat-mode) (hot-take-chat-mode))
      (when (= (point-min) (point-max))
        (let ((inhibit-read-only t))
          (insert (propertize " hot-take chat\n" 'face 'bold)
                  (propertize " C-c C-s to send prompt\n\n" 'face 'italic)))))
    buf))

(defun hot-take--chat-append (text)
  (with-current-buffer (hot-take--ensure-chat-buffer)
    (let ((inhibit-read-only t))
      (goto-char (point-max))
      (insert text))))

(defun hot-take-chat-send (prompt)
  (interactive (list (read-string "→ ")))
  (when (or (null prompt) (string-empty-p (string-trim prompt))) (user-error "Empty prompt"))
  (hot-take--chat-append (format "\n%s %s\n" (propertize "You:" 'face 'bold) prompt))
  (let ((reply (condition-case err
                   (hot-take--send-to-backend (format "%s\n\n%s" hot-take-system-prompt prompt))
                 (error (format "(error: %s)" err)))))
    (hot-take--chat-append (format "%s %s\n" (propertize "AI:" 'face 'bold) reply)))
  (hot-take-refresh)
  (when (> (length (hot-take-session-files hot-take--session)) 0)
    (message "Files changed — C-c C-l to review")))

;;;; Queue

(defface hot-take-current-face '((t :background "gray25" :weight bold :extend t)) "Current row in queue.")
(defface hot-take-accept-face  '((t :foreground "green" :weight bold)) "Accepted file.")
(defface hot-take-reject-face  '((t :foreground "red" :strikethrough t)) "Rejected file.")
(defface hot-take-discuss-face '((t :foreground "orange" :weight bold)) "File under discussion.")

(defconst hot-take--decision-face
  '((accept . hot-take-accept-face)
    (reject . hot-take-reject-face)
    (discuss . hot-take-discuss-face)))

(define-derived-mode hot-take-queue-mode special-mode "hot-take-queue"
  (setq truncate-lines t))

(defun hot-take--render-queue ()
  (with-current-buffer (get-buffer-create "*hot-take queue*")
    (let ((inhibit-read-only t))
      (erase-buffer)
      (insert (format " QUEUE (%d files)\n" (length (hot-take-session-files hot-take--session)))
              (make-string 28 ?-) "\n")
      (cl-loop
       for file in (hot-take-session-files hot-take--session)
       for i from 0
       for dec = (alist-get file (hot-take-session-decisions hot-take--session) nil nil #'string=)
       do (let ((start (point)))
            (insert (format "%c %s" (if (= i (hot-take-session-index hot-take--session)) ?> ?\s) file))
            (when (= i (hot-take-session-index hot-take--session))
              (add-face-text-property start (point) 'hot-take-current-face t))
            (when dec
              (insert " ")
              (let ((s (point)))
                (insert (format "[%s]" dec))
                (add-face-text-property s (point) (alist-get dec hot-take--decision-face) t)))
            (insert "\n")))
      (goto-char (point-min)))
    (hot-take-queue-mode)
    (current-buffer)))

;;;; Diff

(define-derived-mode hot-take-diff-mode diff-mode "hot-take-diff")

(defun hot-take--current-file ()
  (let ((files (hot-take-session-files hot-take--session))
        (idx (hot-take-session-index hot-take--session)))
    (when (and files (< idx (length files))) (nth idx files))))

(defun hot-take--refresh-diff ()
  (let* ((file (hot-take--current-file))
         (buf  (get-buffer-create "*hot-take diff*")))
    (with-current-buffer buf
      (let ((inhibit-read-only t))
        (erase-buffer)
        (if file
            (hot-take--insert-diff-for file)
          (insert ";; No files.\n"))
        (hot-take-diff-mode)
        (setq-local default-directory (hot-take-session-root hot-take--session))
        (goto-char (point-min))))
    buf))

(defun hot-take--insert-diff-for (file)
  (let ((diff (hot-take--git "diff" "HEAD" "--" file)))
    (insert (if (string-empty-p diff)
                (format ";; No diff for %s\n" file)
              diff)))
  (setq header-line-format
        (format " DIFF: %s [%d/%d]   (a)ccept (r)eject (d)iscuss   (q)uit"
                file
                (1+ (hot-take-session-index hot-take--session))
                (length (hot-take-session-files hot-take--session)))))

;;;; Popup

(defvar hot-take-code-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c C-c") #'hot-take-close-popup)
    (define-key map (kbd "C-c C-a") #'hot-take-accept-current)
    (define-key map (kbd "C-c C-r") #'hot-take-reject-current)
    map))

(define-minor-mode hot-take-code-mode "Popup mode." :lighter " hot-take" :keymap hot-take-code-mode-map)

(defun hot-take--hunk-target ()
  (save-excursion
    (unless (looking-at "^@@") (diff-hunk-next))
    (beginning-of-line)
    (let* ((names (ignore-errors (diff-hunk-file-names)))
           (file (or (cadr names) (car names)))
           (hdr (buffer-substring-no-properties (line-beginning-position) (line-end-position)))
           (line (if (string-match "@@ [^+]*\\+\\([0-9]+\\)" hdr) (string-to-number (match-string 1 hdr)) 1)))
      (cons file line))))

(defun hot-take-open-hunk-popup ()
  (interactive)
  (let* ((file-line (hot-take--hunk-target))
         (file (car file-line))
         (line (cdr file-line)))
    (unless file (user-error "Not on a hunk"))
    (let* ((root (hot-take-session-root hot-take--session))
           (abs (expand-file-name file root))
           (buf (find-file-noselect abs)))
      (with-current-buffer buf
        (goto-char (point-min)) (forward-line (1- (max 1 line))) (recenter 0)
        (hot-take-code-mode 1))
      (display-buffer buf `((display-buffer-below-selected) (window-height . ,hot-take-code-popup-height))))))

(defun hot-take-close-popup ()
  (interactive)
  (when-let ((win (get-buffer-window (current-buffer)))) (quit-window nil win))
  (switch-to-buffer (hot-take--refresh-diff)))

;;;; Actions

(defun hot-take--decide-current (decision)
  (let ((file (hot-take--current-file)))
    (unless file (user-error "No current file"))
    (cl-pushnew (cons file decision) (hot-take-session-decisions hot-take--session)
                :test (lambda (a b) (string= (car a) (car b))))
    (pcase decision
      ('accept
       (when-let ((buf (get-file-buffer (expand-file-name file (hot-take-session-root hot-take--session)))))
         (when (buffer-modified-p buf) (with-current-buffer buf (save-buffer))))
       (hot-take--git "add" "--" file)
       (message "Accepted %s" file))
      ('reject
       (let* ((root (hot-take-session-root hot-take--session))
              (dir (expand-file-name ".hot-take-rejected" root))
              (basename (replace-regexp-in-string "[/\\]" "_" file))
              (patch (expand-file-name (format "%s-%s.patch" (format-time-string "%Y%m%d-%H%M%S") basename) dir))
              (exists (hot-take--git-optional "cat-file" "-e" (format "HEAD:%s" file))))
         (make-directory dir t)
         (with-temp-file patch (insert (hot-take--git "diff" "HEAD" "--" file)))
         (if exists
             (hot-take--git "checkout" "HEAD" "--" file)
           (delete-file (expand-file-name file root))
           (ignore-errors (hot-take--git "rm" "--cached" "--force" "--" file)))
         (message "Rejected %s" file)))
      ('discuss
       (hot-take--chat-append (format "\nDiscussing %s\n" file))
       (when hot-take-discuss-hook (run-hook-with-args 'hot-take-discuss-hook file (hot-take--git "diff" "HEAD" "--" file) nil))))
    (hot-take--advance)))

(defun hot-take--advance ()
  (let* ((files (hot-take-session-files hot-take--session))
         (idx (hot-take-session-index hot-take--session))
         (n (length files)))
    (if (< idx (1- n))
        (progn
          (setf (hot-take-session-index hot-take--session) (1+ idx))
          (hot-take--render-queue) (switch-to-buffer (hot-take--refresh-diff)))
      (hot-take-refresh)
      (if (cl-some (lambda (f) (null (alist-get f (hot-take-session-decisions hot-take--session) nil nil #'string=))) (hot-take-session-files hot-take--session))
          (progn (setf (hot-take-session-index hot-take--session) 0)
                 (hot-take--render-queue) (switch-to-buffer (hot-take--refresh-diff)))
        (hot-take--setup-chat) (message "Review complete — Q to exit")))))

(defun hot-take-accept-current () (interactive) (hot-take--decide-current 'accept))
(defun hot-take-reject-current () (interactive) (hot-take--decide-current 'reject))
(defun hot-take-discuss-current () (interactive) (hot-take--decide-current 'discuss))

(defun hot-take-refresh ()
  (when hot-take--session
    (let* ((root (hot-take-session-root hot-take--session))
           (files (hot-take--changed-files-at root))
           (idx (hot-take-session-index hot-take--session)))
      (setf (hot-take-session-files hot-take--session) files)
      (when (and files (>= idx (length files)))
        (setf (hot-take-session-index hot-take--session) (max 0 (1- (length files)))))
      (if (and (null files) (eq hot-take--layout 'review))
          (hot-take--setup-chat)
        (progn
          (when (get-buffer "*hot-take queue*") (hot-take--render-queue))
          (when (and (eq hot-take--layout 'review) files)
            (unless (eq (current-buffer) (get-buffer "*hot-take diff*"))
              (with-current-buffer (hot-take--refresh-diff) nil))))))))

;;;; Navigation

(defun hot-take-queue-next ()
  (interactive)
  (when (< (hot-take-session-index hot-take--session) (1- (length (hot-take-session-files hot-take--session))))
    (setf (hot-take-session-index hot-take--session) (1+ (hot-take-session-index hot-take--session)))
    (hot-take--render-queue) (switch-to-buffer (hot-take--refresh-diff))))

(defun hot-take-queue-prev ()
  (interactive)
  (when (> (hot-take-session-index hot-take--session) 0)
    (setf (hot-take-session-index hot-take--session) (1- (hot-take-session-index hot-take--session)))
    (hot-take--render-queue) (switch-to-buffer (hot-take--refresh-diff))))

(defun hot-take-queue-focus-diff ()
  (interactive)
  (switch-to-buffer (hot-take--refresh-diff)))

;;;; Layout

(defun hot-take--setup-chat ()
  (setq hot-take--layout 'chat)
  (delete-other-windows)
  (switch-to-buffer (hot-take--ensure-chat-buffer))
  (goto-char (point-max))
  (message "Chat — C-c C-s send, Q exit"))

(defun hot-take--setup-review ()
  (hot-take-refresh)
  (if (null (hot-take-session-files hot-take--session))
      (hot-take--setup-chat)
    (setq hot-take--layout 'review)
    (delete-other-windows)
    (display-buffer-in-side-window (hot-take--render-queue)
      `((side . left) (slot . 0) (window-width . ,hot-take-queue-width)))
    (display-buffer-in-side-window (hot-take--ensure-chat-buffer)
      `((side . right) (slot . 0) (window-width . ,hot-take-chat-width)))
    (select-window (get-largest-window))
    (switch-to-buffer (hot-take--refresh-diff))
    (message "Review — TAB switch pane, j/k move, a/r/d decide, Q exit")))

(defun hot-take-toggle-layout ()
  (interactive)
  (unless hot-take--session (user-error "No active session"))
  (pcase hot-take--layout
    ('chat (if (hot-take-session-files hot-take--session) (hot-take--setup-review) (message "No files.")))
    ('review (hot-take--setup-chat))))

(defun hot-take-exit ()
  (interactive)
  (setq hot-take--session nil hot-take--layout nil)
  (when hot-take--saved-window-config
    (set-window-configuration hot-take--saved-window-config)
    (setq hot-take--saved-window-config nil))
  (message "Left hot-take"))

;;;###autoload
(defun hot-take (&optional force-chat)
  (interactive "P")
  (if hot-take--session
      (progn (hot-take-refresh)
             (if (or force-chat (null (hot-take-session-files hot-take--session)))
                 (hot-take--setup-chat) (hot-take--setup-review)))
    (let* ((root (hot-take--root)) (files (hot-take--changed-files-at root)))
      (setq hot-take--saved-window-config (current-window-configuration))
      (setq hot-take--session (make-hot-take-session :root root :files files :index 0 :decisions nil))
      (if (or force-chat (null files))
          (hot-take--setup-chat)
        (hot-take--setup-review)))))

;;;; Keybindings

(define-key hot-take-queue-mode-map (kbd "TAB") #'other-window)
(define-key hot-take-diff-mode-map  (kbd "TAB") #'other-window)
(define-key hot-take-chat-mode-map  (kbd "TAB") #'other-window)

(define-key hot-take-queue-mode-map (kbd "RET") #'hot-take-queue-focus-diff)
(define-key hot-take-queue-mode-map (kbd "C-c C-l") #'hot-take-toggle-layout)
(define-key hot-take-queue-mode-map (kbd "Q") #'hot-take-exit)
(define-key hot-take-diff-mode-map (kbd "RET") #'hot-take-open-hunk-popup)
(define-key hot-take-diff-mode-map (kbd "C-c C-s") #'hot-take-chat-send)
(define-key hot-take-diff-mode-map (kbd "Q") #'hot-take-exit)
(define-key hot-take-chat-mode-map (kbd "C-c C-s") #'hot-take-chat-send)
(define-key hot-take-chat-mode-map (kbd "C-c C-l") #'hot-take-toggle-layout)
(define-key hot-take-chat-mode-map (kbd "Q") #'hot-take-exit)

(with-eval-after-load 'evil
  (evil-define-key 'normal hot-take-queue-mode-map
    (kbd "j") #'hot-take-queue-next
    (kbd "k") #'hot-take-queue-prev
    (kbd "RET") #'hot-take-queue-focus-diff
    (kbd "a") #'hot-take-accept-current
    (kbd "r") #'Qhot-take-reject-current
    (kbd "d") #'hot-take-discuss-current
    (kbd "q") #'hot-take-exit
    (kbd "Q") #'hot-take-exit)
  (evil-define-key 'normal hot-take-diff-mode-map
    (kbd "RET") #'hot-take-open-hunk-popup
    (kbd "a") #'hot-take-accept-current
    (kbd "r") #'hot-take-reject-current
    (kbd "d") #'hot-take-discuss-current
    (kbd "q") #'hot-take-exit
    (kbd "Q") #'hot-take-exit)
  (evil-define-key 'normal hot-take-code-mode-map
    (kbd "q") #'hot-take-close-popup
    (kbd "C-c C-c") #'hot-take-close-popup))

(provide 'hot-take)
;;; hot-take.el ends here
