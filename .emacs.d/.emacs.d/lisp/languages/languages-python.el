;;  ;;; languages-python.el
;; 
;; (require 'python)
;; (require 'tools-black)
;; 
;; (defun my-python-run ()
;;   "Run python file."
;;   (interactive)
;;   (save-buffer)
;;   (compile
;;    (format "python %s"
;;            (shell-quote-argument
;;             (buffer-file-name)))))
;; 
;; 
;; (defun my-python-setup ()
;;   "Configure Python buffers."
;; 
;;   (setq-local
;;    my-formatter-function
;;    #'my-black-format)
;; 
;;   (setq-local
;;    my-run-function
;;    #'my-python-run))
;; 
;; 
;; (add-hook
;;  'python-ts-mode-hook
;;  #'my-python-setup)


;;; languages-python.el --- mode for programming language python -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package python
  :ensure nil
  :mode ("\\.py\\'" . python-ts-mode)
  :hook ((python-ts-mode . lsp-deferred)))

(provide 'languages-python)
;;; languages-python.el ends here
