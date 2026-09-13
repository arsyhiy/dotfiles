;;; core-ui-dashboard.el --- dashboard for emacs -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package dashboard
  :ensure t
  :init
  (setq dashboard-startup-banner 'official
        dashboard-center-content t
        dashboard-items '((recents  . 5)
                          (projects . 5)
                          (bookmarks . 5)))
  :config
  (dashboard-setup-startup-hook))

(provide 'core-ui-dashborad)
