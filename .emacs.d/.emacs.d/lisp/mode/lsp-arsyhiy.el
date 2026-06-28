;;; lsp-arsyhiy.el --- Emacs client/library for the Language Server Protocol  -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package lsp-mode
  :ensure t
  :commands lsp-deferred

  :init
  (setq lsp-keymap-prefix "C-c l")

  :hook
  ((js-ts-mode
    tsx-ts-mode
    typescript-ts-mode
    python-ts-mode
    c-ts-mode
    go-ts-mode
    rust-ts-mode
    web-mode)
   . lsp-deferred)

  :custom
  (lsp-completion-provider :capf)
  (lsp-diagnostics-provider :flymake)
  (lsp-idle-delay 0.5)
  (lsp-enable-snippet nil)
  (lsp-enable-file-watchers nil)
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-enable-on-type-formatting nil)
  (lsp-enable-imenu t)
  (lsp-log-io nil)
  (lsp-keep-workspace-alive nil)
  (lsp-semantic-tokens-enable nil)
  (lsp-enable-indentation nil)
  (lsp-auto-guess-root t)
  (lsp-restart 'auto-restart)
  (lsp-eldoc-enable-hover nil)

  :config
  (lsp-enable-which-key-integration))

(use-package lsp-ui
  :after lsp-mode
  :hook (lsp-mode . lsp-ui-mode)

  :custom
  ;; Documentation popup
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-delay 0.2)
  (lsp-ui-doc-position 'at-point)
  (lsp-ui-doc-max-width 80)
  (lsp-ui-doc-max-height 20)
  (lsp-ui-doc-show-with-cursor t)
  (lsp-ui-doc-show-with-mouse nil)
  (lsp-ui-doc-use-childframe t)

  ;; Disable inline hints
  (lsp-ui-sideline-enable nil)

  ;; Peek window
  (lsp-ui-peek-enable t))


(use-package lsp-pyright
  :after lsp-mode
  :custom
  (lsp-pyright-langserver-command "basedpyright"))

(provide 'lsp-arsyhiy)
;;; lsp-arsyhiy.el ends here
