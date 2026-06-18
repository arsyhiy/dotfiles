;;; yasnippet-arsyhiy.el --- Yasnippet configuration -*- lexical-binding: t; -*-

;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;; Snippet support for completion frameworks and LSP.

;;; Code:

(use-package yasnippet
  :ensure t
  :hook (prog-mode . yas-minor-mode)
  :config
  (yas-reload-all))

(use-package yasnippet-snippets
  :ensure t
  :after yasnippet)

(provide 'yasnippet-arsyhiy)

;;; yasnippet-arsyhiy.el ends here
