;;; last-patch.el --- Open the newest patch file -*- lexical-binding: t; -*-

;; Author: arsyhiy

;;; Commentary:
;; Open the most recently modified .patch file from the dotfiles changes
;; directory in `diff-mode`.

;;; Code:

(defgroup arsyhiy-last-patch nil
  "Open the latest patch file."
  :group 'tools)

(defcustom arsyhiy-last-patch-directory
  (expand-file-name "~/dotfiles/changes/")
  "Directory containing patch files created by the assistant."
  :type 'directory
  :group 'arsyhiy-last-patch)

(defun arsyhiy-last-patch--newest-file (files)
  "Return the most recently modified file from FILES."
  (car (sort files
             (lambda (first second)
               (file-newer-than-file-p first second)))))

(defun arsyhiy/open-latest-patch ()
  "Open the most recently modified .patch file in `diff-mode`."
  (interactive)
  (let* ((directory (file-name-as-directory
                     (expand-file-name arsyhiy-last-patch-directory)))
         (files (when (file-directory-p directory)
                  (directory-files directory t "\\.patch\\'" t)))
         (patch (when files
                  (arsyhiy-last-patch--newest-file files))))
    (if patch
        (find-file patch)
      (user-error "No .patch files found in %s" directory))))

(global-set-key (kbd "C-c p p") #'arsyhiy/open-latest-patch)

(provide 'last-patch)

;;; last-patch.el ends here

