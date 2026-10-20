

    ;; (require 'subr-x)
    ;; 
    ;; (defvar my/orgfiles-directory
    ;;   (expand-file-name "~/NOTES/"))
    ;; 
    ;; (defvar my/orgfiles-sync-running nil)
    ;; 
    ;; (defun my/orgfiles-sync-finished (process _event)
    ;;   (when (memq (process-status process) '(exit signal))
    ;;     (setq my/orgfiles-sync-running nil)
    ;;     (unless (= (process-exit-status process) 0)
    ;;       (message "Org sync failed. Check *orgfiles-sync*"))))
    ;; 
    ;; (defun my/orgfiles-sync ()
    ;;   "Synchronize NOTES directory with GitHub."
    ;;   (interactive)
    ;;   (when (and (file-directory-p my/orgfiles-directory)
    ;;              (not my/orgfiles-sync-running))
    ;;     (setq my/orgfiles-sync-running t)
    ;;     (let ((default-directory my/orgfiles-directory)
    ;;           (buffer (get-buffer-create "*orgfiles-sync*")))
    ;;       (with-current-buffer buffer
    ;;         (erase-buffer))
    ;;       (make-process
    ;;        :name "orgfiles-sync"
    ;;        :buffer buffer
    ;;        :command
    ;;        '("bash" "-lc"
    ;;          "set -e
    ;;           git add -A
    ;;           if ! git diff --cached --quiet; then
    ;;             git commit -m 'Auto-sync orgfiles'
    ;;           fi
    ;;           git pull --rebase origin main
    ;;           git push origin main")
    ;;        :sentinel #'my/orgfiles-sync-finished))))
    ;; 
    ;; (defun my/orgfiles-after-save ()
    ;;   (when (and buffer-file-name
    ;;              (string-prefix-p
    ;;               (file-name-as-directory
    ;;                (expand-file-name my/orgfiles-directory))
    ;;               (expand-file-name buffer-file-name)))
    ;;     (my/orgfiles-sync)))
    ;; 
    ;; (add-hook 'after-save-hook #'my/orgfiles-after-save)
    ;; 
    ;; (run-with-timer 300 300 #'my/orgfiles-sync)


  ;; (require 'subr-x)
  ;; 
  ;; (defvar my/orgfiles-directory
  ;;   (expand-file-name "~/NOTES/"))
  ;; 
  ;; (defvar my/orgfiles-sync-running nil)
  ;; (defvar my/orgfiles-autocommit-timer nil)
  ;; 
  ;; (defun my/orgfiles-sync-finished (process _event)
  ;;   (when (memq (process-status process) '(exit signal))
  ;;     (setq my/orgfiles-sync-running nil)
  ;;     (unless (= (process-exit-status process) 0)
  ;;       (message "Org sync failed. Check *orgfiles-sync*"))))
  ;; 
  ;; (defun my/orgfiles-sync ()
  ;;   "Commit changes and synchronize NOTES with GitHub."
  ;;   (interactive)
  ;;   (when (and (file-directory-p my/orgfiles-directory)
  ;;              (not my/orgfiles-sync-running))
  ;;     (setq my/orgfiles-sync-running t)
  ;;     (let ((default-directory my/orgfiles-directory)
  ;;           (buffer (get-buffer-create "*orgfiles-sync*")))
  ;;       (with-current-buffer buffer
  ;;         (erase-buffer))
  ;;       (make-process
  ;;        :name "orgfiles-sync"
  ;;        :buffer buffer
  ;;        :command
  ;;        '("bash" "-lc"
  ;;          "set -e
  ;;           git add -A
  ;;           if ! git diff --cached --quiet; then
  ;;             git commit -m 'Auto-sync orgfiles'
  ;;           fi
  ;;           git pull --rebase origin main
  ;;           git push origin main")
  ;;        :sentinel #'my/orgfiles-sync-finished))))
  ;; 
  ;; (defun my/orgfiles-schedule-autocommit ()
  ;;   "Schedule synchronization 5 minutes after the latest save."
  ;;   (when my/orgfiles-autocommit-timer
  ;;     (cancel-timer my/orgfiles-autocommit-timer))
  ;;   (setq my/orgfiles-autocommit-timer
  ;;         (run-with-timer 300 nil #'my/orgfiles-sync)))
  ;; 
  ;; (defun my/orgfiles-after-save ()
  ;;   (when (and buffer-file-name
  ;;              (string-prefix-p
  ;;               (file-name-as-directory
  ;;                (expand-file-name my/orgfiles-directory))
  ;;               (expand-file-name buffer-file-name)))
  ;;     (my/orgfiles-schedule-autocommit)))
  ;; 
  ;; (add-hook 'after-save-hook #'my/orgfiles-after-save)
