;;; evil-arsyhiy.el --- The extensible vi layer for Emacs. -*- lexical-binding: t; -*-
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

  (evil-define-key 'normal 'global (kbd "<leader> s f") 'consult-find)
  (evil-define-key 'normal 'global (kbd "<leader> s g") 'consult-grep)
  (evil-define-key 'normal 'global (kbd "<leader> s G") 'consult-git-grep)
  (evil-define-key 'normal 'global (kbd "<leader> s r") 'consult-ripgrep)
  (evil-define-key 'normal 'global (kbd "<leader> s h") 'consult-info)
  (evil-define-key 'normal 'global (kbd "<leader> /") 'consult-line)

  (evil-define-key 'normal 'global (kbd "<leader> x x") 'consult-flymake)
  (evil-define-key 'normal 'global (kbd "] d") 'flymake-goto-next-error)
  (evil-define-key 'normal 'global (kbd "[ d") 'flymake-goto-prev-error)

  (evil-define-key 'normal 'global (kbd "<leader> d d") 'dired)
  (evil-define-key 'normal 'global (kbd "<leader> d j") 'dired-jump)
  (evil-define-key 'normal 'global (kbd "<leader> x f") 'find-file)

  (evil-define-key 'normal 'global (kbd "] c") 'diff-hl-next-hunk)
  (evil-define-key 'normal 'global (kbd "[ c") 'diff-hl-previous-hunk)

  (evil-define-key 'normal 'global (kbd "<leader> g g") 'magit-status)
  (evil-define-key 'normal 'global (kbd "<leader> g l") 'magit-log-current)
  (evil-define-key 'normal 'global (kbd "<leader> g d") 'magit-diff-buffer-file)
  (evil-define-key 'normal 'global (kbd "<leader> g D") 'diff-hl-show-hunk)
  (evil-define-key 'normal 'global (kbd "<leader> g b") 'vc-annotate)

  (evil-define-key 'normal 'global (kbd "] b") 'switch-to-next-buffer)
  (evil-define-key 'normal 'global (kbd "[ b") 'switch-to-prev-buffer)
  (evil-define-key 'normal 'global (kbd "<leader> b i") 'consult-buffer)
  (evil-define-key 'normal 'global (kbd "<leader> b b") 'ibuffer)
  (evil-define-key 'normal 'global (kbd "<leader> b d") 'kill-current-buffer)
  (evil-define-key 'normal 'global (kbd "<leader> b k") 'kill-current-buffer)
  (evil-define-key 'normal 'global (kbd "<leader> b x") 'kill-current-buffer)
  (evil-define-key 'normal 'global (kbd "<leader> b s") 'save-buffer)
  (evil-define-key 'normal 'global (kbd "<leader>SPC") 'consult-buffer)

  (evil-define-key 'normal 'global (kbd "<leader> p b") 'consult-project-buffer)
  (evil-define-key 'normal 'global (kbd "<leader> p p") 'project-switch-project)
  (evil-define-key 'normal 'global (kbd "<leader> p f") 'project-find-file)
  (evil-define-key 'normal 'global (kbd "<leader> p g") 'project-find-regexp)
  (evil-define-key 'normal 'global (kbd "<leader> p k") 'project-kill-buffers)
  (evil-define-key 'normal 'global (kbd "<leader> p D") 'project-dired)

  (evil-define-key 'normal 'global (kbd "P") 'consult-yank-from-kill-ring)
  (evil-define-key 'normal 'global (kbd "<leader> P") 'consult-yank-from-kill-ring)

  (evil-define-key 'normal 'global (kbd "<leader> .") 'embark-act)

  (evil-define-key 'normal 'global (kbd "<leader> u") 'undo-tree-visualize)

  (evil-define-key 'normal 'global (kbd "<leader> h m") 'describe-mode)
  (evil-define-key 'normal 'global (kbd "<leader> h f") 'describe-function)
  (evil-define-key 'normal 'global (kbd "<leader> h v") 'describe-variable)
  (evil-define-key 'normal 'global (kbd "<leader> h k") 'describe-key)

  (evil-define-key 'normal 'global (kbd "] t") 'tab-next)
  (evil-define-key 'normal 'global (kbd "[ t") 'tab-previous)

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

(provide 'evil-arsyhiy)
;;; evil-arsyhiy.el ends here
