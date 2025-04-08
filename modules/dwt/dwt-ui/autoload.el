;;; dwt/dwt-ui/autoload.el -*- lexical-binding: t; -*-


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

;;;###autoload
(defun dwt/toggle-mode-line-info ()
  (interactive)
  (if dwt/show-my-mode-line-info
      (setq dwt/show-my-mode-line-info nil)
    (setq dwt/show-my-mode-line-info t)))


;;;###autoload
(defun dwt/toggle-date-display ()
  (interactive)
  (if display-time-day-and-date
      (setq display-time-day-and-date nil)
    (setq display-time-day-and-date t))
  (display-time-mode 1))

;;;###autoload
(defun dwt/reload-new-theme ()
  "Evaluate the current file, and reload the theme"
  (interactive)
  (let* ((buffer-name (buffer-file-name))
         (file-name (file-name-base buffer-name))
         (theme-name (replace-regexp-in-string "-theme" "" file-name)))
    (call-interactively #'eval-buffer)
    (load-theme (intern-soft theme-name) t nil)))

;;;###autoload
(defun dwt/init-frame(frame)
  ;; setting for daemon
  (with-selected-frame frame
    (if (display-graphic-p)
        (progn
          ;; only load ui setting at start
          (when (equal doom-theme 'doom-one)
          ;; theme for GUI in daemon
            (load-theme dwt/gui-theme t nil)))
      ;;; theme for TUI in daemon
      (load-theme dwt/tui-dark-theme t nil))))

;; font
;;;###autoload
(defun dwt/doom-font(&optional big)
  (interactive)
  (let ((fontsize dwt/default-font-size)
        (weight 'semi-bold))
    (when big
      (setq fontsize (+ 90 dwt/default-font-size)))
    (when IS-MAC
      (setq weight 'regular))
    (set-face-attribute 'default nil :family "Sarasa Term SC Nerd" :height fontsize :weight weight)
    (set-face-attribute 'variable-pitch nil :family "Bookerly" :height 1.03)
    (if IS-MAC
      (set-fontset-font t 'unicode (font-spec :family "Noto Color Emoji") nil 'prepend)
      (set-fontset-font t 'unicode (font-spec :family "Symbola") nil 'prepend))
    (set-fontset-font t '(#x4e00 . #x9fff) (font-spec :family "LXGW WenKai Mono")))) ;; set Chinese font 落霞孤鹜

;; https://discourse.doomemacs.org/t/how-to-change-your-splash-screen/57
;;;###autoload
(defun doom-dashboard-draw-ascii-emacs-banner-fn ()
  (let* ((banner
          ;; '(",---.,-.-.,---.,---.,---."
          ;;   "|---'| | |,---||    `---."
          ;;   "`---'` ' '`---^`---'`---'"))
          '("==============================================="))
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

;;;###autoload
(defun dwt/awesome-tray-module-clock-info ()
  (when (org-clocking-p)
    ;; (let ((elapsed (org-duration-from-minutes
    ;;                 (floor (org-time-convert-to-integer
    ;;                         (org-time-since org-clock-start-time))
    ;;                        60))))
    ;; TODO: add the two strings up
    (let ((elapsed org-clock-to))
      (if org-clock-effort
          (format "%s/%s" elapsed org-clock-effort)
        (format "%s" elapsed)))))

;;;###autoload
(defun dwt/awesome-tray-module-info ()
  (when dwt/show-my-mode-line-info
    dwt/my-mode-line-info))
