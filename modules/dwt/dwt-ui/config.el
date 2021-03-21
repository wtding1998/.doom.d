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
;;   (add-hook 'doom-load-theme-hook #'cnsunyour/set-splash-image))

;; (after! centaur-tabs
;;   (setq centaur-tabs-set-close-button nil)
;;   (setq centaur-tabs-set-modified-marker nil)

;;   (defun centaur-tabs-hide-tab (x)
;;     "Do no to show buffer X in tabs."
;;     (let ((name (format "%s" x)))
;;       (or
;;        ;; Current window is not dedicated window.
;;        (window-dedicated-p (selected-window))
;;        ;; Buffer name not match below blacklist.
;;        (string-prefix-p "*epc" name)
;;        (string-prefix-p "*helm" name)
;;        (string-prefix-p "*Helm" name)
;;        (string-prefix-p "*Compile-Log*" name)
;;        (string-prefix-p "*lsp" name)
;;        (string-prefix-p "*LSP" name)
;;        (string-prefix-p "*company" name)
;;        (string-prefix-p "*Flycheck" name)
;;        (string-prefix-p "*tramp" name)
;;        (string-prefix-p " *Mini" name)
;;        (string-prefix-p "*help" name)
;;        (string-prefix-p "*straight" name)
;;        (string-prefix-p " *temp" name)
;;        (string-prefix-p "*Help" name)
;;        (string-prefix-p "*org-latex-impatient" name)
;;        ;; Is not magit buffer.
;;        (and (string-prefix-p "magit" name)
;; 	          (not (file-name-extension name)))
;;        )))
;;   )

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
  (setq awesome-tab-height 190)
  (defun awesome-tab-hide-tab (x)
    (let ((name (format "%s" x)))
      (or
       (string-prefix-p "*epc" name)
       (string-prefix-p "*helm" name)
       (string-prefix-p "*Compile-Log*" name)
       (string-prefix-p "*lsp" name)
       (string-prefix-p " *rime-posframe" name)
       (and (string-prefix-p "magit" name)
            (not (file-name-extension name))))))

  (awesome-tab-mode t))




(unless (display-graphic-p)
  (evil-terminal-cursor-changer-activate))
