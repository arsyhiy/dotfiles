;;; languages-org.el --- Your life in plain text -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.2"))

;;; Commentary:

;;; Code:

(use-package org
  :ensure nil
  :hook
  (org-mode . auto-fill-mode)
  (org-mode . (lambda () (setq-local fill-column 80))))

(provide 'languages-org)
;;; languages-org.el ends here
