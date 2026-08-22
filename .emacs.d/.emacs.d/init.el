;; input


;; magit
(ilusia-layer 'version-control)



(set-face-attribute 'default nil :family "JetBrainsMono Nerd Font" :height 130)
(set-face-attribute 'mode-line nil :height 85 :inherit 'fixed-pitch)

(setq org-edit-src-content-indentation 0)

(ilusia-module 'consult)
(ilusia-module 'marginalia)
(ilusia-module 'orderless)
(ilusia-module 'undo-tree)
(ilusia-module 'vertico)
(ilusia-module 'vterm)
(toggle-frame-maximized);; очень удобная настройка 
;; (ilusia-layer 'treesitter)

(ilusia-layer 'ide)
(ilusia-layer 'languages)

(ilusia-layer 'ui-base)
(ilusia-layer 'dashboard)

(ilusia-module 'ef-themes)
;; Theme

;; Typography
(set-face-attribute 'default nil
                    :family "JetBrainsMono Nerd Font"
                    :height 130)
;; Current line
(add-hook 'prog-mode-hook #'hl-line-mode)

;; (set-face-attribute 'hl-line nil
;;                     :background "#2b2b2b")

(ilusia-layer 'modeline-doom)

(ilusia-layer 'version-control)

(ilusia-module 'evil)

(ilusia-layer 'input-editing)
(ilusia-module 'which-key)

(ilusia-layer 'navigation)

(ilusia-layer 'file-management)

(use-package c-ts-mode
  :ensure nil
  :mode
  ("\\.c\\'" . c-ts-mode)
  ("\\.h\\'" . c-or-c++-ts-mode)
  ("\\.cpp\\'" . c++-ts-mode)
  ("\\.hpp\\'" . c++-ts-mode)

  :bind
  (:map c-ts-mode-map
    ("<f1>" . my-c/make-clean)
    ("<f2>" . my-c/make-all)
    ("<f3>" . my-c/make-run))

  :config

  (c-ts-indent-offset 4)
  (c-ts-mode-indent-style 'linux)

  (c-ts-mode-enable-doxygen t)

  (eletric-pair-mode 1))

(defun my-c/make-clean ()
  "Run make clean in project root."
  (interactive)
  (let ((default-directory (projectile-project-root)))
    (compile "make clean")))

(defun my-c/make-all ()
  "Run make all in project root."
  (interactive)
  (let ((default-directory (projectile-project-root)))
    (compile "make all")))

(defun my-c/make-run ()
  "Run make run in project root."
  (interactive)
  (let ((default-directory (projectile-project-root)))
    (compile "make run")))

;; todo: add make-custom with arguments memory.

(ilusia-module 'python-base)
(use-package pyvenv
  :straight t)

(ilusia-layer 'format)

(use-package emacs
  :ensure nil ;; don't even try to install it
  :custom

  ;; files ======================================;;
  (auto-save-default nil)
  (create-lockfiles nil)
  (delete-by-moving-to-trash t)
  (make-backup-files nil)
	(dired-free-space nil
    dired-dwim-target t
    dired-deletion-confirmer 'y-or-n-p
    dired-filter-verbose nil
    dired-recursive-deletes 'top
    dired-recursive-copies 'always
    dired-vc-rename-file t
    dired-create-destination-dirs 'ask
    dired-clean-confirm-killing-deleted-buffers nil)
	(dired-auto-revert-buffer 'dired-directory-changed-p)

  ;; editing ====================================;;
  (delete-selection-mode 1)
  (indent-tabs-mode nil)
  (tab-always-indent 'complete)
  (tab-width 2)
	(comment-multi-line t)
	(comment-auto-fill-only-comments t)
	(comment-empty-lines t)
	(sentence-end-double-space nil)
	(require-final-newline t)

  ;; buffers ====================================;;
  (global-auto-revert-non-file-buffers t)
  (history-length 25)
  (initial-scratch-message "")
  (switch-to-buffer-obey-display-actions t)
  (truncate-lines t)
  (dired-auto-revert-buffer t)
	(x-underline-at-descent-line t) (require-final-newline t)
	(truncate-string-ellipsis "…")
	(show-paren-delay 0.1
  	show-paren-highlight-openparen t
    show-paren-when-point-inside-paren t
    fshow-paren-when-point-in-periphery t)
	(custom-buffer-done-kill t)
	(display-line-numbers-width 3)
	(numbers-widen t)
	(split-width-threshold 170
	  split-height-threshold nil)

  ;; others =====================================;;
  (inhibit-startup-message t)
  (column-number-mode t)
  (ispell-dictionary "en_US")
  (pixel-scroll-precision-mode t)
  (pixel-scroll-precision-use-momentum nil)
  (ring-bell-function 'ignore)
  (split-width-threshold 300)
  (treesit-font-lock-level 4)
  (use-dialog-box nil)
  (use-short-answers t)
  (warning-minimum-level :emergency)
  (frame-title-format "%b — Emacs")
	(enable-local-eval nil)
	(bookmark-save-flag 1)
  (gc-cons-threshold #x40000000)
  (read-process-output-max (* 1024 1024 4))

  :hook
  (prog-mode . display-line-numbers-mode)
  ('before-save-hook #'delete-trailing-whitespace)
  ('after-save-hook #'executable-make-buffer-file-executable-if-script-p)
  :config
  (defun skip-these-buffers (_window buffer _bury-or-kill)
    (string-match "\\*[^*]+\\*" (buffer-name buffer)))
  (setq switch-to-prev-buffer-skip 'skip-these-buffers)


  (setq custom-file (locate-user-emacs-file "custom-vars.el"))
  (load custom-file 'noerror 'nomessage)

  (set-display-table-slot standard-display-table 'vertical-border (make-glyph-code ?│))

  :init
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (when scroll-bar-mode
    (scroll-bar-mode -1))
  (global-hl-line-mode -1)
  (global-auto-revert-mode 1)
  (recentf-mode 1)
  (savehist-mode 1)
  (save-place-mode 1)
  (winner-mode 1)
  (file-name-shadow-mode 1)
  (show-paren-mode 1)
  (electric-pair-mode 1)
  (electric-indent-mode 1)
  (modify-coding-system-alist 'file "" 'utf-8))

;; Disable menu-bar, tool-bar and scroll-bar to increase the usable space.
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
;; Also shrink fringes to 1 pixel.
(fringe-mode 1)

;; Turn on `display-time-mode' if you don't use an external bar.
(setq display-time-default-load-average nil)
(display-time-mode t)

;; You are strongly encouraged to enable something like `icomplete-vertical-mode' to alter
;; the default behavior of 'C-x b', or you will take great pains to switch
;; to or back from a floating frame (remember 'C-x 5 o' if you refuse this
;; proposal however).
(icomplete-vertical-mode 1)

;; Emacs server is not required to run EXWM but it has some interesting uses
;; (see next section).
(server-start)

;;;; Below are configurations for EXWM.

;; Add paths (not required if EXWM is installed from GNU ELPA).
;(add-to-list 'load-path "/path/to/xelb/")
;(add-to-list 'load-path "/path/to/exwm/")

;; Load EXWM.
(require 'exwm)

;; Set the initial number of workspaces (they can also be created later).
(setq exwm-workspace-number 4)

;; All buffers created in EXWM mode are named "*EXWM*". You may want to
;; change it in `exwm-update-class-hook' and `exwm-update-title-hook', which
;; are run when a new X window class name or title is available.  Here's
;; some advice on this topic:
;; + Always use `exwm-workspace-rename-buffer` to avoid naming conflict.
;; + For applications with multiple windows (e.g. GIMP), the class names of
;    all windows are probably the same.  Using window titles for them makes
;;   more sense.
;; In the following example, we use class names for all windows except for
;; Java applications and GIMP.
(add-hook 'exwm-update-class-hook
          (lambda ()
            (unless (or (string-prefix-p "sun-awt-X11-" exwm-instance-name)
                        (string= "gimp" exwm-instance-name))
              (exwm-workspace-rename-buffer exwm-class-name))))
(add-hook 'exwm-update-title-hook
          (lambda ()
            (when (or (not exwm-instance-name)
                      (string-prefix-p "sun-awt-X11-" exwm-instance-name)
                      (string= "gimp" exwm-instance-name))
              (exwm-workspace-rename-buffer exwm-title))))

;; Global keybindings can be defined with `exwm-input-global-keys'.
;; Here are a few examples:
(setq exwm-input-global-keys
      `(
        ;; Bind "s-r" to exit char-mode and fullscreen mode.
        ([?\s-r] . exwm-reset)
        ;; Bind "s-w" to switch workspace interactively.
        ([?\s-w] . exwm-workspace-switch)
        ;; Bind "s-0" to "s-9" to switch to a workspace by its index.
        ,@(mapcar (lambda (i)
                    `(,(kbd (format "s-%d" i)) .
                      (lambda ()
                        (interactive)
                        (exwm-workspace-switch-create ,i))))
                  (number-sequence 0 9))
        ;; Bind "s-&" to launch applications ('M-&' also works if the output
        ;; buffer does not bother you).
        ([?\s-&] . (lambda (command)
             (interactive (list (read-shell-command "$ ")))
             (start-process-shell-command command nil command)))
        ;; Bind "s-<f2>" to "slock", a simple X display locker.
        ([s-f2] . (lambda ()
            (interactive)
            (start-process "" nil "/usr/bin/slock")))))

;; To add a key binding only available in line-mode, simply define it in
;; `exwm-mode-map'.  The following example shortens 'C-c q' to 'C-q'.
(define-key exwm-mode-map [?\C-q] #'exwm-input-send-next-key)

;; The following example demonstrates how to use simulation keys to mimic
;; the behavior of Emacs.  The value of `exwm-input-simulation-keys` is a
;; list of cons cells (SRC . DEST), where SRC is the key sequence you press
;; and DEST is what EXWM actually sends to application.  Note that both SRC
;; and DEST should be key sequences (vector or string).
(setq exwm-input-simulation-keys
      '(
        ;; movement
        ([?\C-b] . [left])
        ([?\M-b] . [C-left])
        ([?\C-f] . [right])
        ([?\M-f] . [C-right])
        ([?\C-p] . [up])
        ([?\C-n] . [down])
        ([?\C-a] . [home])
        ([?\C-e] . [end])
        ([?\M-v] . [prior])
        ([?\C-v] . [next])
        ([?\C-d] . [delete])
        ([?\C-k] . [S-end delete])
        ;; cut/paste.
        ([?\C-w] . [?\C-x])
        ([?\M-w] . [?\C-c])
        ([?\C-y] . [?\C-v])
        ;; search
        ([?\C-s] . [?\C-f])))

;; You can hide the minibuffer and echo area when they're not used, by
;; uncommenting the following line.
;(setq exwm-workspace-minibuffer-position 'bottom)

;; Do not forget to enable EXWM after configuring all hooks and variables. 
;; EXWM will start when the Emacs frame is ready.
(exwm-wm-mode)
