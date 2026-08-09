;;; core-interface.el --- all custom function interface -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

(defvar-local my-formatter-function nil
  "Current buffer formatter.")

(defun my-format-buffer ()
  "Format current buffer."
  (interactive)
  (if my-formatter-function
    (funcall my-formatter-function)
    (message "No formatter configured.")))


(defvar-local my-run-function nil
  "Current buffer runner.")


(defun my-run-buffer ()
  "Run current buffer."
  (interactive)
  (if my-run-function
    (funcall my-run-function)
    (message "No runner configured.")))

(provide 'core-interface)
;;; core-interface.el ends here
