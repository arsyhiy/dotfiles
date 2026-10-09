;;; core-editing-undo-tree.el --- undo-tree system -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.2"))

;;; Commentary:

;;; Code:

(use-package undo-tree
  :config
  (setq undo-tree-auto-save-history nil)

  (setq undo-tree-visualizer-timestamps t)
  (setq undo-tree-visualizer-diff t)

  (setq undo-tree-history-directory-alist
        `(("." . ,(expand-file-name "undo" user-emacs-directory))))

  (setq undo-limit 16000000
        undo-strong-limit 32000000
        undo-outer-limit 128000000)

  (global-undo-tree-mode 1))

(provide 'core-editing-undo-tree)
;;; core-editing-undo-tree.el ends here
