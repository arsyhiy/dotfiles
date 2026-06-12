;;; marginalia-arsyhiy.el --- Marginalia in the minibuffer  -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package marginalia
  :ensure t
  :hook
  (after-init . marginalia-mode))

(provide 'marginalia-arsyhiy)
;;; marginalia-arsyhiy.el ends here
