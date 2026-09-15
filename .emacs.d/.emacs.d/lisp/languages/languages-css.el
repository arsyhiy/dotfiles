;;; languages-css.el --- CSS configuration -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.2"))

;;; Commentary:

;;; Code:

(use-package css-ts-mode
  :ensure nil
  :mode "\\.css\\'"
  :hook
  (css-ts-mode . electric-pair-local-mode)
  (css-ts-mode . (lambda ()
                   (setq-local tab-width 2
                     css-indent-offset 2)))
  :config
  (add-to-list 'major-mode-remap-alist
    '(css-mode . css-ts-mode)))

(provide 'languages-css)

;;; languages-css.el ends here
