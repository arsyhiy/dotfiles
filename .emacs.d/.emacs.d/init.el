(require 'org)

(org-babel-load-file
 (expand-file-name "config.org" user-emacs-directory))

(defun reload-config ()
  (interactive)
  (org-babel-load-file
   (expand-file-name "config.org" user-emacs-directory)))
