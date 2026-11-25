;;; caloriemate-theme.el --- color scheme from CalorieMate bar packaging -*- lexical-binding: t; -*-
;; Author: arsyhiy

;;; Commentary:
;; A light theme built from the CalorieMate (Otsuka) diet-bar packaging:
;; the bright yellow box, the blue logo text, and the cream biscuit bar.
;; Flavor-box accents fill out the palette: fruit red, vegetable green,
;; chocolate brown. Load with (load-theme 'caloriemate).

;;; Code:

(deftheme caloriemate
  "Light theme drawn from CalorieMate diet-bar packaging colors.")

(let ((class '((class color) (min-colors 89)))
      ;; Biscuit / cream backgrounds -----------------------------------;;
      (bg-main   "#FBF3DC")   ; cream biscuit
      (bg-dim    "#F3E7C4")   ; toasted biscuit
      (bg-alt    "#ECDCB2")   ; region / selection
      (bg-hl     "#F6ECCB")   ; hl-line
      (bg-box    "#F6C500")   ; the yellow box itself

      ;; Biscuit / navy foregrounds ------------------------------------;;
      (fg-main   "#2A2416")   ; roasted text
      (fg-dim    "#6B5E3E")
      (fg-fade   "#9A8A5E")   ; comments

      ;; Brand + flavor-box accents ------------------------------------;;
      (blue      "#00529B")   ; CalorieMate logo blue
      (navy      "#073763")
      (yellow    "#B88700")   ; deep box yellow (readable on cream)
      (amber     "#D97A1A")   ; maple / cheese
      (brown     "#7A4E24")   ; chocolate flavor
      (red       "#C0392B")   ; fruit flavor
      (green     "#4E8B3B")   ; vegetable flavor
      (magenta   "#B03A6E")   ; fruit flavor
      (cyan      "#1F7A8C")

      ;; Diagnostics ----------------------------------------------------;;
      (err       "#C0392B")
      (warn      "#B88700")
      (note      "#1F7A8C"))

  (custom-theme-set-faces
   'caloriemate

   ;; Base -----------------------------------------------------------;;
   `(default           ((,class (:background ,bg-main :foreground ,fg-main))))
   `(cursor            ((,class (:background ,blue))))
   `(region            ((,class (:background ,bg-alt))))
   `(highlight         ((,class (:background ,bg-box :foreground ,fg-main))))
   `(hl-line           ((,class (:background ,bg-hl))))
   `(fringe            ((,class (:background ,bg-main :foreground ,fg-fade))))
   `(vertical-border   ((,class (:foreground ,bg-alt))))
   `(window-divider    ((,class (:foreground ,bg-alt))))
   `(window-divider-first-pixel ((,class (:foreground ,bg-alt))))
   `(window-divider-last-pixel  ((,class (:foreground ,bg-alt))))
   `(minibuffer-prompt ((,class (:foreground ,blue :weight bold))))
   `(shadow            ((,class (:foreground ,fg-fade))))
   `(link              ((,class (:foreground ,blue :underline t))))
   `(link-visited      ((,class (:foreground ,magenta :underline t))))
   `(error             ((,class (:foreground ,err :weight bold))))
   `(warning           ((,class (:foreground ,warn :weight bold))))
   `(success           ((,class (:foreground ,green :weight bold))))
   `(secondary-selection ((,class (:background ,bg-dim))))
   `(trailing-whitespace ((,class (:background ,red))))

   ;; Font lock ------------------------------------------------------;;
   `(font-lock-keyword-face       ((,class (:foreground ,blue :weight bold))))
   `(font-lock-function-name-face ((,class (:foreground ,navy :weight bold))))
   `(font-lock-variable-name-face ((,class (:foreground ,brown))))
   `(font-lock-string-face        ((,class (:foreground ,green))))
   `(font-lock-doc-face           ((,class (:foreground ,fg-fade :slant italic))))
   `(font-lock-comment-face       ((,class (:foreground ,fg-fade :slant italic))))
   `(font-lock-comment-delimiter-face ((,class (:foreground ,fg-fade :slant italic))))
   `(font-lock-constant-face      ((,class (:foreground ,amber))))
   `(font-lock-type-face          ((,class (:foreground ,yellow :weight bold))))
   `(font-lock-builtin-face       ((,class (:foreground ,cyan))))
   `(font-lock-preprocessor-face  ((,class (:foreground ,magenta))))
   `(font-lock-negation-char-face ((,class (:foreground ,red))))
   `(font-lock-warning-face       ((,class (:foreground ,red :weight bold))))

   ;; Mode line ------------------------------------------------------;;
   `(mode-line          ((,class (:background ,bg-box :foreground ,navy :box (:line-width 1 :color ,yellow)))))
   `(mode-line-inactive ((,class (:background ,bg-dim :foreground ,fg-fade :box (:line-width 1 :color ,bg-alt)))))
   `(mode-line-emphasis ((,class (:foreground ,blue :weight bold))))
   `(mode-line-highlight ((,class (:background ,amber :foreground ,bg-main))))

   ;; Line numbers ---------------------------------------------------;;
   `(line-number              ((,class (:background ,bg-main :foreground ,fg-fade))))
   `(line-number-current-line ((,class (:background ,bg-hl :foreground ,blue :weight bold))))

   ;; Parens / matching ---------------------------------------------;;
   `(show-paren-match    ((,class (:background ,bg-box :foreground ,navy :weight bold))))
   `(show-paren-mismatch ((,class (:background ,red :foreground ,bg-main :weight bold))))

   ;; Search ---------------------------------------------------------;;
   `(isearch        ((,class (:background ,bg-box :foreground ,navy :weight bold))))
   `(lazy-highlight ((,class (:background ,bg-alt :foreground ,fg-main))))
   `(match          ((,class (:background ,bg-box :foreground ,navy))))

   ;; Completion (vertico / corfu / orderless) ----------------------;;
   `(completions-common-part      ((,class (:foreground ,blue :weight bold))))
   `(completions-first-difference ((,class (:foreground ,red))))
   `(vertico-current  ((,class (:background ,bg-alt :weight bold :extend t))))
   `(corfu-default    ((,class (:background ,bg-dim :foreground ,fg-main))))
   `(corfu-current    ((,class (:background ,bg-box :foreground ,navy))))
   `(corfu-border     ((,class (:background ,yellow))))
   `(orderless-match-face-0 ((,class (:foreground ,blue :weight bold))))
   `(orderless-match-face-1 ((,class (:foreground ,magenta :weight bold))))
   `(orderless-match-face-2 ((,class (:foreground ,green :weight bold))))
   `(orderless-match-face-3 ((,class (:foreground ,amber :weight bold))))
   `(marginalia-documentation ((,class (:foreground ,fg-fade :slant italic))))

   ;; Diagnostics (flymake) -----------------------------------------;;
   `(flymake-error   ((,class (:underline (:style wave :color ,err)))))
   `(flymake-warning ((,class (:underline (:style wave :color ,warn)))))
   `(flymake-note    ((,class (:underline (:style wave :color ,note)))))

   ;; Diff / VC (diff-hl, magit) ------------------------------------;;
   `(diff-hl-insert ((,class (:background ,green :foreground ,green))))
   `(diff-hl-delete ((,class (:background ,red :foreground ,red))))
   `(diff-hl-change ((,class (:background ,blue :foreground ,blue))))
   `(diff-added     ((,class (:background ,bg-dim :foreground ,green))))
   `(diff-removed   ((,class (:background ,bg-dim :foreground ,red))))
   `(magit-section-heading ((,class (:foreground ,blue :weight bold))))
   `(magit-branch-local    ((,class (:foreground ,cyan :weight bold))))
   `(magit-branch-remote   ((,class (:foreground ,green :weight bold))))
   `(magit-diff-added      ((,class (:background ,bg-dim :foreground ,green))))
   `(magit-diff-removed    ((,class (:background ,bg-dim :foreground ,red))))

   ;; Org ------------------------------------------------------------;;
   `(org-level-1   ((,class (:foreground ,blue   :weight bold :height 1.3))))
   `(org-level-2   ((,class (:foreground ,amber  :weight bold :height 1.2))))
   `(org-level-3   ((,class (:foreground ,green  :weight bold :height 1.1))))
   `(org-level-4   ((,class (:foreground ,magenta :weight bold))))
   `(org-level-5   ((,class (:foreground ,cyan   :weight bold))))
   `(org-block     ((,class (:background ,bg-dim :extend t))))
   `(org-block-begin-line ((,class (:background ,bg-alt :foreground ,fg-fade :extend t))))
   `(org-code      ((,class (:foreground ,brown))))
   `(org-verbatim  ((,class (:foreground ,green))))
   `(org-link      ((,class (:foreground ,blue :underline t))))
   `(org-todo      ((,class (:foreground ,red :weight bold))))
   `(org-done      ((,class (:foreground ,green :weight bold))))
   `(org-table     ((,class (:foreground ,navy))))
   `(org-date      ((,class (:foreground ,cyan :underline t))))

   ;; Rainbow delimiters ---------------------------------------------;;
   `(rainbow-delimiters-depth-1-face ((,class (:foreground ,blue))))
   `(rainbow-delimiters-depth-2-face ((,class (:foreground ,amber))))
   `(rainbow-delimiters-depth-3-face ((,class (:foreground ,green))))
   `(rainbow-delimiters-depth-4-face ((,class (:foreground ,magenta))))
   `(rainbow-delimiters-depth-5-face ((,class (:foreground ,cyan))))
   `(rainbow-delimiters-depth-6-face ((,class (:foreground ,brown))))
   `(rainbow-delimiters-depth-7-face ((,class (:foreground ,yellow))))
   `(rainbow-delimiters-depth-8-face ((,class (:foreground ,navy))))
   `(rainbow-delimiters-depth-9-face ((,class (:foreground ,red))))
   `(rainbow-delimiters-unmatched-face ((,class (:foreground ,red :weight bold))))

   ;; Tab / header line ----------------------------------------------;;
   `(header-line ((,class (:background ,bg-box :foreground ,navy))))
   `(tab-bar     ((,class (:background ,bg-dim :foreground ,fg-main))))
   `(tab-bar-tab ((,class (:background ,bg-box :foreground ,navy :weight bold))))
   `(tab-bar-tab-inactive ((,class (:background ,bg-dim :foreground ,fg-fade)))))

  (custom-theme-set-variables
   'caloriemate
   `(ansi-color-names-vector
     [,fg-main ,red ,green ,yellow ,blue ,magenta ,cyan ,bg-main])))

(provide-theme 'caloriemate)

;;; caloriemate-theme.el ends here
