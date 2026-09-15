;;; core-ui-theme.el --- theme for emacs -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.2"))

;;; Commentary:

;;; Code:

(use-package ef-themes
  :ensure t

  :init
  (load-theme 'ef-dark t))

(provide 'core-ui-theme)
;;; core-ui-theme.el ends here
