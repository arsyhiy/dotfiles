;;; python-arsyhiy.el --- mode for programming language python -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package python
  :ensure nil
  :mode ("\\.py\\'" . python-ts-mode)
  :hook ((python-ts-mode . lsp-deferred)))

;; TODO: обдумать все случаи при использовании форматирования
(defun my-py/format-buffer ()
  "Format the current Python file with Black."
  (interactive)
  (unless (buffer-file-name)
    (user-error "Current buffer is not visiting a file"))

  (save-buffer)

  (let ((default-directory (projectile-project-root)))
    (let ((exit-code
            (call-process
              "pipx"
              nil
              nil
              nil
              "run"
              "black"
              (buffer-file-name))))
      (if (= exit-code 0)
        (progn
          (revert-buffer t t t)
          (message "Formatted with Black"))
        (error "Black failed with exit code %s" exit-code)))))

(provide 'python-arsyhiy)
;;; python-arsyhiy.el ends here
