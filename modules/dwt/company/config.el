;;; dwt/company/config.el -*- lexical-binding: t; -*-

;;; disabel tab in completion
(after! company
;; disable tab in company-mode
  (define-key company-active-map (kbd "<tab>") nil)
  (define-key company-mode-map (kbd "<tab>") nil)
  (define-key company-search-map (kbd "<tab>") nil)
  (define-key company-active-map (kbd "TAB") nil)
  (define-key company-mode-map (kbd "TAB") nil)
  (define-key company-search-map (kbd "TAB") nil)
  )

(use-package! company-prescient
  :defer t
  :init (company-prescient-mode 1))
