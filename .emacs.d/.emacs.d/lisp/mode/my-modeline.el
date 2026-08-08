;; ;; ;;; my-modeline.el --- Custom mode line -*- lexical-binding: t; -*-
;; ;; 
;; ;; ;;; Commentary:
;; ;; ;; my person modeline with inspiration from powerline code and tutorial from prot
;; ;; 
;; ;; ;;; Code:

;; (defun mode-line-window-selected-p ()
;;   "Return non-nil if current mode-line belongs to selected window."
;;   (let ((window (selected-window)))
;;     (eq window (old-selected-window))))
;; 
;; (defface my-modeline-separator
;;   '((t :inherit shadow))
;;   "Face for separators.")
;; 
;; (defface my-modeline-highlight
;;   '((t :inherit bold))
;;   "Face for important modeline parts.")
;; 
;; (defvar-local my-modeline-modified
;;   '(:eval
;;      (if (buffer-modified-p)
;;        "(*)"
;;        ""))
;;   "Display modified buffer state.")
;; 
;; (put 'my-modeline-modified 'risky-local-variable t)
;; 
;; (defvar-local my-modeline-evil
;;   '(:eval
;;      (when (bound-and-true-p evil-mode)
;;        (format "[%s]"
;;          (upcase
;;            (symbol-name evil-state)))))
;;   "Display evil state.")
;; 
;; (put 'my-modeline-evil 'risky-local-variable t)
;; 
;; (defun my-modeline--buffer-name ()
;;   "Return current buffer name."
;;   (buffer-name))
;; 
;; (defvar-local my-modeline-buffer-name
;;   '(:eval
;;      (propertize
;;        (my-modeline--buffer-name)
;;        'face 'my-modeline-highlight))
;;   "Display buffer name.")
;; 
;; (put 'my-modeline-buffer-name 'risky-local-variable t)
;; 
;; (defun my-modeline--project-file ()
;;   "Return file path relative to project root."
;;   (when-let* ((file buffer-file-name)
;;                (project (project-current))
;;                (root (project-root project)))
;;     (file-relative-name file root)))
;; 
;; 
;; (defvar-local my-modeline-project-path
;;   '(:eval
;;      (when-let ((path (my-modeline--project-file)))
;;        path))
;;   "Display file path relative to project.")
;; 
;; (put 'my-modeline-project-path 'risky-local-variable t)
;; 
;; (defvar-local my-modeline-position
;;   '(:eval
;;      (format "%d:%d"
;;        (line-number-at-pos)
;;        (current-column)))
;;   "Display line and column.")
;; 
;; (put 'my-modeline-position 'risky-local-variable t)
;; 
;; (defun my-modeline--major-mode-name ()
;;   "Return readable major mode name."
;;   (format-mode-line mode-name))
;; 
;; (defvar-local my-modeline-major-mode
;;   '(:eval
;;      (my-modeline--major-mode-name))
;;   "Display major mode.")
;; 
;; (put 'my-modeline-major-mode 'risky-local-variable t)
;; 
;; (defvar-local my-modeline-vc
;;   ;; TODO: предлагаю заменить на magit
;;   '(:eval
;;      (when vc-mode
;;        (format "[%s]"
;;          (substring-no-properties
;;            vc-mode 5))))
;;   "Display VC branch.")
;; 
;; (put 'my-modeline-vc 'risky-local-variable t)
;; 
;; 
;; (defface my-modeline
;;   '((t :inherit mode-line :height 1.2))
;;   "Main face for my modeline.")
;; 
;; 
;; (setq-default mode-line-format
;;   '("%e"
;;      (:propertize
;;        (:eval
;;          (format-mode-line
;;            '(""
;;               my-modeline-modified
;;               " | "
;;               my-modeline-evil
;;               " | "
;;               my-modeline-buffer-name
;;               " | "
;;               my-modeline-project-path
;;               " | "
;;               my-modeline-position
;;               " | "
;;               my-modeline-major-mode
;;               " | "
;;               my-modeline-vc)))
;;        face my-modeline)))


(provide 'my-modeline)
;;; my-modeline.el ends here
