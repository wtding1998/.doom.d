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
          '("知而不行，未知之矣。"
            "大道甚夷，而人好径。"
            "胜人者有力，自胜者强。"
            "上士闻道，勤而行之。中士闻道，若存若亡。下士闻道，大笑之，不笑不足以为道。"))
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

;; (unless (display-graphic-p) ; for some reason this messes up the graphical splash screen atm
;;   (setq +doom-dashboard-ascii-banner-fn #'doom-dashboard-draw-ascii-emacs-banner-fn))

;; (setq +doom-dashboard-ascii-banner-fn #'doom-dashboard-draw-ascii-emacs-banner-fn)
;; disable global-hl-line
;; (remove-hook 'doom-first-buffer-hook #'global-hl-line-mode)

(defvar dwt/dark-themes '(doom-material
                          doom-oceanic-next
                          doom-nova
                          doom-spacegrey
                          doom-opera
                          doom-miramare
                          joker
                          doom-nord
                          doom-horizon
                          doom-monokai-pro
                          doom-monokai-octagon
                          doom-tomorrow-night
                          doom-one))

(defvar dwt/light-themes '(
                           ;; storybook
                           ;; doom-tomorrow-day
                           doom-homage-white
                           doom-opera-light
                           doom-tomorrow-day
                           modus-operandi))
                           ;; doom-one-light
                           ;; doom-flatwhite))
(defun dwt/random-load-light-theme ()
  "Load light theme."
  (interactive)
  (load-theme (nth (random (length dwt/light-themes)) dwt/light-themes) t nil))

(defun dwt/random-load-theme ()
  "Load theme randomly from dwt/dark-themes."
  (interactive)
  (load-theme (nth (random (length dwt/dark-themes)) dwt/dark-themes) t nil))

;;; font
(defvar dwt/fontsize 16)
(when dwt/lenovo
  (setq dwt/fontsize 26))
;; (setq doom-font (font-spec :family "SF Mono" :size 24 :weight 'semi-light))
(setq doom-font (font-spec :family "Fira Code" :size dwt/fontsize :weight 'semi-light))
(setq doom-unicode-font (font-spec :family "Source Han Serif CN"))

;;; frame init
(add-to-list 'default-frame-alist '(fullscreen . maximized))
;; full screen
;; (add-to-list 'default-frame-alist '(fullscreen . fullboth))

;;; theme
;; (if (display-graphic-p)
;;     (setq doom-theme (nth (random (length dwt/light-themes)) dwt/light-themes))
;;     (setq doom-theme 'kaolin-mono-dark))
(setq doom-theme (nth (random (length dwt/light-themes)) dwt/light-themes))

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
  (map! "C-1" #'awesome-tab-select-visible-tab)
  (map! "C-2" #'awesome-tab-select-visible-tab)
  (map! "C-3" #'awesome-tab-select-visible-tab)
  (map! "C-4" #'awesome-tab-select-visible-tab)
  (map! "C-5" #'awesome-tab-select-visible-tab)
  (map! "C-6" #'awesome-tab-select-visible-tab)
  (map! "C-7" #'awesome-tab-select-visible-tab)
  (map! "C-8" #'awesome-tab-select-visible-tab)
  (map! "C-9" #'awesome-tab-select-visible-tab)

  (define-key global-map (kbd "M-o") #'other-window)
  ;; height
  (setq awesome-tab-height 100
        awesome-tab-active-bar-height 20)
  (when dwt/lenovo
    (setq awesome-tab-height 180))

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

;;; word wrap

(unless (display-graphic-p)
  (evil-terminal-cursor-changer-activate))
