;;; core-ui-modeline.el --- doom modeline configuration -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)

  :config
  (doom-modeline-height 40)

  )

(provide 'core-ui-modeline)
;;; core-ui-modeline.el ends here

