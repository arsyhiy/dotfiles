;;; which-key-arsyhiy.el --- Emacs package that displays available keybindings in popup  -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package which-key
  :ensure nil
  :defer t
  :hook
  (after-init . which-key-mode))

(provide 'which-key-arsyhiy)
;;; which-key-arsyhiy.el ends here
