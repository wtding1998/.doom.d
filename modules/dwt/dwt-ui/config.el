;;; dwt/dwt-ui/config.el -*- lexical-binding: t; -*-

;;;banner
;; copied from https://github.com/cnsunyour/.doom.d/blob/dfbeb081d2cc3aaafc0e591868a9a4ba1f276f77/modules/cnsunyour/ui/config.el
;; (when (display-graphic-p)
;;   (defun cnsunyour/set-splash-image ()
;;     "Set random splash image."
;;     (setq fancy-splash-image
;;           (let ((banners (directory-files "~/.doom.d/banner"
;;                                           'full
;;                                           (rx ".png" eos))))
;;             (elt banners (random (length banners))))))
;;   ;; Set splash image when theme changed.
;;
;; see banner configurration https://tecosaur.github.io/emacs-config/config.html
;;   (add-hook 'doom-load-theme-hook #'cnsunyour/set-splash-image))
;;
(defun doom-dashboard-draw-ascii-emacs-banner-fn ()
  (let* ((banner
          ;; '(",---.,-.-.,---.,---.,---."
          ;;   "|---'| | |,---||    `---."
          ;;   "`---'` ' '`---^`---'`---'"))
          '("所谓诚其意者：毋自欺也，如恶恶臭，如好好色，此之谓自谦，故君子必慎其独也。"))
          ;; '("苟日新"
          ;;   "日日新"
          ;;   "又日新"))
         (longest-line (apply #'max (mapcar #'length banner))))
    (put-text-property
     (point)
     (dolist (line banner (point))
       (insert (+doom-dashboard--center
                +doom-dashboard--width
                (concat
                 line (make-string (max 0 (- longest-line (length line)))
                                   32)))
               "\n"))
     'face 'doom-dashboard-banner)))

