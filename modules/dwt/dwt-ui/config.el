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

;; (unless (display-graphic-p) ; for some reason this messes up the graphical splash screen atm
;;   (setq +doom-dashboard-ascii-banner-fn #'doom-dashboard-draw-ascii-emacs-banner-fn))
;; (setq +doom-dashboard-ascii-banner-fn #'doom-dashboard-draw-ascii-emacs-banner-fn)

;; disable global-hl-line
;; (remove-hook 'doom-first-buffer-hook #'global-hl-line-mode)

;; load theme in advance

(use-package! printed-theme
  :load-path "~/.emacs.d/.local/straight/repos/printed-theme")

(use-package! joker-theme
  :load-path "~/.emacs.d/.local/straight/repos/joker-theme")

(use-package! storybook-theme
  :load-path "~/.emacs.d/.local/straight/repos/storybook-theme")

(defvar dwt/dark-themes '(doom-material
                          doom-oceanic-next
                          doom-nova
                          doom-spacegrey
                          doom-opera
                          doom-miramare
                          gruvbox
                          doom-nord
                          doom-horizon
                          doom-monokai-pro
                          doom-monokai-octagon
                          doom-tomorrow-nigh))

(defvar dwt/light-themes '(doom-homage-white
                           notink
                           modus-operandi))

(defun dwt/load-light-themes ()
  "Load light theme."
  (interactive)
  (load-theme (nth (random (length dwt/light-themes)) dwt/light-themes) t nil))


(defun dwt/load-dark-themes ()
  "Load theme randomly from dwt/dark-themes."
  (interactive)
  (load-theme (nth (random (length dwt/dark-themes)) dwt/light-themes) t nil))


;;; font
(defun dwt/doom-font()
    ;; (setq doom-font (font-spec :family "SF Mono" :size 14 :weight 'Regular))
    (setq dwt/fontsize 16)
    (when dwt/lenovo
      (setq dwt/fontsize 26))
    (when IS-MAC
      (setq dwt/fontsize 15))
    ;;(set-face-attribute 'default nil :font (format "%s:pixelsize=%d" "SF Mono" dwt/fontsize) :weight 'Regular) ;; 11 13 17 19 23
    ;; (set-face-attribute 'default nil :font (format "%s:pixelsize=%d" "Ubuntu Mono" dwt/fontsize) :weight 'Regular) ;; 11 13 17 19 23
    (set-face-attribute 'default nil :font (format "%s:pixelsize=%d" "Sarasa Mono SC Nerd" (+ dwt/fontsize 2))) ;; 11 13 17 19 23
    ;; (setq doom-font (font-spec :family "Sarasa Mono SC Nerd" :size dwt/fontsize :weight 'Medium))
    ;; chinese font
    ;; (set-fontset-font t 'unicode "Noto Color Emoji" nil 'prepend)
    (set-fontset-font t 'unicode "Symbola" nil 'prepend)
    (dolist (charset '(kana han symbol cjk-misc bopomofo))
      (set-fontset-font (frame-parameter nil 'font)
                        charset
                        ;; (font-spec :family "Source Han Serif CN"))))) ;; 14 16 20 22 28
                        (font-spec :family "Sarasa Mono SC Nerd")))) ;; 14 16 20 22 28

(defun dwt/init-frame(frame)
  (with-selected-frame frame
    ;; font and theme for GUI
    (if (display-graphic-p)
        (progn
          (dwt/doom-font)
          ;; theme for GUI in daemon
          ;; (dwt/load-light-themes)
          ;; (load-theme 'modus-operandi t nil)
          (load-theme 'notink t nil)
          (when IS-MAC
            (dwt/turn-on-transwin)))
      ;;; theme for TUI in daemon
      (load-theme 'doom-tomorrow-night t nil))))

(if (and (fboundp 'daemonp) (daemonp))
  (add-hook 'after-make-frame-functions #'dwt/init-frame)
  (if (display-graphic-p)
      ;; font and theme for GUI in single emacs
      (progn
        (dwt/load-light-themes)
        (dwt/doom-font))
    ;; theme for TUI in single emacs
    (load-theme 'doom-tomorrow-night t nil)))

;; hide title bar
;; (setq default-frame-alist '((undecorated . t)))
;; (add-to-list 'default-frame-alist '(drag-internal-border . 1))
;; (add-to-list 'default-frame-alist '(internal-border-width . 5))

;;; frame init
(add-to-list 'default-frame-alist '(fullscreen . maximized))
;; full screen
;; (add-to-list 'default-frame-alist '(fullscreen . fullboth))
(map! :leader :desc "Max Frame" "tm" #'toggle-frame-maximized)

(use-package! diff-hl
  :config
  (map! :n "[g" #'diff-hl-previous-hunk)
  (map! :n "]g" #'diff-hl-next-hunk)
  (diff-hl-margin-mode -1)
  :hook
  (tex-mode . diff-hl-mode)
  (tex-mode . diff-hl-flydiff-mode)
  (prog-mode . diff-hl-mode)
  (prog-mode . diff-hl-flydiff-mode))


(use-package! awesome-tab
  :config
  (defhydra awesome-fast-switch (:hint nil)
    "
  ^^^^Fast Move             ^^^^Tab                    ^^Search            ^^Misc
  -^^^^--------------------+-^^^^---------------------+-^^----------------+-^^---------------------------
    ^_k_^   prev group    | _a_^^     select first | _b_ search buffer | _C-j_   next buffer
  _h_   _l_  switch tab   | _e_^^     select last  | _g_ search group  | _C-S-k_ kill others in group
    ^_j_^   next group    | _s_^^     ace jump     | ^^                | _C-k_   previous buffer
  ^^0 ~ 9^^ select window | _H_/_L_ move current   | ^^                | ^^
  -^^^^--------------------+-^^^^---------------------+-^^----------------+-^^---------------------------
  "
    ("h" awesome-tab-backward-tab)
    ("j" awesome-tab-forward-group)
    ("k" awesome-tab-backward-group)
    ("l" awesome-tab-forward-tab)
    ("0" awesom-tab-select-visible-tab)
    ("1" awesom-tab-select-visible-tab)
    ("2" awesom-tab-select-visible-tab)
    ("3" awesom-tab-select-visible-tab)
    ("4" awesom-tab-select-visible-tab)
    ("5" awesom-tab-select-visible-tab)
    ("6" awesom-tab-select-visible-tab)
    ("7" awesom-tab-select-visible-tab)
    ("8" awesom-tab-select-visible-tab)
    ("9" awesom-tab-select-visible-tab)
    ("a" awesome-tab-select-beg-tab)
    ("e" awesome-tab-select-end-tab)
    ("s" awesome-tab-ace-jump)
    ("H" awesome-tab-move-current-tab-to-left)
    ("L" awesome-tab-move-current-tab-to-right)
    ("b" ivy-switch-buffer)
    ("g" awesome-tab-counsel-switch-group)
    ;; ("C-k" kill-current-buffer)
    ("C-j" next-buffer)
    ("C-k" previous-buffer)
    ("C-S-k" awesome-tab-kill-other-buffers-in-current-group)
    ("q" nil "quit"))
  (map! :n "r" #'awesome-fast-switch/body)

  (evil-define-key 'normal 'global "gt" #'awesome-tab-ace-jump)
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
  (define-key global-map (kbd "M-p") #'+popup/other)
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
        (string-prefix-p "_region_.tex" name)
        (string-prefix-p "*Compile-Log*" name)
        (string-prefix-p "*lsp" name)
        (string-prefix-p "*org-latex" name)
        (string-prefix-p " *rime-posframe" name)
        (and (string-prefix-p "magit" name)
            (not (file-name-extension name))))))

  (awesome-tab-mode t))

(when IS-MAC
  (use-package! transwin
    :init
    (setq transwin--record-toggle-frame-transparency 95)
    :config
    (map! :leader "tt" #'transwin-toggle-transparent-frame)
    (map! :leader "tT" #'dwt/turn-on-transwin)
    (defun dwt/turn-on-transwin ()
      "Turn on transwin."
      (interactive)
      (when (= transwin--current-alpha 100)
            (transwin--set-transparency transwin--record-toggle-frame-transparency)))))
;;; title bar
;; (setq-default frame-title-format '("DOOM-EMACS - " user-login-name "@" system-name " - %b"))
;; (setq-default frame-title-format '("Emacs - " user-login-name " - %b"))
(setq-default frame-title-format '("Emacs - %b"))

;;; +modeline, light line in doom
(setq +modeline-height 13)
;; display time modeline
(unless IS-MAC
  (setq display-time-day-and-date t)
  (setq display-time-24hr-format t)
  (display-time-mode 1)
  ;; display battery in modeline
  (display-battery-mode 1))

(unless (display-graphic-p)
  (evil-terminal-cursor-changer-activate))

;;;###autoload
(defun dwt/reload-new-theme ()
  "Evaluate the current file, and reload the theme"
  (interactive)
  (let* ((buffer-name (buffer-file-name))
         (file-name (file-name-base buffer-name))
         (theme-name (replace-regexp-in-string "-theme" "" file-name)))
    (call-interactively #'eval-buffer)
    (load-theme (intern-soft theme-name) t nil)))
