;;; isearch-arsyhiy.el --- search system in Emacs -*- lexical-binding: t; -*-
;; Author: arsyhiy
;; Package-Requires: ((emacs "30.1"))

;;; Commentary:

;;; Code:

(with-eval-after-load 'isearch
  (setq isearch-lazy-count t
    lazy-count-prefix-format "(%s/%s) "
    lazy-count-suffix-format nil
    search-whitespace-regexp ".*?"))

(provide 'isearch-arsyhiy)
;;; isearch-arsyhiy.el ends here
