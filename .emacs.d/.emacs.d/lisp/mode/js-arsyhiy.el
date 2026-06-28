;;; js-arsyhiy.el --- JavaScript configuration -*- lexical-binding: t; -*-

;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;; Personal JavaScript configuration.

;;; Code:

(defun js-arsyhiy-setup ()
  "Configure `js-ts-mode'."
  (setq-local js-indent-level 2
    tab-width 2))

(use-package js
  :mode "\\.js\\'"
  :hook
  ((js-ts-mode . js-arsyhiy-setup)
    (js-ts-mode . electric-pair-local-mode)))

(provide 'js-arsyhiy)

;;; js-arsyhiy.el ends here
