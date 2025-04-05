;;; dwt/dwt-dired/config.el -*- lexical-binding: t; -*-

;; use & to open pdf
(after! dired-x
  (setq dired-guess-shell-alist-user '(("\\.pdf\\'" "zathura")))
  (add-to-list 'dired-omit-extensions ".nav")
  (add-to-list 'dired-omit-extensions ".fls")
  (add-to-list 'dired-omit-extensions ".snm")
  (add-to-list 'dired-omit-extensions ".run.xml")
  (add-to-list 'dired-omit-extensions ".out")
  (add-to-list 'dired-omit-extensions ".synctex.gz")
  (setq dired-omit-files (concat "\\.auctex-auto\\|" dired-omit-files)))
(setq delete-by-moving-to-trash t)
(after! dired
  ;; sort by date by default
  ;; (add-hook 'dired-mode-hook #'dired-sort-toggle-or-edit)
  (setq dired-recursive-deletes 'always)
  (map! :n "_" #'dirvish-side
        ;; :n "-" #'dired-jump
        ;; :n "\\" #'dirvish-dwim
        :n "|" #'dirvish-dwim
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
  (setq dirvish-use-header-line nil)
  (setq dirvish-use-mode-line nil)
  (setq dirvish-header-line-height '(20 . 20))
  (setq dirvish-mode-line-height 20)
  (setq dirvish-header-line-format
        '(:left (path) :right (vc-info omit sort index)))
  ;; (setq dirvish-mode-line-format
  ;;         '(:left (symlink file-time file-size) :right (vc-info omit yank sort index)))
  (setq dired-listing-switches
        "-l --sort=time --almost-all --time-style=long-iso --human-readable --group-directories-first --no-group")
  ;; (setq dirvish-preview-dispatchers
  ;;     (cl-substitute 'pdf-preface 'pdf dirvish-preview-dispatchers))

  (if (featurep :system 'linux)
      (progn
        (dirvish-define-preview exa (file)
          "Use `exa' to generate directory preview."
          :require ("exa") ; tell Dirvish to check if we have the executable
          (when (file-directory-p file) ; we only interest in directories here
            `(shell . ("exa" "-al" "--color=always" "--icons" "--time-style=long-iso"
                        "--group-directories-first" ,file))))
        (add-to-list 'dirvish-preview-dispatchers 'exa))
      (progn
        (dirvish-define-preview eza (file)
          "Use `eza' to generate directory preview."
          :require ("eza") ; tell Dirvish to check if we have the executable
          (when (file-directory-p file) ; we only interest in directories here
            `(shell . ("eza" "-al" "--color=always" "--icons=always"
                        "--group-directories-first" ,file))))
        (add-to-list 'dirvish-preview-dispatchers 'eza)))
  (setq dirvish-reuse-session nil)
  (setq dirvish-emerge-groups
    '(("Recent files" (predicate . recent-files-2h))
      ("Documents" (extensions "pdf" "tex" "bib" "doc" "xlsx" "xls"))
      ("Video" (extensions "mp4" "mkv" "webm"))
      ("Pictures" (extensions "jpg" "png" "svg" "gif"))
      ("Audio" (extensions "mp3" "flac" "wav" "ape" "aac"))
      ("Archives" (extensions "gz" "rar" "zip"))))
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

(setq bookmark-default-file (concat doom-cache-dir "bookmarks"))

(after! nerd-icons
  (add-to-list 'nerd-icons-extension-icon-alist '("m" nerd-icons-codicon "nf-cod-triangle_up" :face nerd-icons-orange)))
