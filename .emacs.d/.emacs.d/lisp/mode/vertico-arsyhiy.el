;;; vertico-arsyhiy.el --- VERTical Interactive COmpletion  -*- lexical-binding: t; -*-
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
  :config
  (advice-add #'vertico--format-candidate :around
    (lambda (orig cand prefix suffix index _start)
      (setq cand (funcall orig cand prefix suffix index _start))
      (concat
        (if (= vertico--index index)
          (propertize "» " 'face '(:foreground "#80adf0" :weight bold))
          "  ")
        cand))))

(provide 'vertico-arsyhiy)
;;; vertico-arsyhiy.el ends here
