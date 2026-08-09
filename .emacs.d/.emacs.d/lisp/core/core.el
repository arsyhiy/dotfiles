;;; core.el --- core module entrance -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(add-to-list 'load-path
             (expand-file-name "editing" (file-name-directory load-file-name)))

(add-to-list 'load-path
             (expand-file-name "ui" (file-name-directory load-file-name)))

(add-to-list 'load-path
             (expand-file-name "other" (file-name-directory load-file-name)))

;; core
(require 'core-interface)
(require 'core-options)
(require 'core-libraries)

;; editing
(require 'core-editing-evil)
(require 'core-editing-cape)
(require 'core-editing-consult)
(require 'core-editing-corfu)
(require 'core-editing-eldoc)
(require 'core-editing-flymake)
(require 'core-editing-isearch)
(require 'core-editing-marginalia)
(require 'core-editing-orderless)
(require 'core-editing-undo-tree)
(require 'core-editing-vertico)
(require 'core-editing-which-key)
(require 'core-editing-yasnippet)

;; ui
(require 'core-ui-theme)
(require 'core-ui-modeline)
(require 'core-ui-diff-hl)
(require 'core-ui-hl-todo)
(require 'core-ui-indent-guide)
(require 'core-ui-nerd-icons)
(require 'core-ui-rainbow-delimiters)
(require 'core-ui-treesitter)
(require 'core-ui-window)

;; other
(require 'core-other-smerge)
(require 'core-other-vterm)
(require 'core-other-dired)

(provide 'core)
;;; core.el ends here
