;;; early-init.el --- Early initialization -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(setq package-enable-at-startup nil)

(setq straight-check-for-modifications nil)
(setq straight-use-package-by-default t)

(defvar bootstrap-version)

(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        user-emacs-directory))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent
         'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(require 'use-package)

(setq gc-cons-threshold most-positive-fixnum)
(setq gc-cons-percentage 1.0)

(setq file-name-handler-alist nil)

(setq inhibit-startup-screen t
      inhibit-startup-echo-area-message t)

(setq frame-resize-pixelwise t
      frame-inhibit-implied-resize t)

(setq read-process-output-max (* 4 1024 1024))

(setq bidi-display-reordering 'left-to-right
      bidi-inhibit-bpa t)

;;; early-init.el ends here
