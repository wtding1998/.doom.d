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

;; (awesome-tab-mode t)
(after! centaur-tabs
  (centaur-tabs-headline-match)
  (setq centaur-tabs-style "bar")
  (setq centaur-tabs-set-icons t)
  (setq centaur-tabs-gray-out-icons 'buffer)
  (setq centaur-tabs-set-bar 'under)
  ;; Note: If you're not using Spacmeacs, in order for the underline to display
  ;; correctly you must add the following line:
  (setq x-underline-at-descent-line t)
  (setq centaur-tabs-set-modified-marker t)
  (add-hook 'dired-mode-hook 'centaur-tabs-local-mode)
      (defun centaur-tabs-buffer-groups ()
        "`centaur-tabs-buffer-groups' control buffers' group rules.

      Group centaur-tabs with mode if buffer is derived from `eshell-mode' `emacs-lisp-mode' `dired-mode' `org-mode' `magit-mode'.
      All buffer name start with * will group to \"Emacs\".
      Other buffer group by `centaur-tabs-get-group-name' with project name."
        (list
    (cond
    ((or (string-equal "*" (substring (buffer-name) 0 1))
          (memq major-mode '(magit-process-mode
          magit-status-mode
          magit-diff-mode
          magit-log-mode
          magit-file-mode
          magit-blob-mode
          magit-blame-mode
          )))
      "Emacs")
    ((derived-mode-p 'prog-mode)
      "Editing")
    ((derived-mode-p 'dired-mode)
      "Dired")
    ((memq major-mode '(helpful-mode
            help-mode))
      "Help")
    ((memq major-mode '(org-mode
            org-agenda-clockreport-mode
            org-src-mode
            org-agenda-mode
            org-beamer-mode
            org-indent-mode
            org-bullets-mode
            org-cdlatex-mode
            org-agenda-log-mode
            TeX-mode
            python-mode
            latex-mode
            diary-mode))
      "OrgMode")
    (t
      (centaur-tabs-get-group-name (current-buffer))))))
  (define-key evil-normal-state-map (kbd "g t") 'centaur-tabs-forward)
  (define-key evil-normal-state-map (kbd "g T") 'centaur-tabs-backward)
  (defun centaur-tabs-hide-tab (x)
    "Do no to show buffer X in tabs."
    (let ((name (format "%s" x)))
      (or
      ;; Current window is not dedicated window.
      (window-dedicated-p (selected-window))

      ;; Buffer name not match below blacklist.
      (string-prefix-p "*epc" name)
      (string-prefix-p "*helm" name)
      (string-prefix-p "*Helm" name)
      (string-prefix-p "*Compile-Log*" name)
      (string-prefix-p "*lsp" name)
      (string-prefix-p "*company" name)
      (string-prefix-p "*Flycheck" name)
      (string-prefix-p "*tramp" name)
      (string-prefix-p " *Mini" name)
      (string-prefix-p "*help" name)
      (string-prefix-p "*straight" name)
      (string-prefix-p " *temp" name)
      (string-prefix-p "*Help" name)
      (string-prefix-p "*mybuf" name)

      ;; Is not magit buffer.
      (and (string-prefix-p "magit" name)
      (not (file-name-extension name)))
      )))
  (setq centaur-tabs-cycle-scope 'tabs)
  )
