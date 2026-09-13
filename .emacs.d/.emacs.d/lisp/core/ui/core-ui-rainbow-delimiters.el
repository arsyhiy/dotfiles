;;; core-ui-rainbow-delimiters.el --- Emacs rainbow delimiters mode -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package rainbow-delimiters
  :ensure t

  :hook
  (prog-mode . rainbow-delimiters-mode)

  :custom
  (rainbow-delimiters-max-face-count 9))

(provide 'core-ui-rainbow-delimiters)
;;; core-ui-rainbow-delimiters.el ends here
