;;; lsp-arsyhiy.el --- Emacs client/library for the Language Server Protocol  -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package lsp-mode
  :ensure t
  :defer t
  :hook (
          (lsp-mode . lsp-enable-which-key-integration)
          ((js-mode
             tsx-ts-mode
             typescript-ts-base-mode
             html-mode
             css-ts-mode
             go-ts-mode
             c-ts-mode
             js-ts-mode
             prisma-mode
             python-ts-mode
             ruby-base-mode
             rust-ts-mode
             web-mode) . lsp-deferred))
  :commands lsp
  :custom
  (lsp-keymap-prefix "C-c l")
  (lsp-inlay-hint-enable nil)
  (lsp-completion-provider :capf)
  (lsp-session-file (locate-user-emacs-file ".lsp-session"))
  (lsp-log-io nil)
  (lsp-idle-delay 0.5)
  (lsp-keep-workspace-alive nil)

  (lsp-enable-xref t)
  (lsp-auto-configure t)
  (lsp-enable-links nil)
  (lsp-eldoc-enable-hover t)
  (lsp-enable-file-watchers nil)
  (lsp-enable-folding nil)
  (lsp-enable-imenu t)
  (lsp-enable-indentation nil)
  (lsp-enable-on-type-formatting nil)
  (lsp-enable-suggest-server-download t)
  (lsp-enable-symbol-highlighting t)
  (lsp-enable-text-document-color t)
  
  (lsp-modeline-code-actions-enable nil)
  (lsp-modeline-diagnostics-enable nil)
  (lsp-modeline-workspace-status-enable t)
  (lsp-signature-doc-lines 1)
  (lsp-eldoc-render-all t)
  
  (lsp-completion-enable t)
  (lsp-completion-enable-additional-text-edit nil)
  (lsp-enable-snippet t)
  (lsp-completion-show-kind t)
  
  (lsp-lens-enable t)
  ;; (lsp-headerline-breadcrumb-enable-symbol-numbers t)
  (lsp-headerline-arrow "▶")
  ;; (lsp-headerline-breadcrumb-enable-diagnostics nil)
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-headerline-breadcrumb-icons-enable nil)
  (lsp-semantic-tokens-enable nil))

(use-package lsp-ui
  :after lsp-mode
  :hook (lsp-mode . lsp-ui-mode)

  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-delay 0.2)
  (lsp-ui-doc-position 'at-point)

  (lsp-ui-sideline-enable t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-sideline-show-code-actions t)

  (lsp-ui-peek-enable t)

  (lsp-ui-imenu-enable t)

  (lsp-ui-doc-border (face-foreground 'default))

  :bind
  (:map lsp-ui-mode-map
    ("C-c i" . lsp-ui-imenu)
    ("C-c p" . lsp-ui-peek-find-definitions)
    ("C-c r" . lsp-ui-peek-find-references)))

(use-package flycheck
  :hook (prog-mode . flycheck-mode)
  :config
  (setq flycheck-check-syntax-automatically '(save mode-enabled)
    flycheck-display-errors-delay 0.3
    flycheck-indication-mode 'right-fringe)

  (defun my/flycheck-toggle-panel ()
    "Toggle Flycheck error list panel."
    (interactive)
    (let ((buf "*Flycheck errors*"))
      (if (get-buffer-window buf)
        (delete-window (get-buffer-window buf))
        (flycheck-list-errors))))

  :bind (("C-c e" . my/flycheck-toggle-panel)
          :map flycheck-mode-map
          ("C-c n" . flycheck-next-error)
          ("C-c p" . flycheck-previous-error)))

(use-package flycheck-inline
  :hook (flycheck-mode . flycheck-inline-mode))

(setq lsp-diagnostics-provider :flycheck)

(use-package lsp-pyright
  :ensure t
  :after lsp-mode
  :hook (python-ts-mode . (lambda ()
                            (require 'lsp-pyright))))
(setq lsp-pyright-langserver-command "basedpyright")

(provide 'lsp-arsyhiy)
;;; lsp-arsyhiy.el ends here
