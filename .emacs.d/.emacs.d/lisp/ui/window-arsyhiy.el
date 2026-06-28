;;; window-arsyhiy.el --- rules for window -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(setq display-buffer-alist
      '(

        ;; Debug / help buffers
        ("\\*\\(Backtrace\\|Warnings\\|Compile-Log\\|Help\\|Messages\\|Bookmark List\\|Ibuffer\\|Occur\\|eldoc.*\\)\\*"
         (display-buffer-in-side-window
          (side . bottom)
          (window-height . 0.25)
          (slot . 0)))

        ;; LSP / documentation buffers
        ("\\*lsp-help\\*"
         (display-buffer-in-side-window
          (side . bottom)
          (window-height . 0.25)
          (slot . 0)))

        ;; Diagnostics / xref / completion
        ("\\*\\(xref\\|flymake.*\\|completions.*\\)\\*"
         (display-buffer-in-side-window
          (side . bottom)
          (window-height . 0.25)
          (slot . 1)))))

(provide 'window-arsyhiy)
;;; window-arsyhiy.el ends here
