;;; eldoc-arsyhiy.el --- Programming Language Documentation Lookup -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package eldoc
  :ensure nil
  :config
  (setq eldoc-idle-delay 0.2)
  (setq eldoc-echo-area-use-multiline-p nil)
  
  (setq eldoc-echo-area-display-truncation-message nil)
  :init
  (global-eldoc-mode))


(use-package eldoc-box
  :ensure t
  :hook (eldoc-mode . eldoc-box-hover-mode))

(provide 'eldoc-arsyhiy)
;;; eldoc-arsyhiy.el ends here
