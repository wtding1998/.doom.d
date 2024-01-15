;;; dwt/dwt-dired/config.el -*- lexical-binding: t; -*-

;; https://github.com/ralesi/ranger.el
;; (use-package! ranger
;;   :config
;;   (setq ranger-footer-delay 0.2)
;;   (setq ranger-preview-delay 0.040)
;;   (setq ranger-parent-depth 2)
;;   (setq ranger-width-parents 0.12)
;;   (setq ranger-max-parent-width 0.12)
;;   (setq ranger-preview-file t)
;;   (setq ranger-show-literal t)
;;   (setq ranger-width-preview 0.55)
;;   )

;; (setq dired-guess-shell-alist-user '(("\\.pdf\\'" "evince"))
;;                                   ("\\.doc\\'" "libreoffice")
;;                                   ("\\.docx\\'" "libreoffice")
;;                                   ("\\.ppt\\'" "libreoffice")
;;                                   ("\\.pptx\\'" "libreoffice")
;;                                   ("\\.xls\\'" "libreoffice")
;;                                   ("\\.xlsx\\'" "libreoffice")
;;                                   ("\\.jpg\\'" "pinta")
;;                                   ("\\.png\\'" "pinta")
;;                                   ("\\.java\\'" "idea"))
;; use & to open pdf
(after! dired-x
  (setq dired-guess-shell-alist-user '(("\\.pdf\\'" "zathura")))
  (setq dired-omit-extensions (delete ".aux" dired-omit-extensions))
  (setq dired-omit-extensions (delete ".toc" dired-omit-extensions)))
(setq delete-by-moving-to-trash t)
(after! dired
  ;; sort by date by default
  ;; (add-hook 'dired-mode-hook #'dired-sort-toggle-or-edit)
  (setq dired-recursive-deletes 'always)
  (map! :n "_" #'dirvish-side
        ;; :n "-" #'dired-jump
        ;; :n "\\" #'dirvish-dwim
        :n "g\\" #'dirvish-dwim
        :n "|" #'evil-execute-in-emacs-state
        :map dired-mode-map
        :n "J" nil
        :n "[[" nil
        :n "]]" nil
        :n "Q" #'kill-current-buffer
        :n "go" #'evil-avy-goto-line
        :n "h" #'dired-up-directory
        :n "l" #'dired-find-file)

  (set-popup-rules!
    '(("^\\*Fd*" :size 15 :select t))))
  


(use-package! dirvish
  :init (after! dired (dirvish-override-dired-mode))
  ;; :hook ((dirvish-mode . variable-pitch-mode))
  :config
  (setq dirvish-attributes '(subtree-state nerd-icons collapse file-size file-time))
  (setq dirvish-default-layout '(1 0.11 0.52))
  (setq dirvish-hide-details t) ; if t, open dired-hide-details-mode at startup.
  (setq dirvish-quick-access-entries
        '(("h" "~/" "Home")
          ("r" "~/Documents/research/" "Research")
          ("t" "~/.Trash/" "Trash")
          ("d" "~/Downloads/" "Downloads")))
  ;; (setq dirvish-use-header-line 'global)
  (setq dirvish-use-header-line t)
  (setq dirvish-use-mode-line t)
  (setq dirvish-header-line-height 20)
  (setq dirvish-mode-line-height 20)
  (setq dirvish-header-line-format
        '(:left (path) :right (free-space)))
  (setq dirvish-mode-line-format
          '(:left (symlink file-time file-size) :right (vc-info omit yank sort index)))
  (setq dired-listing-switches
        "-l --sort=time --almost-all --time-style=long-iso --human-readable --group-directories-first --no-group")
  (setq dirvish-preview-dispatchers
      (cl-substitute 'pdf-preface 'pdf dirvish-preview-dispatchers))
  (setq dirvish-reuse-session t)
  (map! :map dirvish-mode-map
        :n "q" #'dirvish-quit
        :n "a" #'dirvish-quick-access
        :n "f" #'dirvish-file-info-menu
        :n "y" #'dirvish-yank-menu
        :n "N" #'dirvish-narrow
        :n "s" #'dirvish-quicksort
        :n "i" #'wdired-change-to-wdired-mode
        :n "." #'dired-omit-mode
        :n "t" #'dirvish-layout-toggle
        :n "v" #'dirvish-vc-menu
        :n "H" #'dirvish-history-go-backward
        :n "L" #'dirvish-history-go-forward
        :n "TAB" #'dirvish-subtree-toggle
        :localleader
        "f" #'dirvish-fd
        "d" #'dirvish-dispatch
        "F" #'dirvish-file-info-menu
        "r" #'dirvish-renaming-menu
        "y" #'dirvish-yank-menu
        "v" #'dirvish-vc-menu
        "l" #'dirvish-ls-switches-menu
        "h" #'dirvish-history-menu
        "m" #'dirvish-mark-menu
        "s" #'dirvish-setup-menu
        "e" #'dirvish-emerge-menu
        "j" #'dirvish-fd-jump))

(setq bookmark-default-file "~/.config/doom/cache/bookmarks")
