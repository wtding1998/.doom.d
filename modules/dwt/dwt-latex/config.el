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
    (setq-default preview-scale 3)
  )

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
                " %o")
               "llpp")))
;; this setting failed
;; TODO: add synctex forward and backward
;; (add-to-list 'TeX-view-program-list
;;              '("Zathura"
;;                ("zathura "
;;                 (mode-io-correlate " --synctex-forward %n:0:%b -x \"emacsclient +%{line} %{input}\" ")
;;                 " %o")
;;                "zathura"))
;; (add-to-list 'TeX-view-program-selection
;;              '(output-pdf "Zathura"))


(use-package! reftex-toc
  :defer t
  :config
       (setq! reftex-toc-follow-mode t
       reftex-toc-split-windows-horizontally t
       reftex-toc-split-windows-fraction 0.25
       reftex-toc-follow-mode t))
;;; reftex
