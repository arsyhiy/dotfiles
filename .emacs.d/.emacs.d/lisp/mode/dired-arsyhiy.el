;;; dired-arsyhiy.el --- the Directory Editor -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(with-eval-after-load 'dired
  (setq dired-dwim-target t
        dired-kill-when-opening-new-dired-buffer t)

  (setq dired-listing-switches
        (if (eq system-type 'gnu/linux)
            "-lah --group-directories-first"
          "-lah"))

  (setq dired-guess-shell-alist-user
        '(("\\.\\(png\\|jpe?g\\|tiff\\)"
           (cond
            ((executable-find "feh") "feh")
            ((executable-find "xdg-open") "xdg-open")
            (t "open")))
          ("\\.\\(mp[34]\\|m4a\\|ogg\\|flac\\|webm\\|mkv\\)"
           (cond
            ((executable-find "mpv") "mpv")
            ((executable-find "xdg-open") "xdg-open")
            (t "open")))
          (".*"
           (or (and (executable-find "xdg-open") "xdg-open")
               "open")))))



(provide 'dired-arsyhiy)
;;; dired-arsyhiy.el ends here
