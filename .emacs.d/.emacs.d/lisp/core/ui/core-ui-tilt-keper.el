(use-package tilt-keper
  :straight (:host github :repo "arsyhiy/tilt-keper")
  :demand t
  :custom
  (tilt-keper-mode 'growing)
  (tilt-keper-work-seconds (* 15 60))
  (tilt-keper-break-seconds (* 5 60))
  (tilt-keper-growth-seconds (* 5 60))
  (tilt-keper-auto-start t)
  (tilt-keper-ask-before-break t)
  (tilt-keper-show-mode-line t)
  (tilt-keper-break-frame nil)
  :config
  ;; Добавляем переменную tilt-keper--mode-line в global-mode-string
  (add-to-list 'global-mode-string '(" " tilt-keper--mode-line) t))

(provide 'core-ui-tilt-keper)
