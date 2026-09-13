;;; formatter-arsyhiy.el --- Simple buffer formatter -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:
;; Format current buffer depending on major-mode.

;;; Code:

(defgroup my-format nil
  "Buffer formatting."
  :group 'tools)


(defcustom my-formatters
  '((python-ts-mode . "pipx run black")
     (python-mode . "pipx run black"))
  "Formatters mapped to major modes."
  :type '(alist :key-type symbol
           :value-type string)
  :group 'my-format)


(defun my-format-get-command ()
  "Return formatter command for current major mode."
  (or (alist-get major-mode my-formatters)
    (let ((command
            (read-string
              (format "Formatter for %s: " major-mode))))

      (setf (alist-get major-mode my-formatters)
        command)

      (customize-save-variable
        'my-formatters
        my-formatters)

      command)))


(defun my-format-buffer ()
  "Format current buffer."
  (interactive)

  (unless (buffer-file-name)
    (user-error "Current buffer has no file"))

  (save-buffer)

  (let ((command (my-format-get-command)))

    (let ((exit-code
            (call-process-shell-command
              (concat command " "
                (shell-quote-argument
                  (buffer-file-name))))))

      (if (= exit-code 0)
        (progn
          (revert-buffer t t t)
          (message "Formatted with %s" command))

        (error "Formatter failed: %s" command)))))

(provide 'my-run-format)
;;; my-run-format.el ends here
