;;; orderless-arsyhiy.el --- Emacs completion style that matches multiple regexps in any order  -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless flex basic))
  (completion-category-defaults nil)
  (completion-category-overrides
    '((file (styles partial-completion))))
  :config
  (defun arsyhiy/orderless-literal-dispatcher
    (pattern _index _total)
    (when (string-prefix-p "=" pattern)
      `(orderless-literal . ,(substring pattern 1))))

  (setq orderless-style-dispatchers
    '(arsyhiy/orderless-literal-dispatcher)))

(provide 'orderless-arsyhiy)
;;; orderless-arsyhiy.el ends here
