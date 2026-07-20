;;; nerd-icons-arsyhiy.el --- nerd icons -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(defcustom ek-use-nerd-fonts t
  "Use Nerd Fonts icons."
  :type 'boolean
  :group 'appearance)

(use-package nerd-icons
  :if ek-use-nerd-fonts
  :ensure t)

(use-package nerd-icons-corfu
  :if ek-use-nerd-fonts
  :ensure t)

(use-package nerd-icons-dired
  :if ek-use-nerd-fonts
  :ensure t
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package nerd-icons-completion
  :if ek-use-nerd-fonts
  :ensure t
  :after marginalia
  :config
  (nerd-icons-completion-mode)

  (with-eval-after-load 'marginalia
    (nerd-icons-completion-marginalia-setup)))

(provide 'nerd-icons-arsyhiy)
;;; nerd-icons-arsyhiy.el ends here
