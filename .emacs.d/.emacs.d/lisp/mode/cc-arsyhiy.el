;;; cc-arsyhiy.el --- mode for c and c++  -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package c-ts-mode
  :ensure nil
  :mode
  ("\\.c\\'" . c-ts-mode)
  ("\\.h\\'" . c-or-c++-ts-mode)
  ("\\.cpp\\'" . c++-ts-mode)
  ("\\.hpp\\'" . c++-ts-mode)

  :bind
  (:map c-ts-mode-map
    ("<f1>" . my-c/make-clean)
    ("<f2>" . my-c/make-all)
    ("<f3>" . my-c/make-run))

  :config

  (c-ts-indent-offset 4)
  (c-ts-mode-indent-style 'linux)

  (c-ts-mode-enable-doxygen t)

  (eletric-pair-mode 1))

(defun my-c/make-clean ()
  "Run make clean in project root."
  (interactive)
  (let ((default-directory (projectile-project-root)))
    (compile "make clean")))

(defun my-c/make-all ()
  "Run make all in project root."
  (interactive)
  (let ((default-directory (projectile-project-root)))
    (compile "make all")))

(defun my-c/make-run ()
  "Run make run in project root."
  (interactive)
  (let ((default-directory (projectile-project-root)))
    (compile "make run")))

;; todo: add make-custom with arguments memory.

(provide 'cc-arsyhiy)
;;; cc-arsyhiy.el ends here
