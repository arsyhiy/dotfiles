;;; undo-tree-arsyhiy.el --- undo-tree system -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package undo-tree
  :init
  (global-undo-tree-mode 1)

  :custom
  (undo-tree-auto-save-history t)
  (undo-tree-visualizer-timestamps t)
  (undo-tree-visualizer-diff t)
  (undo-tree-history-directory-alist
   `(("." . ,(expand-file-name "undo" user-emacs-directory))))

  (undo-limit 16000000)
  (undo-strong-limit 32000000)
  (undo-outer-limit 128000000))

(provide 'undo-tree-arsyhiy)
;;; undo-tree-arsyhiy.el ends here
