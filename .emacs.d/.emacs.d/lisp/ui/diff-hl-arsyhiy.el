;;; diff-hl-arsyhiy.el --- Emacs package for highlighting uncommitted changes -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package diff-hl
  :defer t
  :ensure t
  :hook
  (find-file . (lambda ()
                 (global-diff-hl-mode)
                 (diff-hl-flydiff-mode)
                 (diff-hl-margin-mode)))
  :custom
  (diff-hl-side 'left)
  (diff-hl-margin-symbols-alist '((insert . "┃")
                                   (delete . "-")
                                   (change . "┃")
                                   (unknown . "┆")
                                   (ignored . "i"))))

(provide 'diff-hl-arsyhiy)
;;; diff-hl-arsyhiy.el ends here
