;;; rainbow-delimiters-arsyhiy.el ---  Emacs rainbow delimiters mode  -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package rainbow-delimiters
  :defer t
  :ensure t
  :hook
  (prog-mode . rainbow-delimiters-mode))

(provide 'rainbow-delimiters-arsyhiy)
;;; rainbow-delimiters-arsyhiy.el ends here
