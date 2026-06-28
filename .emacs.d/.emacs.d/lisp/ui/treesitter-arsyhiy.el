;;; treesitter-arsyhiy.el --- treesitter support -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; code:

(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install t)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode t))

;; временный хак в будущем удалить его
;; честно тут я чуть не бросил emacs настолько это меня вымараживает
(setq treesit-language-source-alist
  '((c   "https://github.com/tree-sitter/tree-sitter-c" "v0.23.2")
     (cpp "https://github.com/tree-sitter/tree-sitter-cpp" "v0.23.2")
     (css "https://github.com/tree-sitter/tree-sitter-css" "v0.23.2")
     (html "https://github.com/tree-sitter/tree-sitter-html" "v0.23.2")
     (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "v0.20.2")))

(provide 'treesitter-arsyhiy)
;;; treesitter-arsyhiy.el ends here
