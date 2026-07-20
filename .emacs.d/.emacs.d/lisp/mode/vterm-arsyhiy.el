;;; vterm-arsyhiy.el --- the Directory Editor -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package vterm
  :ensure t
  :commands vterm
  :bind
  ("C-c t" . vterm)

  :custom
  (vterm-max-scrollback 10000)
  (vterm-shell "/bin/zsh")

  :config
  ;; Закрывать буфер после завершения процесса
  (add-hook 'vterm-exit-functions
            (lambda (_buffer _event)
              (kill-buffer))))

(provide 'vterm-arsyhiy)
;;; vterm-arsyhiy.el ends here
