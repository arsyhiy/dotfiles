;;; markdown-arsyhiy.el ---  Emacs Markdown Mode  -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package markdown-mode
  :defer t
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))

(provide 'markdown-arsyhiy)
;;; markdown-arsyhiy.el ends here
