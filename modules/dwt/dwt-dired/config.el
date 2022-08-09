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
  (setq dired-omit-extensions (delete ".aux" dired-omit-extensions)))
(setq delete-by-moving-to-trash t)
(after! dired
  (map! :n "-" #'dirvish
        ;; :n "_" (lambda ()
        ;;          (interactive)
        ;;          (dired-jump t))
        :map dired-mode-map
        :n "J" nil
        :n "h" #'dired-up-directory
        :n "l" #'dired-find-file
        :localleader
        :desc "find file" "g" #'grep-dired-dwim
        :desc "fd" "f" #'fd-dired)
  (set-popup-rules!
    '(("^\\*Fd*" :size 15 :select t))))
  

;;;###autoload
(defun dwt/goto-recent-directory ()
  "Open recent directory with dired"
  (interactive)
  (unless recentf-mode (recentf-mode 1))
  (let ((collection
         (delete-dups
          (append (mapcar 'file-name-directory recentf-list)))))
    (ivy-read "Directories: " collection :action 'dired)))

;;;###autoload
(defun dwt/dired-projectile ()
  "Open dired in a project"
  (interactive)
  (unless projectile-mode (projectile-mode 1))
  (let (project-path)
    (setq project-path (ivy-read "Project: " projectile-known-projects))
    (dired project-path)))

(map! :leader
      :desc "recent dir" "od" #'dwt/goto-recent-directory
      :desc "project dir" "pd" #'dwt/dired-projectile)

(use-package! dirvish
  :init (after! dired (dirvish-override-dired-mode))
  :config
  ;; (setq dirvish-attributes '(vc-state subtree-state all-the-icons collapse git-msg file-size))
  (setq dirvish-attributes '(vc-state all-the-icons collapse file-size))
  (setq dirvish-use-header-line nil)
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
        :n "M-l" #'dirvish-ls-switches-menu
        :n "M-m" #'dirvish-mark-menu
        :n "M-s" #'dirvish-setup-menu
        :n "M-e" #'dirvish-emerge-menu
        :n "M-j" #'dirvish-fd-jump
        :n "H" #'dirvish-history-go-backward
        :n "L" #'dirvish-history-go-forward
        :n "TAB" #'dirvish-subtree-toggle))

(setq bookmark-default-file "~/.doom.d/bookmarks")
