;;; dwt/latex/config.el -*- lexical-binding: t; -*-


;; === latex ===
(add-hook 'LaTeX-mode-hook 'turn-on-cdlatex)
;; (add-hook! LaTeX-mode
;;   (add-to-list TeX-command-list '("XeLaTeX" "%`xelatex%(mode)%' %t" TeX-run-TeX nil t))
;;   (setq TeX-command-default "XeLaTeX"
;;         TeX-save-query nil
;;         TeX-show-compilation t))
;;; use xetex ass default engine
(setq-default TeX-engine 'xetex
              TeX-PDF-mode t)
;;; auctex preview scale
(after! preview
    (setq-default preview-scale 2.5))

(use-package! cdlatex
  :defer t
  :hook (cdlatex-mode . (lambda()
                          (define-key cdlatex-mode-map (kbd "(") nil)
                          )))
(after! tex
  (add-to-list 'TeX-view-program-selection
               '(output-pdf "llpp"))
  (add-to-list 'TeX-view-program-list
             '("llpp"
               ("llpp "
                (mode-io-correlate " ")
                "%o")
               "llpp"))

  ;;;###autoload
  (defun dwt/find-math-next()
  "Goto the next math environment in tex buffer."
    (interactive)
    (while (texmathp)
        (evil-forward-word-begin))
    (while (not (texmathp))
      (evil-forward-word-begin)))

  ;;;###autoload
  (defun dwt/find-math-prev()
  "Goto the last math environment in tex buffer."
    (interactive)
    (while (texmathp)
        (evil-backward-word-begin))
    (while (not (texmathp))
      (evil-backward-word-begin)))

  (defun dwt/insert-dollar ()
    (interactive)
    (unless (texmathp)
      (insert "$$")
      (left-char)))

  (defun dwt/insert-superscript ()
    (interactive)
    (insert "^{}")
    (left-char))

  (defun dwt/insert-transpose ()
    (interactive)
    (insert "^{T}"))


  (defun dwt/insert-star ()
    (interactive)
    (insert "^{*}"))

  (map!
   :map LaTeX-mode-map
   :localleader
   :desc "View" "v" #'TeX-view
   :desc "Run" "c" #'TeX-command-run-all
   :desc "Toggle TeX-Fold" "f" #'TeX-fold-mode
   :desc "Preview Environment" "e" #'preview-environment
   :desc "Preview Buffer" "b" #'preview-buffer
   :desc "Preview at Point" "p" #'preview-at-point
   :desc "Clean preview" "R" #'preview-clearout-buffer
   :desc "Clean preview" "r" #'preview-clearout-at-point
   ;; :desc "Command" "c" "TeX-command-master"
   :desc "toc" "t" #'reftex-toc)

   (add-hook 'LaTeX-mode-hook
            (lambda ()
              ; bind { and  } to next math and previous math
              (define-key evil-normal-state-local-map (kbd "}") 'dwt/find-math-next)
              (define-key evil-visual-state-local-map (kbd "}") 'dwt/find-math-next)
              (define-key evil-normal-state-local-map (kbd "{") 'dwt/find-math-prev)
              (define-key evil-visual-state-local-map (kbd "{") 'dwt/find-math-prev)
              (define-key evil-insert-state-local-map (kbd "M-\\") 'dwt/insert-dollar)
              (define-key evil-insert-state-local-map (kbd "M-[") 'dwt/insert-superscript)
              (define-key evil-insert-state-local-map (kbd "M-]") 'dwt/insert-transpose)
              (define-key evil-insert-state-local-map (kbd "M-8") 'dwt/insert-star))))
;; this setting failed
;; TODO: add synctex forward and backward
;; (after! tex
;; (add-to-list 'TeX-view-program-list
;;              '("Zathura"
;;                ("zathura "
;;                 (mode-io-correlate " --synctex-forward %n:0:%b -x \"emacsclient +%{line} %{input}\" ")
;;                 " %o")
;;                "zathura"))
;; (add-to-list 'TeX-view-program-selection
;;              '(output-pdf "Zathura")))


;;; reftex
(use-package! reftex-toc
  :defer t
  :config
       (setq! reftex-toc-follow-mode t
       reftex-toc-split-windows-horizontally t
       reftex-toc-split-windows-fraction 0.25
       reftex-toc-follow-mode t))

;;; find next or previous math environment

