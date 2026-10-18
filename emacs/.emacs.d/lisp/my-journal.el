;;; my-journal.el --- minor mode for org to open daily notes from md and back -*- lexical-binding: t; -*-
;; Author: arsyhiy

;;; Commentary:
;;; that minor mode was to import md files from obsidian and export back on save.

;;; Code:

(require 'org)
(require 'ox-md)


(defun open-with-my-journal-mode (file)
  "Open org FILE with `my-journal-mode` in its buffer."
  (interactive "fOpen journal file: ")
  (find-file file)
  (when (derived-mode-p 'org-mode)
    (my-journal-mode 1)))

(defun my-journal-newer-file (org-file md-file)
  "Return the path of the most recently modified file ORG-FILE or MD-FILE."
  (if (time-less-p
       (file-attribute-modification-time (file-attributes org-file))
       (file-attribute-modification-time (file-attributes md-file)))
      md-file
    org-file))

(defun my-journal-check-files (org-file md-file)
  "Return t if both ORG-FILE, MD-FILE  exist, the existing file path if only one exists, or nil."
  (let ((org-exists (file-regular-p org-file))
        (md-exists (file-regular-p md-file)))
    (cond
     ((and org-exists md-exists) t)
     (org-exists org-file)
     (md-exists md-file)
     (t nil))))

(defun my-journal-import-md (md-file org-file)
  "Import MD-FILE into ORG-FILE and open it with journal mode."
  (if (not (file-regular-p md-file))
      (message "Markdown file not found: %s" md-file)
    (make-directory (file-name-directory org-file) t)
    (if (zerop (call-process "pandoc" nil nil nil
                             "-f" "markdown"
                             "-t" "org"
                             "-o" org-file
                             md-file))
        (progn
          (message "Converted to %s" org-file)
          (open-with-my-journal-mode org-file))
      (message "Pandoc conversion failed"))))

(defun my-journal-open-today ()
  "Open today's journal file."
  (interactive)
  (defvar my-journal-org-dir "~/orgjournal/")
  (defvar my-journal-md-dir "~/NOTES/daily/")
  (let* ((date (format-time-string "%Y-%m-%d"))
         (md-file (expand-file-name
                   (concat date ".md")
                   my-journal-md-dir))
         (org-file (expand-file-name
                    (concat date ".org")
                    my-journal-org-dir))
         (result (my-journal-check-files org-file md-file)))
    (cond
     ((eq result t)
      (let ((newest (my-journal-newer-file org-file md-file)))
        (if (equal newest org-file)
            (open-with-my-journal-mode org-file)
          (my-journal-import-md md-file org-file))))

     ((equal result org-file)
      (open-with-my-journal-mode org-file))

     ((equal result md-file)
      (my-journal-import-md md-file org-file))

     (t
      (open-with-my-journal-mode org-file)))))

(defun my-journal-export-on-save ()
  "Export journal entry to Markdown after saving."
  (when (and my-journal-mode buffer-file-name)
    (let ((org-export-with-toc nil)
          (org-export-with-author nil)
          (org-export-with-date nil))
      (org-export-to-file
          'md
          (expand-file-name
           (concat (file-name-base buffer-file-name) ".md")
           my-journal-md-dir))))
  
  nil)

(define-minor-mode my-journal-mode
  "Minor mode for journal entries."
  :lighter " Journal"
  (if my-journal-mode
      (add-hook 'after-save-hook
                #'my-journal-export-on-save nil t)
    (remove-hook 'after-save-hook
                 #'my-journal-export-on-save t)))

(provide 'my-journal)

;;; my-journal.el ends here
