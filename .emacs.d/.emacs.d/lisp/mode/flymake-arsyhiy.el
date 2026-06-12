;;; flymake-arsyhiy.el --- Finding Syntax Errors On The Fly -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package flymake
  :ensure nil
  :defer t
  :hook (prog-mode . flymake-mode)
  :custom
  (flymake-margin-indicators-string
    '((error "!»" compilation-error) (warning "»" compilation-warning)
       (note "»" compilation-info))))

(provide 'flymake-arsyhiy)
;;; flymake-arsyhiy.el ends here
