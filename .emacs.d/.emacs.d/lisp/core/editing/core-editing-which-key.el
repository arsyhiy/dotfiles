;;; core-editing-which-key.el --- Emacs package that displays available keybindings in popup  -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package which-key
  :ensure nil
  :defer t
  :hook
  (after-init . which-key-mode))

(provide 'core-editing-which-key)
;;; core-editing-which-key.el ends here
