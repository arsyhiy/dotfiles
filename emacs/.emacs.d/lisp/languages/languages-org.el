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

(use-package org
  :ensure nil
  :hook
  (org-mode . my/org-mode-setup)
  :bind
  (("C-c o d" . my/org-open-today)
   ("C-c o t" . my/org-open-todo)
   ("C-c o c" . org-capture)
   ("C-c o a" . org-agenda)
   ("C-c o s" . org-store-link)))

(setq org-capture-tem
