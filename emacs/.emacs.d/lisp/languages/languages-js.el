;;; languages-js.el --- mode for javascript -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.2"))

;;; Commentary:

;;; Code:

;;; TODO: REWRITE THIS SHIT
(defun my-js-mode-setup ()
  "Setq-local vars for 'js-mode'."
  (setq-local js-indent-level 2
    tab-width 2
    treesit-font-lock-level 4))

(use-package js
  :mode "\\.js\\'"
  :hook
  ((js-ts-mode . my-js-mode-setup)
    (js-ts-mode . electric-pair-local-mode))
  )

(provide 'languages-js)

;;; languages-js.el ends here
