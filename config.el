;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Wentao Ding"
      user-mail-address "wtding1998@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; setting for GUI
;; (if (display-graphic-p)
;;     (progn
;;       (set-face-attribute
;;         'default nil
;;         ;; :font (font-spec :name "Fira Code"
;;         ;;                  :weight 'normal
;;         ;;                  :style 'Retina
;;         ;;                  :slant 'normal
;;         ;;                  :size 19.0))
;;         :font (font-spec :name "Source Code Pro"
;;                           :weight 'normal
;;                           :style 'Regular
;;                           :slant 'normal
;;                           :size 19.0))
;;         (dolist (charset '(kana han symbol cjk-misc bopomofo))
;;           (set-fontset-font
;;           (frame-parameter nil 'font)
;;           charset
;;           (font-spec :name "WenQuanYi Micro Hei Mono"
;;                       :weight 'normal
;;                       :slant 'normal)))
;;       (setq doom-theme 'doom-tomorrow-night))
;;   ;; setting  for emacs client
;;   (progn
;;     (setq doom-theme 'doom-tomorrow-night)
;;     (setq doom-font (font-spec :family "Source Code Pro" :size 25))
;;     (set-fontset-font t 'unicode (font-spec :family "WenQuanYi Micro Hei Mono" :weight 'normal :slant 'normal))

;;     ;; (dolist (charset '(kana han symbol cjk-misc bopomofo))
;;     ;;       (set-fontset-font
;;     ;;       (frame-parameter nil 'font)
;;     ;;       charset
;;     ;;       (font-spec :name "WenQuanYi Micro Hei Mono"
;;     ;;                   :weight 'normal
;;     ;;                   :slant 'normal)))
;;     )
;;   )
;; https://blog.csdn.net/xh_acmagic/article/details/78939246

;; load theme of DogLooksGood
(require 'joker-theme)
(require 'storybook-theme)
(require 'printed-theme)
(defun dwt/better-font()
;; english font
(if (display-graphic-p)
    (progn
        (setq doom-theme 'doom-flatwhite)
        ;; (setq doom-theme 'dichromacy)
        ;; (setq doom-theme 'doom-one-light)
        ;; (setq doom-theme 'doom-tomorrow-night)
        ;; (setq doom-theme 'storybook)
        ;; (set-face-attribute 'default nil :font (format   "%s:pixelsize=%d" "Source Code Pro" 25)) ;; 11 13 17 19 23
        ;; (set-face-attribute 'default nil :font (format   "%s:pixelsize=%d" "Fira Code" 27)) ;; 11 13 17 19 23
        (set-face-attribute 'default nil :font (format   "%s:pixelsize=%d" "SF Mono" 25)) ;; 11 13 17 19 23
        ;; (set-face-attribute 'default nil :font (format   "%s:pixelsize=%d" "Inconsolata" 27)) ;; 11 13 17 19 23
        ;; chinese font
        (dolist (charset '(kana han symbol cjk-misc bopomofo))
        (set-fontset-font (frame-parameter nil 'font)
                            charset
                            (font-spec :family "Source Han Serif CN")))) ;; 14 16 20 22 28
    ))

(defun dwt/init-font(frame)
(with-selected-frame frame
    (if (display-graphic-p)
        (dwt/better-font))))

(if (and (fboundp 'daemonp) (daemonp))
    (add-hook 'after-make-frame-functions #'dwt/init-font)
(dwt/better-font))

;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:

;; (setq themes-list (list 'doom-one 'doom-flatwhite))
;; (setq doom-theme (nth (random (length themes-list)) themes-list))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "/mnt/d/Onedrive/Documents/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;; maxmize frame when start
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; auto-save
(auto-save-visited-mode +1)
;; better default setting
(setq evil-want-fine-undo t)
;; (setq auto-save-default t)
;; set title bar
;; (setq-default frame-title-format '("DOOM-EMACS - " user-login-name "@" system-name " - %b"))
(setq-default frame-title-format '("DOOM-EMACS - " user-login-name " - %b"))
;; display time modeline
(setq display-time-day-and-date t)
(setq display-time-24hr-format t)
(display-time-mode 1)
;; display battery in modeline
(display-battery-mode 1)
