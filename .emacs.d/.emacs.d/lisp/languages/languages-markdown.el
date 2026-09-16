;; languages-markdown.el ---  Emacs Markdown Mode  -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.2"))

;;; Commentary:

;;; Code:

(use-package markdown-mode
  :ensure nil
  :defer t
  :mode ("\\.md\\'" . gfm-mode)
  (setq markdown-command "multimarkdown"
        fill-column 80)
  :hook
  (gfm-mode . auto-fill-mode))

(provide 'languages-markdown)
;;; languages-markdown.el ends here
