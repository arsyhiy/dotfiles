;;; consult-arsyhiy.el --- Search and navigate via completing-read -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:
;; Clean and stable Consult configuration for Emacs 30+.
;; Avoids fragile advice overrides and minimizes window side effects.

;;; Code:

(use-package consult
  :ensure t

  ;; Lazy load only what is actually used
  :commands
  (consult-buffer
    consult-line
    consult-ripgrep
    consult-find
    consult-imenu
    consult-register-store
    consult-register-load)

  :init
  ;; --- XREF integration (safe and standard way) ---
  (setq xref-show-xrefs-function #'consult-xref
    xref-show-definitions-function #'consult-xref)

  ;; --- Register preview integration (NO advice override) ---
  ;; This is the modern, safe replacement for:
  ;; (advice-add #'register-preview :override ...)
  (setq register-preview-function #'consult-register-window)

  ;; --- Optional UX tuning ---
  (setq consult-narrow-key "<")

  :config
  ;; --- Better performance & predictable previews ---
  (setq consult-preview-key "M-.")

  ;; Prevent Consult from aggressively stealing focus in some workflows
  (setq consult-buffer-display-action #'display-buffer-same-window)

  ;; Slightly more stable async behavior for grep/search
  (setq consult-async-min-input 2
    consult-async-refresh-delay 0.15
    consult-async-input-throttle 0.2
    consult-async-input-debounce 0.3))

(provide 'consult-arsyhiy)
;;; consult-arsyhiy.el ends here
