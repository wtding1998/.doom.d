;;; dwt/yasnippet/config.el -*- lexical-binding: t; -*-


;; === yasnippet ===
(use-package! yasnippet
  :defer t
  :config
  ;; remove the hack of doom
  ;; (map! :map yas-keymap "<backspace>" nil)
  (map! :leader
        :desc "yas-visit" "w[" #'yas-visit-snippet-file
        :desc "yas-new" "w]" #'yas-new-snippet)
  (setq yas-also-indent-empty-lines t)
  ;;; auto-expand
  ;; (defun my-yas-try-expanding-auto-snippets ()
  ;;   (when yas-minor-mode
  ;;     (let ((yas-buffer-local-condition ''(require-snippet-condition . auto)))
  ;;       (yas-expand))))
  ;; (add-hook 'post-command-hook #'my-yas-try-expanding-auto-snippets)

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

  (map! :leader
        :desc "math auto expand" "ia" #'dwt/math-auto-expand-yasnippet))
  



(use-package! aas
  :hook (LaTeX-mode . aas-activate-for-major-mode)
  :hook (org-mode . aas-activate-for-major-mode)
  :hook (text-mode . aas-activate-for-major-mode))
  ;; :config
  ;; disable snippets by redefining them with a nil expansion
  ;; (aas-set-snippets 'latex-mode
  ;;   "supp" nil))
(use-package! laas
  :hook (LaTeX-mode . laas-mode)
  :hook (org-mode . laas-mode)
  :config ; do whatever here
  (aas-set-snippets 'laas-mode
    ",," (lambda () (interactive)
           (unless (texmathp)
             (if (derived-mode-p 'org-mode)
                 (yas-expand-snippet "\\\\( $0 \\\\)")
                (yas-expand-snippet "$ $0 $"))))
    ",." (lambda () (interactive)
           (unless (texmathp)
            (yas-expand-snippet "\\\\[ $0  \\\\]")))
    ",q" "_"
    ",w" "^"
    ",z" ";"
    ",x" ":"
    ",c" " "
    ;; set condition!
    :cond #'texmathp ; expand only while in math
    "<<" "\\leq"
    ">>" "\\geq"
    ",<" "\\subseteq"
    "Rn" (lambda () (interactive)
           (yas-expand-snippet "\\mathbb{R}^{${0:n}}"))
    "||" (lambda () (interactive)
           (yas-expand-snippet "\\\\| $0 \\\\|"))
    ",|" (lambda () (interactive)
           (yas-expand-snippet "\\lvert $0 \\rvert"))
    "<>" (lambda () (interactive)
           (yas-expand-snippet "\\langle $0 \\rangle"))
    ;; bind to functions!
    ;; "//" (lambda () (interactive)
    ;;       (yas-expand-snippet "\\frac{ $0}{}"))
    ",n" (lambda () (interactive)
           (yas-expand-snippet "\\\\| $0 \\\\|"))
    ",e" (lambda () (interactive)
           (yas-expand-snippet "\\\\{ $0 \\\\}"))
    "''" (lambda () (interactive)
           (yas-expand-snippet "``$0''"))
    "xx" "\\times"
    "==" "& ="
    ",s" (lambda () (interactive)
           (if (derived-mode-p 'org-mode)
               (yas-expand-snippet "^{\\ast}")
             (yas-expand-snippet "^{*}")))
    ",d" "^{-1}"
    ",a" "^{\\top}"
    ",l" (lambda () (interactive)
           (yas-expand-snippet "${1:,} \\ldots $1 $0"))
    "pmx" (lambda () (interactive)
           (yas-expand-snippet "\\begin{pmatrix}$0\\end{pmatrix}"))))
