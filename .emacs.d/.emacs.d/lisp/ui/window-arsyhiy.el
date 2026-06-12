;;; window-arsyhiy.el --- starting point for emacs configuration -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(defun my-window-setup ()
  (setq display-buffer-alist
    '(

       ("\\*\\(Backtrace\\|Warnings\\|Compile-Log\\|[Hh]elp\\|Messages\\|Bookmark List\\|Ibuffer\\|Occur\\|eldoc.*\\)\\*"
         (display-buffer-in-side-window)
         (window-height . 0.25)
         (side . bottom)
         (slot . 0))

       ("\\*\\(lsp-help\\)\\*"
         (display-buffer-in-side-window)
         (window-height . 0.25)
         (side . bottom)
         (slot . 0))

       ("\\*\\(Flymake diagnostics\\|xref\\|ivy\\|Swiper\\|Completions\\)\\*"
         (display-buffer-in-side-window)
         (window-height . 0.25)
         (side . bottom)
         (slot . 1)))))

(my-window-setup)

(provide 'window-arsyhiy)
;;; window-arsyhiy.el ends here
