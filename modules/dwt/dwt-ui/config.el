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


(use-package! diff-hl
  :config
  (diff-hl-margin-mode 0)
  :hook
  (prog-mode . global-diff-hl-mode)
  (prog-mode . diff-hl-flydiff-mode))
