;;; orderless-arsyhiy.el --- Emacs completion style that matches multiple regexps in any order  -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package orderless
  :ensure t
  :defer t
  :after vertico
  :init
  (setq completion-styles '(orderless basic)
    completion-category-defaults nil
    completion-category-overrides '((file (styles partial-completion)))))

(provide 'orderless-arsyhiy)
;;; orderless-arsyhiy.el ends here
