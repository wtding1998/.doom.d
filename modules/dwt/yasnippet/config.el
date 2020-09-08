;;; dwt/yasnippet/config.el -*- lexical-binding: t; -*-


;; === yasnippet ===
(use-package! yasnippet
  :defer t
  :config
  ;; auto-expand
  (defun my-yas-try-expanding-auto-snippets ()
    (when yas-minor-mode
      (let ((yas-buffer-local-condition ''(require-snippet-condition . auto)))
        (yas-expand))))
  (add-hook 'post-command-hook #'my-yas-try-expanding-auto-snippets)
  (defun my-org-latex-yas ()
    "Activate org and LaTeX yas expansion in org-mode buffers."
    (yas-minor-mode)
    (yas-activate-extra-mode 'latex-mode))

  (add-hook 'org-mode-hook #'my-org-latex-yas)
  )
;; (defun cm/calc-int (exp)
;;   (require 'calc)
;;   (require 'calc-lang)
;;   (ignore-errors
;;     (calc-create-buffer)
;;     (calc-radians-mode)
;;     (calc-latex-language nil)
;;     (calc-eval
;;      (concat "integ("
;;              exp
;;              ")"))))
