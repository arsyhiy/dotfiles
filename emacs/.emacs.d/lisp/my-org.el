;;; my-org.el --- Org-roam journal configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; Open today's Org-roam journal with SPC j t or M-x my-org-roam-journal-open-today.
;; Org files live in ~/orgjournal/.

;;; Code:

(require 'org)

(use-package org-roam
  :straight t
  :after org
  :init
  (setq org-roam-directory (expand-file-name "~/orgjournal/")
        org-roam-dailies-directory "./")
  (make-directory org-roam-directory t)
  :config
  (require 'org-roam-dailies)
  (org-roam-db-autosync-mode 1))

(defun my-org--enable-auto-fill ()
  (setq-local fill-column 80)
  (auto-fill-mode 1))

(defun my-org-roam-journal-open-today ()
  "Open today's Org-roam daily note."
  (interactive)
  (org-roam-dailies-goto-today))

(add-hook 'org-mode-hook #'my-org--enable-auto-fill)

(with-eval-after-load 'evil
  (evil-define-key 'normal 'global (kbd "<leader> j t")
    #'my-org-roam-journal-open-today))

(provide 'my-org)
;;; my-org.el ends here
