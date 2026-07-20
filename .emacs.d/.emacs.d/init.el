;;; init.el --- starting point for emacs configuration -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

;; loading directories
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp/"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp/mode"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp/personal"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp/ui"))


;; options
(require 'options)

;; === modes =============================================================================
(require 'cape-arsyhiy)
(require 'consult-arsyhiy)
(require 'corfu-arsyhiy)
(require 'dired-arsyhiy)
(require 'eldoc-arsyhiy)
(require 'evil-arsyhiy)
(require 'flymake-arsyhiy)
(require 'isearch-arsyhiy)
(require 'lsp-arsyhiy)
(require 'magit-arsyhiy)
(require 'marginalia-arsyhiy)
(require 'markdown-arsyhiy)
(require 'orderless-arsyhiy)
(require 'org-arsyhiy)
(require 'smerge-arsyhiy)
(require 'undo-tree-arsyhiy)
(require 'vertico-arsyhiy)
(require 'which-key-arsyhiy)
(require 'vterm-arsyhiy)

;; programming languages
(require 'python-arsyhiy)
(require 'elisp-arsyhiy)
(require 'cc-arsyhiy)
(require 'html-arsyhiy)
(require 'js-arsyhiy)
(require 'css-arsyhiy)
(require 'typescript-arsyhiy)


;; === ui ================================================================================
(require 'diff-hl-arsyhiy)
(require 'hl-todo-arsyhiy)
(require 'indent-guide-arsyhiy)
(require 'nerd-icons-arsyhiy)
(require 'rainbow-delimiters-arsyhiy)
(require 'themes-arsyhiy)
(require 'treesitter-arsyhiy)
(require 'window-arsyhiy)


;;; init.el ends here
