;;; elips-arsyhiy.el --- mode for emacs lisp -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(defun my-elisp-mode-setup ()
  (electric-pair-local-mode 1)
  (show-paren-local-mode 1)
  (eldoc-mode 1)
  (prettify-symbols-mode 1)

  (setq-local indent-tabs-mode nil
    lisp-indent-offset 2)

  (local-set-key (kbd "C-c C-e") #'eval-last-sexp)
  (local-set-key (kbd "C-c C-r") #'eval-region)
  (local-set-key (kbd "C-c C-b") #'eval-buffer)

  (add-hook 'before-save-hook
    (lambda ()
      (indent-region (point-min) (point-max)))
    nil t))

(add-hook 'emacs-lisp-mode-hook #'my-elisp-mode-setup)

(provide 'elisp-arsyhiy)
;;; elisp-arsyhiy.el ends here