(unless (display-graphic-p) ; for some reason this messes up the graphical splash screen atm
  (setq +doom-dashboard-ascii-banner-fn #'doom-dashboard-draw-ascii-emacs-banner-fn))
(setq +doom-dashboard-ascii-banner-fn #'doom-dashboard-draw-ascii-emacs-banner-fn)

;; disable global-hl-line
;; (remove-hook 'doom-first-buffer-hook #'global-hl-line-mode)

(defvar dwt/dark-themes '(doom-material
                          doom-oceanic-next
                          doom-nova
                          doom-spacegrey
                          doom-opera
                          doom-miramare
                          doom-nord
                          doom-horizon
                          doom-monokai-pro
                          doom-monokai-octagon
                          doom-tomorrow-nigh))

(defvar dwt/light-themes '(
                           ;; doom-tomorrow-day
                           doom-homage-white
                           ;;printed
                           doom-plain
                           ;; doom-opera-light
                           ;; doom-tomorrow-day
                           modus-operandi))
(defun dwt/random-load-light-theme ()
  "Load light theme."
  (interactive)
  (load-theme (nth (random (length dwt/light-themes)) dwt/light-themes) t nil))

(defun dwt/random-load-dark-theme ()
  "Load theme randomly from dwt/dark-themes."
  (interactive)
  (load-theme (nth (random (length dwt/dark-themes)) dwt/dark-themes) t nil))

;;; font
;;       doom-unicode-font (font-spec :family "Source Han Serif CN"))
(defun dwt/doom-font()
  ;; english font
  (if (display-graphic-p)
      (progn
        (setq dwt/fontsize 16)
        (when dwt/lenovo
          (setq dwt/fontsize 26))
        ;; (set-face-attribute 'default nil :font (format "%s:pixelsize=%d" "SF Mono:style=Light" dwt/fontsize)) ;; 11 13 17 19 23
        (set-face-attribute 'default nil :font (format "%s:pixelsize=%d" "SF Mono" dwt/fontsize) :weight 'Regular) ;; 11 13 17 19 23
        ;; (set-face-attribute 'default nil :font (format "%s:pixelsize=%d" "Sarasa Mono SC Nerd" (+ dwt/fontsize 2))) ;; 11 13 17 19 23
        ;; (setq doom-font (font-spec :family "Sarasa Mono SC Nerd" :size dwt/fontsize :weight 'Medium))
        ;; chinese font
        ;; (set-fontset-font t 'unicode "Noto Color Emoji" nil 'prepend)
        (set-fontset-font t 'unicode "Symbola" nil 'prepend)
        (dolist (charset '(kana han symbol cjk-misc bopomofo))
          (set-fontset-font (frame-parameter nil 'font)
                            charset
                            (font-spec :family "Source Han Serif CN")))))) ;; 14 16 20 22 28
                            ;; (font-spec :family "Sarasa Mono SC Nerd")))))) ;; 14 16 20 22 28
(defun dwt/init-font(frame)
  (with-selected-frame frame
    (if (display-graphic-p)
        (dwt/doom-font))))

(if IS-MAC
    (setq doom-font (font-spec :family "SF Mono" :size 14 :weight 'Regular))
    (if (and (fboundp 'daemonp) (daemonp))
      (add-hook 'after-make-frame-functions #'dwt/init-font))
    (dwt/doom-font))

;; 隐藏 title bar
;; (setq default-frame-alist '((undecorated . t)))
;; (add-to-list 'default-frame-alist '(drag-internal-border . 1))
;; (add-to-list 'default-frame-alist '(internal-border-width . 5))

;;; frame init
(add-to-list 'default-frame-alist '(fullscreen . maximized))
;; full screen
;; (add-to-list 'default-frame-alist '(fullscreen . fullboth))
(map! :leader :desc "Max Frame" "tm" #'toggle-frame-maximized)

;;; theme
(dwt/random-load-light-theme)
;; (if (display-graphic-p)
;;     (setq doom-theme (nth (random (length dwt/light-themes)) dwt/light-themes))
;;     (setq doom-theme 'kaolin-mono-dark))
;; (setq doom-theme (nth (random (length dwt/light-themes)) dwt/light-themes))
(dwt/random-load-light-theme)

(use-package! diff-hl
  :config
  (map! :n "[g" #'diff-hl-previous-hunk)
  (map! :n "]g" #'diff-hl-next-hunk)
  (diff-hl-margin-mode -1)
  :hook
  (prog-mode . diff-hl-mode)
  (prog-mode . diff-hl-flydiff-mode))

(use-package! kaolin-themes
 :load-path "~/.emacs.d/.local/straight/repos/emacs-kaolin-themes")

(use-package! printed-theme
  :load-path "~/.emacs.d/.local/straight/repos/printed-theme")

(use-package! joker-theme
  :load-path "~/.emacs.d/.local/straight/repos/joker-theme")

(use-package! storybook-theme
  :load-path "~/.emacs.d/.local/straight/repos/storybook-theme")

(use-package! awesome-tab
  :config
  (evil-define-key 'normal 'global "gt" #'awesome-tab-forward-tab)
  (evil-define-key 'normal 'global "gT" #'awesome-tab-backward-tab)
  (evil-define-key 'normal 'global "]t" #'awesome-tab-forward-group)
  (evil-define-key 'normal 'global "[t" #'awesome-tab-backward-group)
  (evil-define-key 'normal 'global (kbd"<leader>tt") #'awesome-tab-counsel-switch-group)
  (evil-define-key 'normal 'global (kbd"<leader>t1") #'awesome-tab-kill-other-buffers-in-current-group)
  (evil-define-key 'normal 'global (kbd"<leader>t0") #'awesome-tab-kill-all-buffers-in-current-group)
  (evil-define-key 'normal 'global (kbd"<leader>tn") #'awesome-tab-forward-tab)
  (evil-define-key 'normal 'global (kbd"<leader>tp") #'awesome-tab-backward-tab)
  (map! :ni "C-1" #'awesome-tab-select-visible-tab)
  (map! :ni "C-2" #'awesome-tab-select-visible-tab)
  (map! :ni "C-3" #'awesome-tab-select-visible-tab)
  (map! :ni "C-4" #'awesome-tab-select-visible-tab)
  (map! :ni "C-5" #'awesome-tab-select-visible-tab)
  (map! :ni "C-6" #'awesome-tab-select-visible-tab)
  (map! :ni "C-7" #'awesome-tab-select-visible-tab)
  (map! :ni "C-8" #'awesome-tab-select-visible-tab)
  (map! :ni "C-9" #'awesome-tab-select-visible-tab)
  (map! :ni "C-<tab>" #'awesome-tab-forward-tab)
  (map! :ni "C-<iso-lefttab>" #'awesome-tab-backward-tab)

  (define-key global-map (kbd "M-o") #'other-window)
  ;; height
  (if (not IS-MAC)
      (progn
        (setq awesome-tab-height 100
              awesome-tab-active-bar-height 20)
        (when dwt/lenovo
          (setq awesome-tab-height 180)))
      (setq awesome-tab-height 120
            awesome-tab-active-bar-height 20))

  ;; define tab-hide-rule
  (defun awesome-tab-hide-tab (x)
    (let ((name (format "%s" x)))
      (or
       (string-prefix-p "*epc" name)
       ;; (string-prefix-p "*" name)
       (string-prefix-p "*helm" name)
       (string-prefix-p "*Compile-Log*" name)
       (string-prefix-p "*lsp" name)
       (string-prefix-p "*org-latex" name)
       (string-prefix-p " *rime-posframe" name)
       (and (string-prefix-p "magit" name)
            (not (file-name-extension name))))))

  (awesome-tab-mode t))

;;; title bar
;; (setq-default frame-title-format '("DOOM-EMACS - " user-login-name "@" system-name " - %b"))
;; (setq-default frame-title-format '("Emacs - " user-login-name " - %b"))
(setq-default frame-title-format '("Emacs - %b"))

;;; +modeline, light line in doom
(setq +modeline-height 15)
;; display time modeline
(setq display-time-day-and-date t)
(setq display-time-24hr-format t)
(display-time-mode 1)
;; display battery in modeline
(display-battery-mode 1)

(unless (display-graphic-p)
  (evil-terminal-cursor-changer-activate))
