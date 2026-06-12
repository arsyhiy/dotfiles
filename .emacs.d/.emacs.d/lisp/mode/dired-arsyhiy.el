;;; dired-arsyhiy.el --- the Directory Editor -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(with-eval-after-load 'dired
  (setq dired-listing-switches "-lah --group-directories-first"
    dired-dwim-target t
    dired-kill-when-opening-new-dired-buffer t
    dired-guess-shell-alist-user
    '(("\\.\\(png\\|jpe?g\\|tiff\\)" "feh" "xdg-open" "open")
       ("\\.\\(mp[34]\\|m4a\\|ogg\\|flac\\|webm\\|mkv\\)" "mpv" "xdg-open" "open")
       (".*" "open" "xdg-open"))))

(provide 'dired-arsyhiy)
;;; dired-arsyhiy.el ends here
