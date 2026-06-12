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

;; functionality for initialization
(defun srequire (feature)
  "Safe open FEATURE just like require."
  (condition-case err
    (require feature)
    (error
      (with-current-buffer (get-buffer-create "*Config Errors*")
        (goto-char (point-max))
        (insert-text-button
          (format "Ошибка в %s\n" feature)
          'action
          (lambda (_)
            (find-library (symbol-name feature))))
        (insert (error-message-string err) "\n\n")
        (display-buffer (current-buffer))))
    nil))

;; options
(srequire 'options)

;; === modes =============================================================================
(srequire 'cape-arsyhiy)
(srequire 'consult-arsyhiy)
(srequire 'corfu-arsyhiy)
(srequire 'dired-arsyhiy)
(srequire 'eldoc-arsyhiy)
(srequire 'evil-arsyhiy)
(srequire 'flymake-arsyhiy)
(srequire 'isearch-arsyhiy)
(srequire 'lsp-arsyhiy)
(srequire 'magit-arsyhiy)
(srequire 'marginalia-arsyhiy)
(srequire 'markdown-arsyhiy)
(srequire 'neotree-arsyhiy)
(srequire 'orderless-arsyhiy)
(srequire 'org-arsyhiy)
(srequire 'smerge-arsyhiy)
(srequire 'undo-tree-arsyhiy)
(srequire 'vertico-arsyhiy)
(srequire 'which-key-arsyhiy)
(srequire 'yasnippet-arsyhiy)

;; programming languages
(srequire 'python-arsyhiy)
(srequire 'elisp-arsyhiy)
(srequire 'cc-arsyhiy)
(srequire 'html-arsyhiy)
(srequire 'js-arsyhiy)
(srequire 'css-arsyhiy)
(srequire 'typescript-arsyhiy)

;; === personal ==========================================================================
(srequire 'run-program)
(srequire 'org-utils.el)

;; === ui ================================================================================
(srequire 'diff-hl-arsyhiy)
(srequire 'hl-todo-arsyhiy)
(srequire 'indent-guide-arsyhiy)
(srequire 'nerd-icons-arsyhiy)
(srequire 'rainbow-delimiters-arsyhiy)
(srequire 'themes-arsyhiy)
(srequire 'treesitter-arsyhiy)
(srequire 'window-arsyhiy)

;;; init.el ends here
