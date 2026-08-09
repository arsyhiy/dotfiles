;;; black.el

(defun my-black-format ()
  "Format python file with black."
  (interactive)
  (shell-command-on-region
    (point-min)
    (point-max)
    "black -"
    t
    t))


(provide 'tools-black)
