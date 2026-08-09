;;; languages-typescript.el --- TypeScript configuration -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;; Personal TypeScript configuration.

;;; Code:

(use-package typescript-mode
  :init
  (add-to-list 'major-mode-remap-alist
    '(typescript-mode . typescript-ts-mode))
  (add-to-list 'major-mode-remap-alist
    '(js-mode . js-ts-mode)))

(provide 'languages-typescript)

;;; languages-typescript.el ends here
