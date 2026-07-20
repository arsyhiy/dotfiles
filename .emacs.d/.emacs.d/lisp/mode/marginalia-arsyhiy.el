;;; marginalia-arsyhiy.el --- Marginalia in the minibuffer  -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package marginalia
  :ensure t
  :hook (after-init . marginalia-mode)

  :custom
  (marginalia-align 'right)
  (marginalia-align-offset 8)
  (marginalia-max-relative-age 0))

(provide 'marginalia-arsyhiy)
;;; marginalia-arsyhiy.el ends here
