;;; js-arsyhiy.el --- mode for js -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(add-hook 'js-ts-mode-hook
  (lambda ()
    (setq-local js-indent-level 2
      tab-width 2)
    (electric-pair-local-mode 1)))

(provide 'js-arsyhiy)
;;; js-arsyhiy.el ends here
