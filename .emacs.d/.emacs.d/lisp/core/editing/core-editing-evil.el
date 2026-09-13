;;; core-editing-evil.el --- The extensible vi layer for Emacs. -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package evil
  :hook
  (after-init . evil-mode)
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-u-delete t)
  :config
  (evil-set-initial-state 'eshell-mode 'emacs)
  (evil-set-initial-state 'shell-mode 'emacs)
  (evil-set-undo-system 'undo-tree)

  (setq evil-leader/in-all-states t)
  (setq evil-want-fine-undo t)

  (evil-set-leader 'normal (kbd "SPC"))
  (evil-set-leader 'visual (kbd "SPC"))

  (evil-define-key 'normal 'global (kbd "<leader> c f") 'consult-find)
  (evil-define-key 'normal 'global (kbd "<leader> c g") 'consult-grep)
  (evil-define-key 'normal 'global (kbd "<leader> c G") 'consult-git-grep)
  (evil-define-key 'normal 'global (kbd "<leader> c r") 'consult-ripgrep)
  (evil-define-key 'normal 'global (kbd "<leader> c i") 'consult-info)
  (evil-define-key 'normal 'global (kbd "<leader> c l") 'consult-line)
  (evil-define-key 'normal 'global (kbd "<leader> c s") #'consult-imenu)

  (evil-define-key 'normal 'global (kbd "<leader> f f") 'consult-flymake)
  (evil-define-key 'normal 'global (kbd "<leader> f n") 'flymake-goto-next-error)
  (evil-define-key 'normal 'global (kbd "<leader> f p") 'flymake-goto-prev-error)

  (evil-define-key 'normal 'global (kbd "<leader> d d") 'dired)
  (evil-define-key 'normal 'global (kbd "<leader> d j") 'dired-jump)
  (evil-define-key 'normal 'global (kbd "<leader> x f") 'find-file)

  (evil-define-key 'normal 'global (kbd "<leader> m s") 'magit-status)
  (evil-define-key 'normal 'global (kbd "<leader> m l") 'magit-log-current)
  (evil-define-key 'normal 'global (kbd "<leader> m d") 'magit-diff-buffer-file)
  (evil-define-key 'normal 'global (kbd "<leader> d D") 'diff-hl-show-hunk)
  (evil-define-key 'normal 'global (kbd "<leader> v a") 'vc-annotate)

  (evil-define-key 'normal 'global (kbd "<leader> s n") 'switch-to-next-buffer)
  (evil-define-key 'normal 'global (kbd "<leader> s p") 'switch-to-prev-buffer)
  (evil-define-key 'normal 'global (kbd "<leader> b k") 'kill-current-buffer)
  (evil-define-key 'normal 'global (kbd "<leader>SPC") 'consult-buffer)

  (evil-define-key 'normal 'global (kbd "<leader> D m") 'describe-mode)
  (evil-define-key 'normal 'global (kbd "<leader> D f") 'describe-function)
  (evil-define-key 'normal 'global (kbd "<leader> D v") 'describe-variable)
  (evil-define-key 'normal 'global (kbd "<leader> D k") 'describe-key)

  (evil-define-key 'normal 'global (kbd "C-p") #'my-format-buffer)

  (evil-define-key 'normal lsp-mode-map
    (kbd "gr") 'lsp-find-references
    (kbd "<leader> c a") 'lsp-execute-code-action
    (kbd "<leader> r n") 'lsp-rename
    (kbd "gI") 'lsp-find-implementation
    (kbd "<leader> l f") 'lsp-format-buffer)
	
  (defun ek/lsp-describe-and-jump ()
    "Show hover documentation and jump to *lsp-help* buffer."
    (interactive)
    (lsp-describe-thing-at-point)
    (let ((help-buffer "*lsp-help*"))
      (when (get-buffer help-buffer)
        (switch-to-buffer-other-window help-buffer))))

  (evil-define-key 'normal 'global (kbd "K")
    (if (>= emacs-major-version 31)
      #'eldoc-box-help-at-point
      #'ek/lsp-describe-and-jump))


  (evil-define-key 'normal 'global (kbd "gcc")
    (lambda ()
      (interactive)
      (if (not (use-region-p))
        (comment-or-uncomment-region (line-beginning-position) (line-end-position)))))

  (evil-define-key 'visual 'global (kbd "gc")
    (lambda ()
      (interactive)
      (if (use-region-p)
        (comment-or-uncomment-region (region-beginning) (region-end)))))

  (evil-mode 1))

(use-package evil-collection
  :custom
  (evil-collection-want-find-usages-bindings t)
  :hook
  (evil-mode . evil-collection-init))

(use-package evil-surround
  :after evil-collection
  :config
  (global-evil-surround-mode 1))

(use-package evil-matchit
  :after evil-collection
  :config
  (global-evil-matchit-mode 1))

(provide 'core-editing-evil)
;;; core-editing-evil.el ends here
