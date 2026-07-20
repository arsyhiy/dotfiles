;;; python-arsyhiy.el --- mode for programming language python -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package python
  :ensure nil
  :mode ("\\.py\\'" . python-ts-mode)
  :hook ((python-ts-mode . python-runner-setup)
          (python-ts-mode . lsp-deferred))
  :config
  (defun python-runner-setup ()
    (setq-local runner-runtime "python3"
      runner-target-function #'runner-current-file)
    (runner-mode 1)))

(provide 'python-arsyhiy)
;;; python-arsyhiy.el ends here
