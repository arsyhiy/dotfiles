;;; run-program.el --- run programm like hit a button -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;; Minimal generic execution framework.
;;
;; Example:
;;
;;   (defun python-runner-setup ()
;;     "Configure runner for Python."
;;
;;     (setq-local runner-runtime "python3")
;;
;;     (setq-local runner-target-function
;;                 #'runner-current-file)
;;
;;     (runner-mode 1))
;;
;;   (add-hook 'python-ts-mode-hook
;;             #'python-runner-setup)

;;; Code:

(require 'compile)
(require 'project)


;; customization group

(defgroup runner nil
  "Simple generic execution framework."
  :group 'tools)


;; Hooks

(defcustom runner-before-run-hook nil
  "Hook run before executing command."
  :type 'hook
  :group 'runner)

(defcustom runner-after-run-hook nil
  "Hook run after executing command."
  :type 'hook
  :group 'runner)


;; buffer local configuration

(defvar-local runner-runtime nil
  "Runtime command used to execute current buffer.")

(defvar-local runner-target-function nil
  "Function returning execution target for current buffer.")


;; history

(defvar runner-args-history nil
  "History for runner arguments.")


;; helpers

(defun runner-current-file ()
  "Return current buffer filename."
  (shell-quote-argument
   (buffer-file-name)))

(defun runner-project-root ()
  "Return current project root or nil."
  (when-let ((project (project-current)))
    (project-root project)))


;; command builder

(defun runner-command (&optional args)
  "Build execution command with ARGS."
  (unless runner-runtime
    (user-error "runner-runtime is not set"))

  (unless runner-target-function
    (user-error "runner-target-function is not set"))

  (concat
   runner-runtime
   " "
   (funcall runner-target-function)

   (when args
     (concat
      " "
      (mapconcat
       #'shell-quote-argument
       args
       " ")))))


;; execution

(defun runner-run (&optional args)
  "Run current buffer with ARGS."
  (interactive)

  (run-hooks 'runner-before-run-hook)

  (let ((default-directory
          (or (runner-project-root)
              default-directory))

        (command
         (runner-command args)))

    ;; integrate with compile/recompile
    (setq-local compile-command command)

    (compile command))

  (run-hooks 'runner-after-run-hook))

(defun runner-run-with-args ()
  "Run current buffer with arguments."
  (interactive)

  (let ((args
         (split-string
          (read-string
           "Args: "
           nil
           'runner-args-history))))

    (runner-run args)))


;; keymap

(defvar runner-mode-map
  (let ((map (make-sparse-keymap)))

    (define-key map (kbd "<f5>")
                #'runner-run)

    (define-key map (kbd "C-c C-r")
                #'runner-run-with-args)

    map)
  "Keymap for `runner-mode'.")


;; minor mode

(define-minor-mode runner-mode
  "Minor mode for generic execution."
  :lighter " Run"
  :keymap runner-mode-map)


(provide 'run-program)

;;; run-program.el ends here
