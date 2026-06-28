;;; options.el --- options settings -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package emacs
  :ensure nil ;; don't try to install it
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

  ;; fonts
  (set-face-attribute 'default nil :family "JetBrainsMono Nerd Font" :height 150)

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

(provide 'options)
;;; options.el ends heree
