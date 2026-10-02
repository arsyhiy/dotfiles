;;; languages-rust.el --- rust configuration -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.2"))

;;; Commentary:

;;; Code:

(use-package rust-mode

  :ensure nil
  :mode "\\.rs\\'")

(add-to-list 'exec-path (expand-file-name "~/.cargo/bin"))
(setenv "PATH"
        (concat (expand-file-name "~/.cargo/bin") ":"
                (getenv "PATH")))


(provide 'languages-rust)
;;; languages-rust.el ends here
