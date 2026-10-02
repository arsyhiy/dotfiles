;;; core-ui-dashboard.el --- Dashboard for Emacs -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

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


(provide 'core-ui-dashboard)
;;; core-ui-dashboard.el ends here
