;;; dwt/yasnippet/config.el -*- lexical-binding: t; -*-


;; === yasnippet ===
(use-package! yasnippet
  :defer t
  :config
  ;; remove the hack of doom
  ;; (map! :map yas-keymap "<backspace>" nil)
  (map! :leader
        :desc "yas-visit" "w[" #'
        :desc "yas-new" "w]" #'yas-new-snippet)
  ;;; auto-expand
  (defun my-yas-try-expanding-auto-snippets ()
    (when yas-minor-mode
      (let ((yas-buffer-local-condition ''(require-snippet-condition . auto)))
        (yas-expand))))
  (add-hook 'post-command-hook #'my-yas-try-expanding-auto-snippets)

  ;;; Activate org and LaTeX yas expansion in org-mode buffers.
  (defun my-org-latex-yas ()
    "Activate org and LaTeX yas expansion in org-mode buffers."
    (yas-minor-mode)
    (yas-activate-extra-mode 'latex-mode))
  (add-hook 'org-mode-hook #'my-org-latex-yas)

  ;;; disable the warning of yasnippet
  (after! warnings
    (add-to-list 'warning-suppress-types '(yasnippet backquote-change)))

  (defun dwt/math-auto-expand-yasnippet ()
    (interactive)
    (insert "# condition: (and (texmathp) 'auto)"))

  (map! (:leader)
        :desc "math auto expand" "ia" #'dwt/math-auto-expand-yasnippet))
  



;; (use-package auto-activating-snippets
;;   :hook (LaTeX-mode . auto-activating-snippets-mode)
;;   :hook (org-mode . auto-activating-snippets-mode)
;;   :config
;;   (aas-set-snippets 'text-mode
;;                     ;; expand unconditionally
;;                     "o-" "ō"
;;                     "i-" "ī"
;;                     "a-" "ā"
;;                     "u-" "ū"
;;                     "e-" "ē")
;;   (aas-set-snippets 'latex-mode
;;                     ;; set condition!
;;                     :cond #'texmathp ; expand only while in math
;;                     "supp" "\\supp"
;;                     "On" "O(n)"
;;                     "O1" "O(1)"
;;                     "Olog" "O(\\log n)"
;;                     "Olon" "O(n \\log n)"
;;                     ;; bind to functions!
;;                     "//" (lambda () (interactive)
;;                              (yas-expand-snippet "\\frac{$1}{$2}$0"))
;;                     "Span" (lambda () (interactive)
;;                              (yas-expand-snippet "\\Span($1)$0"))))

;; (use-package! latex-auto-activating-snippets
;;   :after latex ; auctex's LaTeX package
;;   :config ; do whatever here
;;   (auto-activating-snippets-mode)
;;   (aas-set-snippets 'latex-mode
;;                     ;; set condition!
;;                     :cond #'texmathp ; expand only while in math
;;                     "supp" "\\supp"
;;                     "On" "O(n)"
;;                     "O1" "O(1)"
;;                     "Olog" "O(\\log n)"
;;                     "Olon" "O(n \\log n)"
;;                     ;; bind to functions!
;;                     "//" (lambda () (interactive)
;;                              (yas-expand-snippet "\\frac{$1}{$2}$0"))
;;                     "Span" (lambda () (interactive)
;;                              (yas-expand-snippet "\\Span($1)$0"))))

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
