;;; core-ui-indent-guide.el --- Show vertical lines to guide indentation -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(use-package highlight-indent-guides
  :hook (prog-mode . highlight-indent-guides-mode)
  :custom
  (highlight-indent-guides-method 'character))

(provide 'core-ui-indent-guide)
;;; core-ui-indent-guide.el ends here
