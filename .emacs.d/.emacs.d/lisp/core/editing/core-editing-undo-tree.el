;;; core-editing-undo-tree.el --- undo-tree system -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package undo-tree
  :hook
  (prog-mode . undo-tree-mode)

  :config
  ;; (setq undo-tree-auto-save-history t)
  (setq undo-tree-auto-save-history nil)

  (undo-tree-visualizer-timestamps t)
  (undo-tree-visualizer-diff t)
  (undo-tree-history-directory-alist
    `(("." . ,(expand-file-name "undo" user-emacs-directory))))

  (undo-limit 16000000)
  (undo-strong-limit 32000000)
  (undo-outer-limit 128000000)

  (global-undo-tree-mode 1))

(provide 'core-editing-undo-tree)
;;; core-editing-undo-tree.el ends here
