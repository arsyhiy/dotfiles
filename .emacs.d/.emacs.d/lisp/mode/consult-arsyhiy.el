;;; consult-arsyhiy.el --- Search and navigate via completing-read -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package consult
  :ensure t

  :init
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  :config
  (with-eval-after-load 'register
    (setq register-preview-function #'consult-register-window))

  (setq consult-narrow-key "<"
        consult-preview-key 'any)

  (setq consult-buffer-display-action #'display-buffer-same-window)

  (setq consult-async-min-input 2
        consult-async-refresh-delay 0.15
        consult-async-input-throttle 0.2
        consult-async-input-debounce 0.3))

(provide 'consult-arsyhiy)
;;; consult-arsyhiy.el ends here
