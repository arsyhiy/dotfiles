;;; languages-org.el --- Your life in plain text -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.2"))

;;; Commentary:
;; Personal Org-mode configuration.

;;; Code:

(defconst my/org-directory
  (expand-file-name "~/org/"))

(defconst my/org-daily-directory
  (expand-file-name "daily/" my/org-directory))

(defconst my/org-notes-directory
  (expand-file-name "notes/" my/org-directory))

(defconst my/org-todo-file
  (expand-file-name "todo.org" my/org-directory))

(defconst my/org-git-directory
  my/org-directory)

(dolist (directory
         (list my/org-directory
               my/org-daily-directory
               my/org-notes-directory))
  (unless (file-directory-p directory)
    (make-directory directory t)))

(defun my/org-mode-setup ()
  "Configure Org mode."
  (setq-local fill-column 80)
  (auto-fill-mode 1))

(use-package org
  :ensure nil
  :hook
  (org-mode . my/org-mode-setup))

(setq org-capture-templates
      `(("t" "TODO" entry
         (file ,my/org-todo-file)
         "* TODO %?\n  %U\n")

        ("d" "Daily" entry
         (file+head
          ,(expand-file-name
            "daily/%<%Y-%m-%d>.org"
            my/org-directory)
          "#+title: %<%Y-%m-%d>\n\n")
         "* %?\n")

        ("n" "Note" entry
         (file ,(expand-file-name
                 "inbox.org"
                 my/org-directory))
         "* %?\n  %U\n")))

(defun my/org-open-today ()
  "Open today's daily note."
  (interactive)
  (find-file
   (expand-file-name
    (format-time-string "%Y-%m-%d.org")
    my/org-daily-directory)))

(defun my/org-open-todo ()
  "Open the personal TODO file."
  (interactive)
  (find-file my/org-todo-file))

(defvar my/org-git-timer nil)

(defun my/org-file-p ()
  "Return non-nil if the current buffer is an Org file in `my/org-directory'."
  (and buffer-file-name
       (derived-mode-p 'org-mode)
       (file-in-directory-p
        (file-truename buffer-file-name)
        (file-truename my/org-directory))))

(defun my/org-git-sync ()
  "Commit and push changes in the Org repository."
  (when (file-directory-p
         (expand-file-name ".git" my/org-git-directory))

    (let ((status
           (with-temp-buffer
             (call-process
              "git"
              nil
              t
              nil
              "-C" my/org-git-directory
              "status"
              "--porcelain")
             (buffer-string))))

      (when (not (string-empty-p status))

        (when (= 0
                 (call-process
                  "git"
                  nil
                  nil
                  nil
                  "-C" my/org-git-directory
                  "add"
                  "."))

          (when (= 0
                   (call-process
                    "git"
                    nil
                    nil
                    nil
                    "-C" my/org-git-directory
                    "commit"
                    "-m"
                    "auto: update org"))

            (call-process
             "git"
             nil
             nil
             nil
             "-C" my/org-git-directory
             "push")))))))


(defun my/org-schedule-git-sync ()
  "Schedule an Org Git sync after 30 seconds of inactivity."
  (when my/org-git-timer
    (cancel-timer my/org-git-timer))

  (setq my/org-git-timer
        (run-with-idle-timer
         30
         nil
         #'my/org-git-sync)))


(defun my/org-after-save ()
  "Schedule Git sync after saving an Org file."
  (when (my/org-file-p)
    (my/org-schedule-git-sync)))


(add-hook 'after-save-hook #'my/org-after-save)


(provide 'languages-org)
;;; languages-org.el ends here
