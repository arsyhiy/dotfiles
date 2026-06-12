;;; css-arsyhiy.el --- mode for csss -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(add-to-list 'major-mode-remap-alist
  '(css-mode . css-ts-mode))
(defun my-css-setup ()
  (setq-local css-indent-offset 2
    tab-width 2)
  (electric-pair-local-mode 1))

(add-hook 'css-ts-mode-hook #'my-css-setup)

(provide 'css-arsyhiy)
;;; css-arsyhiy.el ends here
