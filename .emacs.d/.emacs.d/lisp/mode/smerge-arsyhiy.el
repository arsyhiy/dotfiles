;;; smerge-arsyhiy.el --- resolving merge conflicts in files -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package smerge-mode
  :ensure nil
  :defer t
  :bind (:map smerge-mode-map
          ("C-c ^ u" . smerge-keep-upper)
          ("C-c ^ l" . smerge-keep-lower)
          ("C-c ^ n" . smerge-next)
          ("C-c ^ p" . smerge-previous)))

(provide 'smerge-arsyhiy)
;;; smerge-arsyhiy.el ends here
