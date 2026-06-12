;;; indent-guide-arsyhiy.el --- Show vertical lines to guide indentation -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package indent-guide
  :defer t
  :ensure t
  :hook
  (prog-mode . indent-guide-mode)
  :config
  (setq indent-guide-char "│"))

(provide 'indent-guide-arsyhiy)
;;; indent-guide-arsyhiy.el ends here
