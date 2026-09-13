```elisp
;;; core-other-vterm.el --- Vterm -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package vterm
  :straight t
  :commands vterm
  :bind
  ("C-c t" . vterm)

  :custom
  (vterm-max-scrollback 10000)
  (vterm-shell "/bin/zsh")

  :config
  ;; Закрывать буфер после завершения процесса
  (add-hook 'vterm-exit-functions
            (lambda (buffer _event)
              (when (buffer-live-p buffer)
                (kill-buffer buffer)))))

(provide 'core-other-vterm)
;;; core-other-vterm.el ends here
```
