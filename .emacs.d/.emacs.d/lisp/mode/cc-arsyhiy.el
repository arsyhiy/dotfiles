;;; cc-arsyhiy.el --- mode for c  -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:
(use-package cc-mode
  :ensure nil
  :mode (("\\.c\\'"   . c-ts-mode)
          ("\\.h\\'"   . c-ts-mode)
          ("\\.cpp\\'" . c++-ts-mode)
          ("\\.hpp\\'" . c++-ts-mode))
  :hook ((c-ts-mode . my/c-ts-setup)
          (c++-ts-mode . my/c-ts-setup))
  :config
  (defun my/c-ts-setup ()
    (setq-local indent-tabs-mode nil)
    (setq-local c-ts-mode-indent-offset 2)))

(use-package elec-pair
  :ensure nil
  :config
  (electric-pair-mode 1))

(provide 'cc-arsyhiy)
;;; cc-arsyhiy.el ends here
