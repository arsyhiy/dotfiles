;;; org-utils.el --- convinient functions for org mode -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; code:

(defun add-todo ()
  "Add todo with deadline."
  (interactive)
  (let ((todo (read-string "TODO: "))
        (deadline (read-string "deadline: "))
        (file "~/NOTES/orgfiles/todo.org")))
    (with-current-buffer (find-file-noselect file)
      (goto-char (point-max))
      (insert "\n* TODO " todo)

      (unless (string-empty-p deadline)
        (insert "\n DEADLINE: <" deadline ">"))

      (save-buffer)))

(provide 'org-utils.el)
;;; org-utils.el ends here
