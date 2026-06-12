;;; corfu-arsyhiy.el --- text completion framework for Emacs -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package corfu
  :ensure t
  :defer t
  :custom
  (corfu-auto t)
  (corfu-auto-prefix 1)
  (corfu-quit-no-match t)
  (corfu-scroll-margin 5)
  (corfu-max-width 50)
  (corfu-min-width 50)
  (corfu-popupinfo-delay 0.5)
  :config
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode t))

(provide 'corfu-arsyhiy)
;;; corfu-arsyhiy.el ends here
