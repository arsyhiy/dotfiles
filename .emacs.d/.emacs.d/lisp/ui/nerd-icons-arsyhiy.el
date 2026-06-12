;;; nerd-icons-arsyhiy.el --- nerd icons -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(defcustom ek-use-nerd-fonts t
  "Configuration for using Nerd Fonts Symbols."
  :type 'boolean
  :group 'appearance)

(use-package nerd-icons
  :if ek-use-nerd-fonts                   ;; Load the package only if the user has configured to use nerd fonts.
  :ensure t                               ;; Ensure the package is installed.
  :defer t)                               ;; Load the package only when needed to improve startup time.

(use-package nerd-icons-corfu
  :if ek-use-nerd-fonts
  :ensure t
  :defer t
  :after (:all corfu))

(use-package nerd-icons-dired
  :if ek-use-nerd-fonts
  :ensure t
  :defer t
  :hook
  (dired-mode . nerd-icons-dired-mode))

(use-package nerd-icons-completion
  :if ek-use-nerd-fonts
  :ensure t
  :after (:all nerd-icons marginalia)
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(provide 'nerd-icons-arsyhiy)
;;; nerd-icons-arsyhiy.el ends here
