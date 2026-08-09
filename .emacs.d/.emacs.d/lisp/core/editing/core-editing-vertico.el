;;; core-editting-vertico.el --- VERTical Interactive COmpletion  -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package vertico
  :ensure t
  :hook
  (after-init . vertico-mode)

  :custom
  (vertico-count 10)
  (vertico-resize nil)
  (vertico-cycle nil)
  (vertico-preselect 'directory))

(provide 'core-editing-vertico)
;;; core-editting-vertico.el ends here
