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
  (setq dired-guess-shell-alist-user '(("\\.pdf\\'" "SumatraPDF-3.2-64.exe"))))

(after!
  (map! :map dired-mode-map
        :localleader
        :desc "find file" "g" #'grep-dired-dwim))
