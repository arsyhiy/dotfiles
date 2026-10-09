;;; core-editing-flymake.el --- Finding Syntax Errors On The Fly -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.2"))

;;; Commentary:

;;; Code:

(use-package flymake
  :ensure nil
  :hook
  (prog-mode . flymake-mode)
  :custom
  (flymake-no-changes-timeout 0.5)
  (flymake-show-diagnostics-at-end-of-line t)
  (flymake-margin-indicators-string
    '((error   "✘" flymake-error)
       (warning "▲" flymake-warning)
       (note    "●" flymake-note))))


(with-eval-after-load 'rust-ts-mode
  (add-hook 'rust-ts-mode-hook
            (lambda ()
              (setq-local flymake-diagnostic-functions
                          (remove #'rust-ts-flymake
                                  flymake-diagnostic-functions)))))


(provide 'core-editing-flymake)
;;; core-editing-flymake.el ends here
