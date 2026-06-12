;;; org-arsyhiy.el --- Your life in plain text -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package org
  :ensure nil
  :defer t
  :hook
  (org-mode . auto-fill-mode)
  :config
  (setq org-agenda-files '("~/NOTES/orgfiles/todo.org"))
  (add-hook 'org-mode-hook
    (lambda ()
      (setq-local fill-column 80))))


(global-set-key (kbd "C-c o")
  (lambda ()
    (interactive)
    (org-agenda nil "a")))
(global-set-key (kbd "C-c t")
  (lambda ()
    (interactive)
    (find-file "~/NOTES/orgfiles/todo.org")))

(provide 'org-arsyhiy)
;;; org-arsyhiy.el ends here
