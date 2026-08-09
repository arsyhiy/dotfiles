;;; init.el --- starting point for emacs configuration -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))
 
;;; Commentary:
 
;;; Code:
 
(add-to-list 'load-path "~/.emacs.d/lisp/core/")
(add-to-list 'load-path "~/.emacs.d/lisp/languages/")
(add-to-list 'load-path "~/.emacs.d/lisp/tools/")

(require 'core)
(require 'languages)
(require 'tools)

;;; init.el ends here
