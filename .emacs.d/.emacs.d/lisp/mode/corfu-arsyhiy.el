;;; corfu-arsyhiy.el --- text completion framework for Emacs -*- lexical-binding: t; -*-
;; author: arsyhiy
;; package-requires: ((emacs "30.1"))

;;; commentary:

;;; code:

(use-package corfu
  :ensure t
  :defer t
  :custom
  (corfu-auto t)
  (corfu-auto-prefix 3)
  (corfu-quit-no-match nil)
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
