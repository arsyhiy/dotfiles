;;; undo-tree-arsyhiy.el --- undo-tree system -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package undo-tree
  :defer t
  :ensure t
  :hook
  (after-init . global-undo-tree-mode)
  :init
  (setq undo-tree-visualizer-timestamps t
    undo-tree-visualizer-diff t
    undo-limit 800000
    undo-strong-limit 12000000
    undo-outer-limit 120000000)
  :config
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/.cache/undo"))))

(provide 'undo-tree-arsyhiy)
;;; undo-tree-arsyhiy.el ends here
