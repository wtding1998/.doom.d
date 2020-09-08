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

(use-package! reftex-toc
  :defer t
  :config
       (setq! reftex-toc-follow-mode t
       reftex-toc-split-windows-horizontally t
       reftex-toc-split-windows-fraction 0.25
       reftex-toc-follow-mode t))
;;; reftex
