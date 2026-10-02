;;; tools-black.el --- black formatter in emacs -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.2"))

;;; Commentary:

;;; Code:

(defun my-black-format ()
  "Format python file with black."
  (interactive)
  (shell-command-on-region
    (point-min)
    (point-max)
    "black -"
    t
    t))

(provide 'tools-black)
;;; tools-black.el ends here
