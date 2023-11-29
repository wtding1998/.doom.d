;;; dwt/dwt-ui/config.el -*- lexical-binding: t; -*-

;; set the fringe of window
;; (set-fringe-mode '(4 . 4))

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


;; UI
;; set the fringe color
;; (defun dwt/set-fringe-color()
;;   (set-face-attribute 'fringe nil :background (face-background 'default)))
;; (add-hook 'doom-load-theme-hook 'dwt/set-fringe-color)

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

(map! :leader :desc "toggle sentence" "ta" #'dwt/toggle-sentence)

(map! :n "[f" #'+evil/previous-frame
      :n "]f" #'+evil/next-frame
      :n "[F" #'+evil/previous-file
      :n "]F" #'+evil/next-file)

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
                          doom-opera
                          doom-monokai-pro
                          gruvbox
                          doom-nord
                          doom-horizon
                          doom-monokai-pro
                          doom-monokai-octagon))

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


;; font
(defun dwt/doom-font()
    (when IS-MAC
      ;; (set-face-attribute 'default nil :family "FiraCode Nerd Font" :height 150)
      (set-face-attribute 'default nil :family "Sarasa Term SC Nerd" :height 150)
      (set-face-attribute 'variable-pitch nil :family "Bookerly" :height 1.03)
      (set-fontset-font t 'emoji (font-spec :family "Noto Color Emoji") nil 'prepend))
    (when IS-LINUX
      (set-face-attribute 'default nil :family "Sarasa Term SC Nerd" :height 120)
      (set-face-attribute 'variable-pitch nil :family "Bookerly" :height 1.03)
      (set-fontset-font t 'emoji (font-spec :family "Noto Color Emoji") nil 'prepend)))

    ;; (setq doom-font (font-spec :family "Sarasa Mono SC Nerd" :size dwt/fontsize :weight 'Medium))
    ;; chinese font
    ;; (set-fontset-font t 'unicode "Noto Color Emoji" nil 'prepend)
    ;; (dolist (charset '(kana han symbol cjk-misc bopomofo))
    ;;   (set-fontset-font (frame-parameter nil 'font)
    ;;                     charset
    ;;                     (font-spec :family "Sarasa Term SC Nerd")))) ;; 14 16 20 22 28
                        ;; (font-spec :family "Source Han Serif CN"))))) ;; 14 16 20 22 28

;; Make the fringe of modus theme invisible
(setq modus-themes-common-palette-overrides
      '((fringe unspecified)))

(defun dwt/init-frame(frame)
  ;; setting for daemon
  (with-selected-frame frame
    ;; font and theme for GUI
    (if (display-graphic-p)
        (progn
          ;; only load ui setting at start
          (when (equal doom-theme 'doom-one)
            (dwt/doom-font)
          ;; theme for GUI in daemon
            ;; (load-theme 'doom-tokyo-night t nil)
            (load-theme 'modus-operandi t nil)))
      ;;; theme for TUI in daemon
      (load-theme 'doom-zenburn t nil))))

(if (and (fboundp 'daemonp) (daemonp))
  (add-hook 'after-make-frame-functions #'dwt/init-frame)
  ;; set for GUI without daemon
  (if (display-graphic-p)
      (progn
        ;; (load-theme 'modus-operandi t nil)
        (when (equal doom-theme 'doom-one)
          ;; (load-theme 'doom-tokyo-night t nil)
          (load-theme 'modus-operandi t nil)
          (dwt/doom-font)))
    ;; theme for TUI without daemon
    (load-theme 'doom-monokai-pro t nil)))

;; hide title bar
;; (setq default-frame-alist '((undecorated . t)))
;; (add-to-list 'default-frame-alist '(drag-internal-border . 1))
;; (add-to-list 'default-frame-alist '(internal-border-width . 5))

;; frame
;; (add-to-list 'default-frame-alist '(fullscreen . maximized))
;; full screen may cause error for the frame created by emacs-everywhere
;; (add-to-list 'default-frame-alist '(fullscreen . fullboth))
(map! :leader :desc "Max Frame" "tM" #'toggle-frame-maximized)

(use-package! diff-hl
  :config
  (map! :n "[g" #'diff-hl-previous-hunk)
  (map! :n "]g" #'diff-hl-next-hunk)
  (diff-hl-margin-mode -1)
  :hook
  (tex-mode . diff-hl-mode)
  ;; (tex-mode . diff-hl-flydiff-mode)
  (prog-mode . diff-hl-mode))
  ;; (prog-mode . diff-hl-flydiff-mode))

(after! diff-hl
   (map! :n "[g" #'diff-hl-previous-hunk)
   (map! :n "]g" #'diff-hl-next-hunk)
   (diff-hl-margin-mode -1))

(use-package! awesome-tab
  :defer t
  :commands (awesome-tab-mode)
  :config
  (defhydra awesome-fast-switch (:hint nil)
    "
  ^^^^Fast Move             ^^^^Tab                    ^^Search            ^^Misc
  -^^^^--------------------+-^^^^---------------------+-^^----------------+-^^---------------------------
    ^_k_^   prev group    | _a_^^     select first | _b_ search buffer | _C-j_   next buffer
  _h_   _l_  switch tab   | _e_^^     select last  | _g_ search group  | _C-S-k_ kill others in group
    ^_j_^   next group    | _r_^^     ace jump     | ^^                | _C-k_   previous buffer
  ^^0 ~ 9^^ select window | _H_/_L_ move current   | ^^                | ^^
  -^^^^--------------------+-^^^^---------------------+-^^----------------+-^^---------------------------
  "
    ("h" awesome-tab-backward-tab)
    ("j" awesome-tab-forward-group)
    ("k" awesome-tab-backward-group)
    ("l" awesome-tab-forward-tab)
    ("0" awesome-tab-select-visible-tab)
    ("1" awesome-tab-select-visible-tab)
    ("2" awesome-tab-select-visible-tab)
    ("3" awesome-tab-select-visible-tab)
    ("4" awesome-tab-select-visible-tab)
    ("5" awesome-tab-select-visible-tab)
    ("6" awesome-tab-select-visible-tab)
    ("7" awesome-tab-select-visible-tab)
    ("8" awesome-tab-select-visible-tab)
    ("9" awesome-tab-select-visible-tab)
    ("a" awesome-tab-select-beg-tab)
    ("e" awesome-tab-select-end-tab)
    ("r" awesome-tab-ace-jump)
    ("H" awesome-tab-move-current-tab-to-left)
    ("L" awesome-tab-move-current-tab-to-right)
    ("b" ivy-switch-buffer)
    ("g" awesome-tab-counsel-switch-group)
    ;; ("C-k" kill-current-buffer)
    ("C-j" next-buffer)
    ("C-k" previous-buffer)
    ("C-S-k" awesome-tab-kill-other-buffers-in-current-group)
    ("q" nil "quit"))

  (map! :n "r" #'awesome-fast-switch/body
        :n "ge" #'awesome-tab-ace-jump)
  (map! :map awesome-tab-mode-map
        :desc "kill other tabs" "t1" #'awesome-tab-kill-other-buffers-in-current-group
        :desc "switch tabs group" "tt" #'awesome-tab-counsel-switch-group
        :desc "next-group" "tn" #'awesome-tab-forward-group
        :desc "last-group" "tp" #'awesome-tab-backward-group
        :desc "kill-group" "tk" #'awesome-tab-kill-all-buffers-in-current-group)

  (evil-define-key 'normal 'global "gt" #'awesome-tab-forward-tab)
  (evil-define-key 'normal 'global "gT" #'awesome-tab-backward-tab)
  (evil-define-key 'normal 'global "]t" #'awesome-tab-forward-group)
  (evil-define-key 'normal 'global "[t" #'awesome-tab-backward-group)
  (evil-define-key 'normal 'global (kbd"<leader>tt") #'awesome-tab-counsel-switch-group)
  (evil-define-key 'normal 'global (kbd"<leader>t1") #'awesome-tab-kill-other-buffers-in-current-group)
  (evil-define-key 'normal 'global (kbd"<leader>t0") #'awesome-tab-kill-all-buffers-in-current-group)
  ;; (evil-define-key 'normal 'global (kbd"<leader>tn") #'awesome-tab-forward-tab)
  ;; (evil-define-key 'normal 'global (kbd"<leader>tp") #'awesome-tab-backward-tab)
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

  ;; height
  (if (not IS-MAC)
      ;; arch
      (progn
        (setq awesome-tab-height 180
              awesome-tab-active-bar-height 20))
      ;; mac
      (progn
        (setq awesome-tab-height 120
              awesome-tab-icon-height 0.7
              awesome-tab-active-bar-height 15)))

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
        (string-suffix-p ".synctex.gz" name)
        (string-suffix-p ".log" name)
        (string-prefix-p " *rime-posframe" name)
        (and (string-prefix-p "magit" name)
            (not (file-name-extension name))))))

  (awesome-tab-mode t))

(when IS-MAC
  (use-package! transwin
    :commands (transwin-toggle)
    :init
    (map! :leader "tt" #'transwin-toggle)
    :config
    (setq transwin--record-toggle-frame-transparency 85)
    (map! :leader "tT" #'dwt/turn-on-transwin)
    (defun dwt/turn-on-transwin ()
      "Turn on transwin."
      (interactive)
      (when (= transwin--current-alpha 100)
            (transwin--set-transparency transwin--record-toggle-frame-transparency)))))
;;; title bar
;; (setq-default frame-title-format '("DOOM-EMACS - " user-login-name "@" system-name " - %b"))
;; (setq-default frame-title-format '("Emacs - " user-login-name " - %b"))
(if IS-LINUX
    (progn
      (setq frame-title-format "Emacs")
      (setq doom-big-font-increment 5) ;; for doom big font mode
      (toggle-frame-maximized))
  (setq frame-title-format
        '(buffer-file-name (:eval (abbreviate-file-name buffer-file-name))
          (dired-directory dired-directory "%b"))))

(define-key global-map (kbd "M-o") #'other-window)
(define-key global-map (kbd "M-p") #'+popup/other)
;;; +modeline, light line in doom
(setq +modeline-height 1)
(def-modeline-var! +modeline-buffer-identification ; slightly more informative buffer id
  '((:eval
     (propertize
      (string-limit (or +modeline--buffer-id-cache (buffer-name)) 37 t) ; avoid too long length
      'face (cond ((buffer-modified-p) '(error bold mode-line-buffer-id))
                  ((+modeline-active)  'mode-line-buffer-id))
      'help-echo (or +modeline--buffer-id-cache (buffer-name))))
    (buffer-read-only (:propertize " RO" face warning))))
;; display time modeline
(setq display-time-24hr-format t
      display-time-default-load-average nil)
(setq display-time-day-and-date t)
(display-time-mode -1)
;; display battery in modeline
(display-battery-mode -1)

(map! :leader
      :desc "toggle date" "td" #'dwt/toggle-date-display)

;;;###autoload
(defun dwt/toggle-date-display ()
  (interactive)
  (if display-time-day-and-date
      (setq display-time-day-and-date nil)
    (setq display-time-day-and-date t))
  (display-time-mode)
  (display-time-mode))

;;;###autoload
(defun dwt/reload-new-theme ()
  "Evaluate the current file, and reload the theme"
  (interactive)
  (let* ((buffer-name (buffer-file-name))
         (file-name (file-name-base buffer-name))
         (theme-name (replace-regexp-in-string "-theme" "" file-name)))
    (call-interactively #'eval-buffer)
    (load-theme (intern-soft theme-name) t nil)))

;;; change the height of icon for mac
(after! evil
  (defun +modeline-format-icon (icon-set icon label &optional face help-echo voffset)
    "Build from ICON-SET the ICON with LABEL.
  Using optionals attributes FACE, HELP-ECHO and VOFFSET."
    (let ((icon-set-fn (pcase icon-set
                        ('octicon #'nerd-icons-octicon)
                        ('faicon #'nerd-icons-faicon)
                        ('codicon #'nerd-icons-codicon)
                        ('material #'nerd-icons-mdicon))))
      (propertize (concat (funcall icon-set-fn
                                  icon
                                  :face face
                                  :height 0.7
                                  :v-adjust (or voffset -0.225))
                          (propertize label 'face face))
                  'help-echo help-echo)))

  (defun +modeline-checker-update (&optional status)
    "Update flycheck text via STATUS."
    (setq +modeline-checker
          (pcase status
            (`finished
              (if flycheck-current-errors
                  (let-alist (flycheck-count-errors flycheck-current-errors)
                    (let ((error (or .error 0))
                          (warning (or .warning 0))
                          (info (or .info 0)))
                      (+modeline-format-icon 'material "nf-md-close"
                                              (concat " " (number-to-string (+ error warning info)))
                                              (cond ((> error 0)   'error)
                                                    ((> warning 0) 'warning)
                                                    ('success))
                                              (format "Errors: %d, Warnings: %d, Debug: %d"
                                                      error
                                                      warning
                                                      info)
                                              0.2)))
                  (+modeline-format-icon 'material "nf-md-check" " " 'success "Success" 0.2)))
            (`running     (+modeline-format-icon 'material "nf-md-alarm_light" "  " 'mode-line "Running..." 0.2))
            (`errored     (+modeline-format-icon 'material "nf-md-sim_alert" "  " 'error "Errored!" 0.2))
            (`interrupted (+modeline-format-icon 'material "nf-md-pause" " ?" 'mode-line "Interrupted" 0.2))
            (`suspicious  (+modeline-format-icon 'material "nf-md-priority_high" " !" 'error "Suspicious" 0.2))))))


(use-package! awesome-tray
  :defer t
  :config
  (when (display-graphic-p)
    (awesome-tray-mode 1))
  ;; (setq awesome-tray-active-modules '("- -> 0" "input-method" "evil" "buffer-name" "org-pomodoro" "pdf-view-page" "location" "file-path" "battery" "date"))
  (setq awesome-tray-position 'right)
  (setq awesome-tray-second-line nil)
  (setq awesome-tray-info-padding-right 4)
  (setq awesome-tray-evil-show-macro t)
  (setq awesome-tray-evil-show-cursor-count t)
  (setq awesome-tray-active-modules '("input-method" "evil" "buffer-name" "org-pomodoro" "pdf-view-page" "location" "file-path" "battery" "date"))
  ;; (setq awesome-tray-essential-modules '("pdf-view-page"))
  (setq awesome-tray-input-method-zh-style "ㄓ"
        awesome-tray-input-method-en-style ""
        awesome-tray-buffer-name-buffer-changed t
        awesome-tray-file-path-full-dirname-levels 0
        awesome-tray-file-path-truncate-dirname-levels 1
        awesome-tray-file-path-truncated-name-length 6))

(use-package! sort-tab
  :commands (sort-tab-mode)
  :defer t
  :config
  (map! :ni "C-<tab>" #'sort-tab-select-next-tab
        :ni "C-<iso-lefttab>" #'sort-tab-select-prev-tab
        :n "gt" #'sort-tab-select-next-tab
        :n "gT" #'sort-tab-select-prev-tab
        :n "Q" #'sort-tab-close-current-tab
        :ni "C-1" #'sort-tab-select-visible-tab
        :ni "C-2" #'sort-tab-select-visible-tab
        :ni "C-3" #'sort-tab-select-visible-tab
        :ni "C-4" #'sort-tab-select-visible-tab
        :ni "C-5" #'sort-tab-select-visible-tab
        :ni "C-6" #'sort-tab-select-visible-tab
        :ni "C-7" #'sort-tab-select-visible-tab
        :ni "C-8" #'sort-tab-select-visible-tab
        :ni "C-9" #'sort-tab-select-visible-tab))

;; Visualize TAB, (HARD) SPACE, NEWLINE
;; Pulse current line
;; copied from centaur-emacs
;; seagle0128/.emacs.d/blob/66afa5d433b18948b994cb386a3d2a1ce6788456/lisp/init-highlight.el#L211
(use-package! pulse
  :ensure nil
  :after evil
  :preface
  (defun my-pulse-momentary-line (&rest _)
    "Pulse the current line."
    (pulse-momentary-highlight-one-line (point) 'next-error))

  (defun my-pulse-momentary (&rest _)
    "Pulse the current line."
    (if (fboundp 'xref-pulse-momentarily)
        (xref-pulse-momentarily)
      (my-pulse-momentary-line)))

  (defun my-recenter-and-pulse(&rest _)
    "Recenter and pulse the current line."
    (recenter)
    (my-pulse-momentary))

  (defun my-recenter-and-pulse-line (&rest _)
    "Recenter and pulse the current line."
    (recenter)
    (my-pulse-momentary-line))

  :hook (((dumb-jump-after-jump
           imenu-after-jump) . my-recenter-and-pulse)
         ((bookmark-after-jump
           magit-diff-visit-file
           next-error) . my-recenter-and-pulse-line))
  :init
  (dolist (cmd '(recenter-top-bottom
                 other-window ace-window windmove-do-window-select
                 better-jumper-jump-backward
                 better-jumper-jump-forward
                 evil-scroll-line-to-center
                 evil-scroll-down evil-scroll-up
                 pager-page-down pager-page-up
                 symbol-overlay-basic-jump))
    (advice-add cmd :after #'my-pulse-momentary-line))
  (dolist (cmd '(pop-to-mark-command
                 pop-global-mark
                 goto-last-change))
    (advice-add cmd :after #'my-recenter-and-pulse))
  :config
  (setq pulse-iterations 2
        pulse-delay 0.08))

(setq dwt/show-my-mode-line-info t)
(setq dwt/my-mode-line-info "Supp L ")
(add-to-list 'mode-line-misc-info `(dwt/show-my-mode-line-info ("" dwt/my-mode-line-info)))

(defun dwt/toggle-mode-line-info ()
  (interactive)
  (if dwt/show-my-mode-line-info
      (setq dwt/show-my-mode-line-info nil)
    (setq dwt/show-my-mode-line-info t)))


;;;###autoload
(defun dwt/hide-pdf-window ()
  "Store the current window layout, hide all windows in pdf-view-mode, and toggle full-screen.
The window layout is restored when full-screen is toggled off."
  (interactive)
  (dolist (window (window-list))               ; iterate over all windows
    (when (eq (buffer-local-value 'major-mode (window-buffer window)) 'pdf-view-mode)
      (select-window window)
      (switch-to-buffer "*scratch*")
      ;; (revert-buffer)
      ;; (set-window-buffer window (get-buffer "*scratch*"))
      (message "delete one window"))))

    ;; (toggle-frame-fullscreen)                    ; toggle full-screen
    ;; (posframe-delete-all)                        ; delete all posframes
    ;; (set-window-configuration layout)))          ; restore the window layout

    ;; (when (> undo-count 0)
    ;;   (dolist (i (number-sequence 0 (- undo-count 1)))
    ;;     (setq window (nth i recover-window-list))
    ;;     (setq buffer (nth i recover-buffer-list))
    ;;     switch buffer will stack, not matter previous-buffer or set-window-buffer
    ;;     (select-window window)
    ;;     (call-interactively #'previous-buffer)))))
    ;;
(map! :g "<f10>" #'dwt/hide-pdf-window)
(map! :g "<f11>" #'toggle-frame-fullscreen)


(use-package! shrink-path)
