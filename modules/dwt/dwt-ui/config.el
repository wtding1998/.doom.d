;;; dwt/dwt-ui/config.el -*- lexical-binding: t; -*-

;;;banner
;;; copied from https://github.com/cnsunyour/.doom.d/blob/dfbeb081d2cc3aaafc0e591868a9a4ba1f276f77/modules/cnsunyour/ui/config.el
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
            "大道甚夷，而人好径。胜人者有力，自胜者强."
            "上士闻道，勤而行之。中士闻道，若存若亡。下士闻道，大笑之，不笑不足以为道。"))

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

(setq +doom-dashboard-ascii-banner-fn #'doom-dashboard-draw-ascii-emacs-banner-fn)
;; disable global-hl-line
(remove-hook 'doom-first-buffer-hook #'global-hl-line-mode)

(defvar dwt/themes '(doom-material
                     doom-oceanic-next
                     doom-nova
                     doom-spacegrey
                     doom-opera
                     ;; doom-fairy-floss
                     doom-dracula
                     doom-vibrant
                     doom-rouge
                     doom-sourcerer
                     doom-miramare
                     doom-one-light
                     doom-nord-light
                     doom-nord
                     doom-tomorrow-day
                     doom-wilmersdorf
                     doom-moonlight
                     doom-horizon
                     doom-monokai-pro
                     doom-tomorrow-night
                     doom-one
                     doom-flatwhite))

(defvar dwt/light-themes '(storybook
                           doom-tomorrow-day
                           modus-operandi
                           doom-one-light
                           doom-flatwhite))
(defun dwt/random-load-light-theme ()
  "Load light theme."
  (interactive)
  (load-theme (nth (random (length dwt/themes)) dwt/light-themes)) t nil)

(defun dwt/random-load-theme ()
  "Load theme randomly from dwt/themes."
  (interactive)
  (load-theme (nth (random (length dwt/themes)) dwt/themes)) t nil)

(defun dwt/better-font()
  ;; english font
  (if (display-graphic-p)
      (progn
        ;; (setq doom-theme (nth (random (length dwt/themes)) dwt/themes))
        ;; (setq doom-theme (nth (random (length dwt/light-themes)) dwt/light-themes))
        (setq doom-theme 'modus-operandi)
        ;; (setq doom-theme 'tao-yang)
        ;; (setq doom-theme 'doom-tomorrow-day)
        ;; (setq doom-theme nil)
        ;; (setq doom-theme 'doom-one-light)
        ;; (set-face-attribute 'default nil :font (format   "%s:pixelsize=%d" "Source Code Pro" 25)) ;; 11 13 17 19 23
        ;; (set-face-attribute 'default nil :font (format   "%s:pixelsize=%d" "Fira Code" 26)) ;; 11 13 17 19 23
        (set-face-attribute 'default nil :font (format   "%s:pixelsize=%d" "SF Mono" 26)) ;; 11 13 17 19 23
        ;; (set-face-attribute 'default nil :font (format   "%s:pixelsize=%d" "Inconsolata" 29)) ;; 11 13 17 19 23
        ;; chinese font
        (set-fontset-font t 'unicode "Noto Color Emoji" nil 'prepend)
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

(unless (display-graphic-p)
  (setq doom-theme 'kaolin-mono-dark))
(map! :n "[t" #'centaur-tabs-forward-group
      :n "]t" #'centaur-tabs-backward-group)

(use-package! diff-hl
  :config
  (map! :n "[g" #'diff-hl-previous-hunk)
  (map! :n "]g" #'diff-hl-next-hunk)
  (diff-hl-margin-mode -1)
  :hook
  (prog-mode . global-diff-hl-mode)
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

  (define-key global-map (kbd "M-o") #'other-window)
  ;; define tab-hide-rule
  (setq awesome-tab-height 190)
  (defun awesome-tab-hide-tab (x)
    (let ((name (format "%s" x)))
      (or
       (string-prefix-p "*epc" name)
       (string-prefix-p "*" name)
       (string-prefix-p "*helm" name)
       (string-prefix-p "*Compile-Log*" name)
       (string-prefix-p "*lsp" name)
       (string-prefix-p "*org-latex" name)
       (string-prefix-p " *rime-posframe" name)
       (and (string-prefix-p "magit" name)
            (not (file-name-extension name))))))

  (awesome-tab-mode t))

(unless (display-graphic-p)
  (evil-terminal-cursor-changer-activate))
