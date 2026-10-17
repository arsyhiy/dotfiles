;;; config.el --- configuration file in .el   -*- lexical-binding: t; -*-

(use-package consult
  :ensure t
  :init
  (setq xref-show-xrefs-function #'consult-xref
    xref-show-definitions-function #'consult-xref)
  :config
  (with-eval-after-load 'register
    (setq register-preview-function #'consult-register-window))
  (setq consult-narrow-key "<"
    consult-preview-key 'any)
  (setq consult-buffer-display-action #'display-buffer-same-window)
  (setq consult-async-min-input 2
    consult-async-refresh-delay 0.15
    consult-async-input-throttle 0.2
    consult-async-input-debounce 0.3))

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

(use-package emacs
  :ensure nil
  :custom

  ;; files ======================================;;
  (auto-save-default nil)
  (create-lockfiles nil)
  (delete-by-moving-to-trash t)
  (make-backup-files nil)
  (dired-free-space nil
                    dired-dwim-target t
                    dired-deletion-confirmer 'y-or-n-p
                    dired-filter-verbose nil
                    dired-recursive-deletes 'top
                    dired-recursive-copies 'always
                    dired-vc-rename-file t
                    dired-create-destination-dirs 'ask
                    dired-clean-confirm-killing-deleted-buffers nil
                    dired-auto-revert-buffer 'dired-directory-changed-p)

  ;; editing ====================================;;
  (delete-selection-mode 1)
  (indent-tabs-mode nil)
  (tab-always-indent 'complete)
  (tab-width 2)

  (comment-multi-line t)
  ;; (comment-auto-fill-only-comments t)
  (comment-empty-lines t)
  (sentence-end-double-space nil)
  (require-final-newline t)

  ;; buffers ====================================;;
  (global-auto-revert-non-file-buffers t)
  (history-length 25)
  (initial-scratch-message "")
  (switch-to-buffer-obey-display-actions t)
  (truncate-lines t)
  (dired-auto-revert-buffer t)
  (x-underline-at-descent-line t) (require-final-newline t)
  (truncate-string-ellipsis "…")
  (show-paren-delay 0.1
                    show-paren-highlight-openparen t
                    show-paren-when-point-inside-paren t
                    fshow-paren-when-point-in-periphery t)
  (custom-buffer-done-kill t)
  (display-line-numbers-width 3)
  (numbers-widen t)
  (split-width-threshold 170
                         split-height-threshold nil)

  ;; others =====================================;;
  (inhibit-startup-message t)
  (column-number-mode t)
  (ispell-dictionary "en_US")
  (pixel-scroll-precision-mode t)
  (pixel-scroll-precision-use-momentum nil)
  (ring-bell-function 'ignore)
  (split-width-threshold 300)
  (treesit-font-lock-level 4)
  (use-dialog-box nil)
  (use-short-answers t)
  (warning-minimum-level :emergency)
  (frame-title-format "%b — Emacs")
  (enable-local-eval nil)
  (bookmark-save-flag 1)
  (gc-cons-threshold #x40000000)
  (read-process-output-max (* 1024 1024 4))

  :hook
  (prog-mode . display-line-numbers-mode)
  ('before-save-hook #'delete-trailing-whitespace)
  ('after-save-hook #'executable-make-buffer-file-executable-if-script-p)

  :config
  (defun skip-these-buffers (_window buffer _bury-or-kill)
    (string-match "\\*[^*]+\\*" (buffer-name buffer)))
  (setq switch-to-prev-buffer-skip 'skip-these-buffers)

  ;; fonts
  (set-face-attribute 'default nil :family "JetBrainsMono Nerd Font" :height 150)

  (setq custom-file (locate-user-emacs-file "custom-vars.el"))
  (load custom-file 'noerror 'nomessage)

  (set-display-table-slot standard-display-table 'vertical-border (make-glyph-code ?│))

  :init
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (when scroll-bar-mode
    (scroll-bar-mode -1))
  (global-hl-line-mode -1)
  (global-auto-revert-mode 1)
  (recentf-mode 1)
  (savehist-mode 1)
  (save-place-mode 1)
  (winner-mode 1)
  (file-name-shadow-mode 1)
  (show-paren-mode 1)
  (electric-pair-mode 1)
  (electric-indent-mode 1)
  (modify-coding-system-alist 'file "" 'utf-8))

(use-package marginalia
  :ensure t
  :hook (after-init . marginalia-mode)
  :custom
  (marginalia-align 'right)
  (marginalia-align-offset 8)
  (marginalia-max-relative-age 0))

(use-package orderless
  :ensure t
  :init
  (setq completion-styles '(orderless basic)
    completion-category-defaults nil
    completion-category-overrides
    '((file (styles partial-completion))
       (command (styles orderless))
       (symbol (styles orderless))
       (variable (styles orderless))))
  (setq completion-flex-nospace t))

(use-package vterm
  :ensure t
  :commands vterm
  :bind
  ("C-c t" . vterm)

  :custom
  (vterm-max-scrollback 10000)
  (vterm-shell "/bin/zsh")

  :config
  (add-hook 'vterm-exit-functions
    (lambda (buffer _event)
      (when (buffer-live-p buffer)
        (kill-buffer buffer)))))

(use-package projectile
  :ensure t
  :config
  (projectile-mode +1))

(defcustom my/project-compile-commands nil
  "Alist of project roots and their last compile commands."
  :type '(alist :key-type directory
                :value-type string)
  :group 'tools)

(defun my/project-run-compile ()
  "Run an interactive compile command for the current project."
  (interactive)
  (unless (projectile-project-p)
    (user-error "Current buffer is not inside a Projectile project"))

  (let* ((root (file-name-as-directory
                (expand-file-name (projectile-project-root))))
         (default-directory root)
         (previous (cdr (assoc root my/project-compile-commands)))
         (command (read-string
                   (if previous
                       (format "Run in %s (default %s): "
                               (abbreviate-file-name root)
                               previous)
                     (format "Run in %s: "
                             (abbreviate-file-name root)))
                   nil nil previous)))

    (unless (string-empty-p command)
      (setf (alist-get root my/project-compile-commands
                       nil nil #'string=)
            command)

      ;; Persist commands between Emacs sessions.
      (customize-save-variable
       'my/project-compile-commands
       my/project-compile-commands)

      ;; Run from the project root.
      (compile command))))

(global-set-key (kbd "<f5>") #'my/project-run-compile)

(use-package undo-tree
  :config
  (setq undo-tree-auto-save-history nil
        undo-tree-visualizer-timestamps t
        undo-tree-visualizer-diff t
        undo-tree-history-directory-alist
        `(("." . ,(expand-file-name "undo" user-emacs-directory)))
        undo-limit 16000000
        undo-strong-limit 32000000
        undo-outer-limit 128000000)

  :hook
  (after-init . global-undo-tree-mode))

(defun load-config ()
  (interactive)
  (org-babel-load-file
   (expand-file-name "config.org" user-emacs-directory)))

(use-package evil
  :hook
  (after-init . evil-mode)
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-u-delete t)
  :config
  (evil-set-initial-state 'eshell-mode 'emacs)
  (evil-set-initial-state 'shell-mode 'emacs)
  (evil-set-undo-system 'undo-tree)

  (setq evil-leader/in-all-states t)
  (setq evil-want-fine-undo t)

  (evil-set-leader 'normal (kbd "SPC"))
  (evil-set-leader 'visual (kbd "SPC"))

  (evil-define-key 'normal 'global
    (kbd "C-h") #'windmove-left
    (kbd "C-j") #'windmove-down
    (kbd "C-k") #'windmove-up
    (kbd "C-l") #'windmove-right)

  (evil-define-key 'normal 'global (kbd "<leader> c f") 'consult-find)
  (evil-define-key 'normal 'global (kbd "<leader> c g") 'consult-grep)
  (evil-define-key 'normal 'global (kbd "<leader> c G") 'consult-git-grep)
  (evil-define-key 'normal 'global (kbd "<leader> c r") 'consult-ripgrep)
  (evil-define-key 'normal 'global (kbd "<leader> c i") 'consult-info)
  (evil-define-key 'normal 'global (kbd "<leader> c l") 'consult-line)
  (evil-define-key 'normal 'global (kbd "<leader> c s") #'consult-imenu)
  
  (evil-define-key 'normal 'global (kbd "<leader> f f") 'consult-flymake)
  (evil-define-key 'normal 'global (kbd "<leader> f n") 'flymake-goto-next-error)
  (evil-define-key 'normal 'global (kbd "<leader> f p") 'flymake-goto-prev-error)
  
  (evil-define-key 'normal 'global (kbd "<leader> d d") 'dired)
  (evil-define-key 'normal 'global (kbd "<leader> d j") 'dired-jump)
  (evil-define-key 'normal 'global (kbd "<leader> x f") 'find-file)

  (evil-define-key 'normal 'global (kbd "<leader> m s") 'magit-status)
  (evil-define-key 'normal 'global (kbd "<leader> m l") 'magit-log-current)
  (evil-define-key 'normal 'global (kbd "<leader> m d") 'magit-diff-buffer-file)
  (evil-define-key 'normal 'global (kbd "<leader> d D") 'diff-hl-show-hunk)
  (evil-define-key 'normal 'global (kbd "<leader> v a") 'vc-annotate)
  
  (evil-define-key 'normal 'global (kbd "<leader> s n") 'switch-to-next-buffer)
  (evil-define-key 'normal 'global (kbd "<leader> s p") 'switch-to-prev-buffer)
  (evil-define-key 'normal 'global (kbd "<leader> b k") 'kill-current-buffer)
  (evil-define-key 'normal 'global (kbd "<leader>SPC") 'consult-buffer)
  
  (evil-define-key 'normal 'global (kbd "<leader> D m") 'describe-mode)
  (evil-define-key 'normal 'global (kbd "<leader> D f") 'describe-function)
  (evil-define-key 'normal 'global (kbd "<leader> D v") 'describe-variable)
  (evil-define-key 'normal 'global (kbd "<leader> D k") 'describe-key)


  
  ;; my-journal-mode
  (evil-define-key 'normal 'global (kbd "<leader> j t") 'my-journal-open-today)

  

  (evil-define-key 'normal lsp-mode-map
    (kbd "gr") 'lsp-find-references
    (kbd "<leader> c a") 'lsp-execute-code-action
    (kbd "<leader> r n") 'lsp-rename
    (kbd "gI") 'lsp-find-implementation
    (kbd "<leader> l f") 'lsp-format-buffer)
  
  (defun ek/lsp-describe-and-jump ()
    "Show hover documentation and jump to *lsp-help* buffer."
    (interactive)
    (lsp-describe-thing-at-point)
    (let ((help-buffer "*lsp-help*"))
      (when (get-buffer help-buffer)
        (switch-to-buffer-other-window help-buffer))))
  
  (evil-define-key 'normal 'global (kbd "K")
   (if (>= emacs-major-version 31)
     #'eldoc-box-help-at-point
     #'ek/lsp-describe-and-jump))

  (evil-define-key 'normal 'global (kbd "gcc")
    (lambda ()
      (interactive)
      (if (not (use-region-p))
          (comment-or-uncomment-region (line-beginning-position) (line-end-position)))))

  (evil-define-key 'visual 'global (kbd "gc")
    (lambda ()
      (interactive)
      (if (use-region-p)
          (comment-or-uncomment-region (region-beginning) (region-end)))))

  (evil-define-key 'normal 'global (kbd "<leader>lf") #'load-config)

  (evil-mode 1))


(use-package evil-collection
  :custom
  (evil-collection-want-find-usages-bindings t)
  :hook
  (evil-mode . evil-collection-init))

(use-package evil-surround
  :after evil-collection
  :config
  (global-evil-surround-mode 1))

(use-package evil-matchit
  :after evil-collection
  :config
  (global-evil-matchit-mode 1))

;;TODO: не совсем работает как задуманно 
;; (defun my/format-region-or-buffer ()
;;   "Форматировать отступы и убрать лишние пустые строки."
;;   (interactive)
;;   (let ((start (if (use-region-p)
;;                    (region-beginning)
;;                  (point-min)))
;;         (end (if (use-region-p)
;;                  (region-end)
;;                (point-max))))
;; 
;;     (save-excursion
;;       (save-restriction
;;         (narrow-to-region start end)
;;         (indent-region (point-min) (point-max))
;;         (goto-char (point-min))
;;         (while (re-search-forward "\n[ \t]*\n\\([ \t]*\n\\)+" nil t)
;;           (replace-match "\n\n"))))))
;; 
;; (global-set-key (kbd "C-c f") #'my/format-region-or-buffer)

(use-package corfu
  :ensure t
  :defer t
  :custom
  (corfu-auto t)
  (corfu-auto-prefix 3)
  (corfu-quit-no-match nil)
  (corfu-scroll-margin 5)
  (corfu-max-width 50)
  (corfu-min-width 50)
  (corfu-popupinfo-delay 0.5)
  :config
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode t))

(use-package cape
  :ensure t
  :init
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-keyword)
  (add-hook 'completion-at-point-functions #'cape-elisp-symbol)
  (add-hook 'completion-at-point-functions #'cape-elisp-block)
  (add-hook 'completion-at-point-functions #'cape-abbrev)
  (add-hook 'completion-at-point-functions #'cape-dict)
  (add-hook 'completion-at-point-functions #'cape-history)
  :config
  (setq cape-dabbrev-min-length 3)
  (setq cape-dabbrev-ignore-case t)
  (setq cape-dabbrev-check-other-buffers t)
  (setq cape-dabbrev-buffer-lerit 20))

(use-package vertico
  :ensure t
  :hook
  (after-init . vertico-mode)
  :custom
  (vertico-count 10)
  (vertico-resize nil)
  (vertico-cycle nil)
  (vertico-preselect 'directory))

(use-package which-key
  :ensure nil
  :defer t
  :hook
  (after-init . which-key-mode))

(use-package lsp-mode
  :ensure t
  :commands lsp-deferred
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook
  ((js-ts-mode
     tsx-ts-mode
     typescript-ts-mode
     python-ts-mode
     c-ts-mode
     go-ts-mode
     rust-ts-mode
     web-mode)
    . lsp-deferred)
  :custom
  (lsp-completion-provider :capf)
  (lsp-diagnostics-provider :flymake)
  (lsp-idle-delay 0.5)
  (lsp-enable-snippet nil)
  (lsp-enable-file-watchers nil)
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-enable-on-type-formatting nil)
  (lsp-enable-imenu t)
  (lsp-log-io nil)
  (lsp-keep-workspace-alive nil)
  (lsp-semantic-tokens-enable nil)
  (lsp-enable-indentation nil)
  (lsp-auto-guess-root t)
  (lsp-restart 'auto-restart)
  (lsp-eldoc-enable-hover nil)
  :config
  (lsp-enable-which-key-integration))

(use-package lsp-ui
  :after lsp-mode
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  ;; Documentation popup
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-delay 0.2)
  (lsp-ui-doc-position 'at-point)
  (lsp-ui-doc-max-width 80)
  (lsp-ui-doc-max-height 20)
  (lsp-ui-doc-show-with-cursor t)
  (lsp-ui-doc-show-with-mouse nil)
  (lsp-ui-doc-use-childframe t)
  ;; Disable inline hints
  (lsp-ui-sideline-enable nil)
  ;; Peek window
  (lsp-ui-peek-enable t))

(use-package lsp-pyright
  :after lsp-mode
  :custom
  (lsp-pyright-langserver-command "basedpyright"))

(use-package flymake
  :ensure nil
  :hook
  (prog-mode . flymake-mode)
  :custom
  (flymake-no-changes-timeout 0.5)
  (flymake-show-diagnostics-at-end-of-line t)
  (flymake-margin-indicators-string
    '((error   "✘" flymake-error)
       (warning "▲" flymake-warning)
       (note    "●" flymake-note))))


(with-eval-after-load 'rust-ts-mode
  (add-hook 'rust-ts-mode-hook
            (lambda ()
              (setq-local flymake-diagnostic-functions
                          (remove #'rust-ts-flymake
                                  flymake-diagnostic-functions)))))

(use-package dap-mode
  :ensure t
  :after lsp-mode
  :bind (:map dap-mode-map
              ("<f5>" . dap-debug)
              ("<f6>" . dap-next)
              ("<f7>" . dap-step-in)
              ("<f8>" . dap-step-out)
              ("<f9>" . dap-breakpoint-toggle))
  :config
  (dap-auto-configure-mode))

(use-package gud
  :ensure nil
  :commands (gdb gud-gdb)
  :bind (:map gud-mode-map
              ("<f5>" . gud-cont)
              ("<f6>" . gud-next)
              ("<f7>" . gud-step)
              ("<f8>" . gud-finish)
              ("<f9>" . gud-break))
  :config
  (setq gdb-many-windows t
        gdb-show-main t))

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq display-buffer-alist
      '(
        ;; Debug / help buffers
        ("\\*\\(Backtrace\\|Warnings\\|Compile-Log\\|Help\\|Messages\\|Bookmark List\\|Ibuffer\\|Occur\\|eldoc.*\\)\\*"
         (display-buffer-in-side-window
          (side . bottom)
          (window-height . 0.25)
          (slot . 0)))

        ;; LSP / documentation buffers
        ("\\*lsp-help\\*"
         (display-buffer-in-side-window
          (side . bottom)
          (window-height . 0.25)
          (slot . 0)))

        ;; Diagnostics / xref / completion
        ("\\*\\(xref\\|flymake.*\\|completions.*\\)\\*"
         (display-buffer-in-side-window
          (side . bottom)
          (window-height . 0.25)
          (slot . 1)))))

(use-package recentf
  :ensure nil
  :init
  (recentf-mode 1)
  :custom
  (recentf-max-saved-items 100)
  (recentf-auto-cleanup 'never))

(use-package dashboard
  :ensure t
  :custom
  (dashboard-center-content t)
  (dashboard-items '((recents   . 5)
                      (projects  . 5)
                      (bookmarks . 5)
                      (registers . 5)
                      (agenda    . 5)))
  (dashboard-startup-banner 'official)
  (dashboard-set-init-info t)
  (dashboard-set-file-icons t)
  (dashboard-image-banner-max-width 300)
  (dashboard-set-footer t)

  :config
  (setq initial-buffer-choice #'dashboard-open)

  (dashboard-setup-startup-hook))

(use-package diff-hl
  :defer t
  :ensure t
  :hook
  (find-file . (lambda ()
                 (global-diff-hl-mode)
                 (diff-hl-flydiff-mode)
                 (diff-hl-margin-mode)))
  :custom
  (diff-hl-side 'left)
  (diff-hl-margin-symbols-alist '((insert . "┃")
                                   (delete . "-")
                                   (change . "┃")
                                   (unknown . "┆")
                                   (ignored . "i"))))

(use-package highlight-indent-guides
  :hook (prog-mode . highlight-indent-guides-mode)
  :custom
  (highlight-indent-guides-method 'character))

(use-package magit
  :ensure t)

(use-package smerge-mode
  :ensure nil
  :defer t
  :bind (:map smerge-mode-map
          ("C-c ^ u" . smerge-keep-upper)
          ("C-c ^ l" . smerge-keep-lower)
          ("C-c ^ n" . smerge-next)
          ("C-c ^ p" . smerge-previous)))

(use-package doom-modeline
  :ensure t
  :init
  (doom-modeline-mode 1)

  :custom
  (doom-modeline-height 60))

(defcustom ek-use-nerd-fonts t
  "Use Nerd Fonts icons."
  :type 'boolean
  :group 'appearance)

(use-package nerd-icons
  :if ek-use-nerd-fonts
  :ensure t)

(use-package nerd-icons-corfu
  :if ek-use-nerd-fonts
  :ensure t)

(use-package nerd-icons-dired
  :if ek-use-nerd-fonts
  :ensure t
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package nerd-icons-completion
  :if ek-use-nerd-fonts
  :ensure t
  :after marginalia
  :config
  (nerd-icons-completion-mode)

  (with-eval-after-load 'marginalia
    (nerd-icons-completion-marginalia-setup)))

(use-package rainbow-delimiters
  :ensure t

  :hook
  (prog-mode . rainbow-delimiters-mode)

  :custom
  (rainbow-delimiters-max-face-count 9))

(use-package ef-themes
  :ensure t
  :init
  (load-theme 'ef-dark t))

(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install t)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode t))

  ;; временный хак в будущем удалить его
  ;; честно тут я чуть не бросил emacs настолько это меня вымараживает
  (setq treesit-language-source-alist
    '((c   "https://github.com/tree-sitter/tree-sitter-c" "v0.23.2")
       (cpp "https://github.com/tree-sitter/tree-sitter-cpp" "v0.23.2")
       (css "https://github.com/tree-sitter/tree-sitter-css" "v0.23.2")
       (html "https://github.com/tree-sitter/tree-sitter-html" "v0.23.2")
       (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "v0.20.2")))

(use-package css-ts-mode
  :straight nil
  :ensure nil
  :mode "\\.css\\'"
  :hook
  (css-ts-mode . electric-pair-local-mode)
  (css-ts-mode . (lambda ()
    (setq-local tab-width 2
                css-indent-offset 2)))
  :config
  (add-to-list 'major-mode-remap-alist
  '(css-mode . css-ts-mode)))  


(use-package html-ts-mode
  :ensure nil
  :mode ("\\.html?\\'" . html-ts-mode)
  :custom
  (sgml-basic-offset 2)

  :hook
  (html-ts-mode . (lambda ()
    (setq-local tab-width 2)
    (electric-pair-local-mode 1)
    (display-line-numbers-mode 1))))

;;; TODO: REWRITE THIS SHIT
(defun my-js-mode-setup ()
  "Setq-local vars for 'js-mode'."
  (setq-local js-indent-level 2
    tab-width 2
    treesit-font-lock-level 4))

(use-package js
  :mode "\\.js\\'"
  :hook
  ((js-ts-mode . my-js-mode-setup)
  (js-ts-mode . electric-pair-local-mode)))

(use-package markdown-mode
   :ensure nil
   :defer t
   :mode ("\\.md\\'" . gfm-mode)
   :init
   (setq markdown-command "multimarkdown"
     fill-column 80)
   :hook
   (gfm-mode . auto-fill-mode))




(use-package rust-mode
  :ensure nil
  :mode "\\.rs\\'")

  (add-to-list 'exec-path (expand-file-name "~/.cargo/bin"))
  (setenv "PATH"
    (concat (expand-file-name "~/.cargo/bin") ":"
      (getenv "PATH")))

(use-package typescript-mode
  :init
  (add-to-list 'major-mode-remap-alist
    '(typescript-mode . typescript-ts-mode))
  (add-to-list 'major-mode-remap-alist
    '(js-mode . js-ts-mode)))

(use-package python
  :ensure nil
  :mode ("\\.py\\'" . python-ts-mode)
  :hook ((python-ts-mode . lsp-deferred)))

(require 'org)
(require 'ox-md)
   
(defvar my-journal-org-dir "~/orgjournal/")
(defvar my-journal-md-dir "~/NOTES/daily/") 

(defun my-journal-open-today ()
  "Open today's journal entry."
  (interactive)
  (make-directory my-journal-org-dir t)
  (make-directory my-journal-md-dir t)
  (find-file
   (expand-file-name
    (concat (format-time-string "%Y-%m-%d") ".org")
    my-journal-org-dir)))

(defun my-journal-export-on-save ()
  "Export journal entry to Markdown after saving."
  (when (and my-journal-mode buffer-file-name)
    (let ((org-export-with-toc nil)
          (org-export-with-author nil)
          (org-export-with-date nil))
      (org-export-to-file
          'md5
          (expand-file-name
           (concatenat (file-name-base buffer-file-name) ".md")
           my-journal-md-dir))))
  
  nil)

(define-minor-mode my-journal-mode
  "Minor mode for journal entries."
  :lighter " Journal"
  (if my-journal-mode
      (add-hook 'after-save-hook
                #'my-journal-export-on-save nil t)
    (remove-hook 'after-save-hook
                 #'my-journal-export-on-save t)))

(defun my-journal-enable-if-file ()
  "Enable journal mode for files in the journal directory."
  (when (and buffer-file-name
             (string-prefix-p
              (expand-file-name my-journal-org-dir)
              (expand-file-name buffer-file-name)))
    (my-journal-mode 1)))

(use-package org
  :ensure nil ;; all ready a part of emacs
  :configur
  (setq-local fill-column 80)
  (auto-fill-mode 1)
  (add-hook 'org-mode-hook #'my-journal-enable-if-file))

;; todo: add make-custom with arguments memory.
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

(defun my-c/make-custom (arguments)
  "Run make with custom ARGUMENTS in project root."
  (interactive "sMake arguments: ")
  (let ((default-directory (projectile-project-root)))
    (compile (concat "make " arguments))))

  (use-package c-ts-mode
    :ensure nil ;; all ready a part of emacs
    :mode
    ("\\.c\\'" . c-ts-mode)
    ("\\.h\\'" . c-or-c++-ts-mode)
    ("\\.cpp\\'" . c++-ts-mode)
    ("\\.hpp\\'" . c++-ts-mode)
    :bind
    (:map c-ts-mode-map ;; NOTE: на самом деле я не знаю как мне нужны комманды так что это сформеруется в будущем и всегда есть make-custom для этого 
          ("<f1>" . my-c/make-clean)
          ("<f2>" . my-c/make-all)
          ("<f3>" . my-c/make-run)
          ("<f4>" . my-c/make-custom))
    :config
    (c-ts-indent-offset 4)
    (c-ts-mode-indent-style 'linux)
    (c-ts-mode-enable-doxygen t)
    (eletric-pair-mode 1))

(use-package emacs-lisp-mode
  :ensure nil
  :hook
  ((emacs-lisp-mode . electric-pair-local-mode)
    (emacs-lisp-mode . show-paren-local-mode)
    (emacs-lisp-mode . eldoc-mode)
    (emacs-lisp-mode . prettify-symbols-mode))

  :bind
  (:map emacs-lisp-mode-map
      ("C-c C-e" . eval-last-sexp)
      ("C-c C-r" . eval-region)
      ("C-c C-b" . eval-buffer))

  :init
  (defun my/emacs-lisp-indent-setup ()
    "Configure indentation for Emacs Lisp."
    (setq-local indent-tabs-mode nil
              lisp-indent-offset 2))

  (defun my/emacs-lisp-format-buffer ()
    "Indent the whole Emacs Lisp buffer before saving."
    (when (derived-mode-p 'emacs-lisp-mode)
      (indent-region (point-min) (point-max))))

  :hook
  (emacs-lisp-mode . my/emacs-lisp-indent-setup)

  :config
  (add-hook 'before-save-hook
    #'my/emacs-lisp-format-buffer))

(use-package highlight-quoted
  :straight t 
  :hook
  ('emacs-lisp-mode-hook 'highlight-quoted-mode))
