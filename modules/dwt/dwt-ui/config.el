;;; dwt/dwt-ui/config.el -*- lexical-binding: t; -*-

(add-to-list '+doom-dashboard-menu-sections
             '("Reload last loaded session"
               :icon (nerd-icons-faicon "nf-fa-reply" :face 'doom-dashboard-menu-title)
               :action dwt/load-last-loaded-session))
;; (unless (display-graphic-p) ; for some reason this messes up the graphical splash screen atm
;;   (setq +doom-dashboard-ascii-banner-fn #'doom-dashboard-draw-ascii-emacs-banner-fn))
;; (setq +doom-dashboard-ascii-banner-fn #'doom-dashboard-draw-ascii-emacs-banner-fn)


(use-package! printed-theme)
(use-package! joker-theme)
(use-package! storybook-theme)

(setq dwt/gui-dark-theme 'doom-opera
      dwt/gui-light-theme 'modus-operandi
      dwt/gui-theme dwt/gui-light-theme
      ;; dwt/tui-dark-theme 'doom-zenburn)
      dwt/tui-dark-theme dwt/gui-dark-theme
      dwt/linux-large-font-size 210
      dwt/linux-small-font-size 120
      ; default font size
      ;; dwt/linux-default-font-size dwt/linux-large-font-size
      dwt/linux-default-font-size dwt/linux-small-font-size)


(define-minor-mode dwt/big-font-mode
  "Toggle font size."
  :init-value nil
  :global t
  :lighter " B"
  :group 'dwt
  (if dwt/big-font-mode
      (dwt/doom-font 1)
    (dwt/doom-font)))

(map! :leader :desc "big font mode" "tb" #'dwt/big-font-mode) ;; replace doom/big-font-mode
;; Make the fringe of modus theme invisible
(setq modus-themes-common-palette-overrides
      '((fringe unspecified)))

(if (and (fboundp 'daemonp) (daemonp))
  (add-hook 'after-make-frame-functions #'dwt/init-frame)
  ;; set for GUI without daemon
  (if (display-graphic-p)
      (progn
        ;; (load-theme 'modus-operandi t nil)
        (when (equal doom-theme 'doom-one)
          (load-theme dwt/gui-theme t nil)
          ;; (load-theme dwt/gui-light-theme t nil)
          (dwt/doom-font)))
    ;; theme for TUI without daemon
    (load-theme dwt/tui-dark-theme t nil)))

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
  ;; :defer t
  ;; :commands (awesome-tab-mode)
  :config
  (awesome-tab-mode 1)
  (defhydra awesome-tab-fast-switch (:hint nil)
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

  (map! :map awesome-tab-mode-map
        :n "[t" #'awesome-tab-ace-jump
        :n "]t" #'awesome-tab-fast-switch/body
        :n "[T" #'awesome-tab-backward-group
        :n "]T" #'awesome-tab-forward-group)
  (map! :map awesome-tab-mode-map :leader
        :desc "kill other tabs" "t1" #'awesome-tab-kill-other-buffers-in-current-group
        :desc "kill group" "t0" #'awesome-tab-kill-all-buffers-in-current-group
        :desc "tab fast switch" "tt" #'awesome-tab-fast-switch/body
        :desc "switch group" "sT" #'awesome-tab-switch-group)
  (map! :map awesome-tab-mode-map :ni "C-1" #'awesome-tab-select-visible-tab)
  (map! :map awesome-tab-mode-map :ni "C-2" #'awesome-tab-select-visible-tab)
  (map! :map awesome-tab-mode-map :ni "C-3" #'awesome-tab-select-visible-tab)
  (map! :map awesome-tab-mode-map :ni "C-4" #'awesome-tab-select-visible-tab)
  (map! :map awesome-tab-mode-map :ni "C-5" #'awesome-tab-select-visible-tab)
  (map! :map awesome-tab-mode-map :ni "C-6" #'awesome-tab-select-visible-tab)
  (map! :map awesome-tab-mode-map :ni "C-7" #'awesome-tab-select-visible-tab)
  (map! :map awesome-tab-mode-map :ni "C-8" #'awesome-tab-select-visible-tab)
  (map! :map awesome-tab-mode-map :ni "C-9" #'awesome-tab-select-visible-tab)
  (map! :map awesome-tab-mode-map :ni "C-<tab>" #'awesome-tab-forward-tab)
  (map! :map awesome-tab-mode-map :ni "<backtab>" #'awesome-tab-backward-tab)
  (map! :map awesome-tab-mode-map :ni "C-<iso-lefttab>" #'awesome-tab-backward-tab)

  ;; height
  (if IS-MAC
      ;; mac
      (setq awesome-tab-height 110
            awesome-tab-icon-height 0.7
            awesome-tab-active-bar-height 15)
      ;; arch
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
      ;; (setq frame-title-format '("Emacs @ " "%f"))
      (setq frame-title-format "Emacs @ wtding")
      (setq doom-big-font-increment 5)) ;; for doom big font mode
      ;; (toggle-frame-fullscreen))
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
  ;; :ensure nil
  :after evil
  :preface
  (defun my-pulse-momentary-line (&rest _)
    "Pulse the current line."
    (pulse-momentary-highlight-one-line (point) 'next-error-message))

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
                 symbol-overlay-basic-jump
                 goto-last-change
                 goto-last-change-reverse))
    (advice-add cmd :after #'my-pulse-momentary-line))
  (dolist (cmd '(pop-to-mark-command
                 pop-global-mark))
    (advice-add cmd :after #'my-recenter-and-pulse))
  :config
  (setq pulse-iterations 2
        pulse-delay 0.08))

(setq dwt/show-my-mode-line-info t)
(setq dwt/my-mode-line-info "FP Q ")
(add-to-list 'mode-line-misc-info `(dwt/show-my-mode-line-info ("" dwt/my-mode-line-info)))

(map! :g "<f10>" #'dwt/hide-pdf-window)
(map! :g "<f11>" #'toggle-frame-fullscreen)


(use-package! shrink-path)

(use-package! posframe
  :config
  (map! :leader
        "tp" #'posframe-delete-all))
