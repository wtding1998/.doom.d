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

(after! centaur-tabs
  (setq centaur-tabs-set-close-button nil)
  (setq centaur-tabs-set-modified-marker nil))

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
