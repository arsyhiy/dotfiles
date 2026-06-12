;;; options.el --- options settings -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package emacs
  :ensure nil
  :custom
  (auto-save-default nil)
  (column-number-mode t)
  (create-lockfiles nil)
  (delete-by-moving-to-trash t)
  (delete-selection-mode 1)
  (global-auto-revert-non-file-buffers t)
  (history-length 25)
  (indent-tabs-mode nil)
  (inhibit-startup-message t)
  (initial-scratch-message "")
  (ispell-dictionary "en_US")
  (make-backup-files nil)
  (pixel-scroll-precision-mode t)
  (pixel-scroll-precision-use-momentum nil)
  (ring-bell-function 'ignore)
  (split-width-threshold 300)
  (switch-to-buffer-obey-display-actions t)
  (tab-always-indent 'complete)
  (tab-width 4)
  (treesit-font-lock-level 4)
  (truncate-lines t)
  (use-dialog-box nil)
  (use-short-answers t)
  (warning-minimum-level :emergency)

  :hook
  (prog-mode . display-line-numbers-mode)

  :config
  (defun skip-these-buffers (_window buffer _bury-or-kill)
    (string-match "\\*[^*]+\\*" (buffer-name buffer)))
  (setq switch-to-prev-buffer-skip 'skip-these-buffers)

  (set-face-attribute 'default nil :family "JetBrainsMono Nerd Font" :height 150)

  (when (eq system-type 'darwin)
    (setq mac-command-modifier 'meta)
    (set-face-attribute 'default nil :family "JetBrainsMono Nerd Font" :height 150))

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
  (xterm-mouse-mode 1)
  (file-name-shadow-mode 1)

  (modify-coding-system-alist 'file "" 'utf-8)

  (add-hook 'after-init-hook
    (lambda ()
      (message "Emacs has fully loaded. This code runs after startup.")
      (with-current-buffer (get-buffer-create "*scratch*")
        (insert (format ";;    Welcome to Emacs!
;;
;;    Loading time : %s
;;    Packages     : %s
"
                  (emacs-init-time)
                  (length (hash-table-keys straight--recipe-cache))))))))

(setq gc-cons-threshold #x40000000)
(setq read-process-output-max (* 1024 1024 4))

(provide 'options)
;;; options.el ends heree
