;;; cape-arsyhiy.el --- Completion At Point Extensions  -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package cape
  :ensure t
  :init
  (add-to-list 'completion-at-point-functions #'cape-yasnippet))

(provide 'cape-arsyhiy)
;;; cape-arsyhiy.el ends here
