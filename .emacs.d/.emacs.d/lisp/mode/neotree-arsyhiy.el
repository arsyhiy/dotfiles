;;; neotree-arsyhiy.el ---  A emacs tree plugin like NerdTree for Vim.  -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package neotree
  :ensure t
  :custom
  (neo-show-hidden-files t)
  (neo-theme 'nerd)
  (neo-vc-integration '(face char))
  :defer t
  :config
  (if ek-use-nerd-fonts
    (setq neo-theme 'nerd-icons)
    (setq neo-theme 'nerd)))

(provide 'neotree-arsyhiy)
;;; neotree-arsyhiy.el ends here
