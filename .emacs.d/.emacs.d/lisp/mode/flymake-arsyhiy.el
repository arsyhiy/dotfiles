;;; flymake-arsyhiy.el --- Finding Syntax Errors On The Fly -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package flymake
  :ensure nil
  :hook
  (prog-mode . flymake-mode)
  :custom
  (flymake-no-changes-timeout 0.5)
  (flymake-show-diagnostics-at-end-of-line t)
  (flymake-margin-indicators-string
   '((error   "✘" flymake-error)
     (warning "▲" flymake-warning)
     (note    "●" flymake-note))))

(provide 'flymake-arsyhiy)
;;; flymake-arsyhiy.el ends here
