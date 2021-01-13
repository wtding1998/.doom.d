;;; dwt/latex/config.el -*- lexical-binding: t; -*-


;; === latex ===
(add-hook 'LaTeX-mode-hook 'turn-on-cdlatex)
(add-hook 'LaTeX-mode-hook 'hl-todo-mode)
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
                          (define-key cdlatex-mode-map (kbd "(") nil))))

(after! tex
  (add-to-list 'TeX-view-program-selection
               '(output-pdf "zathura"))
  (add-to-list 'TeX-view-program-list
               '("zathura"
                 ("zathura "
                  (mode-io-correlate " ")
                  "%o")
                 "zathura"))
  (defmacro define-and-bind-text-object (key start-regex end-regex)
    (let ((inner-name (make-symbol "inner-name"))
          (outer-name (make-symbol "outer-name")))
      `(progn
         (evil-define-text-object ,inner-name (count &optional beg end type)
           (evil-select-paren ,start-regex ,end-regex beg end type count nil))
         (evil-define-text-object ,outer-name (count &optional beg end type)
           (evil-select-paren ,start-regex ,end-regex beg end type count t))
         (define-key evil-inner-text-objects-map ,key (quote ,inner-name))
         (define-key evil-outer-text-objects-map ,key (quote ,outer-name)))))

  (define-and-bind-text-object "=" "\\\\sim\\|\\\\leq\\|\\\\geq\\|<\\|>\\|=\\|\\$\\|\\\\(\\|\\\\in"  "\\\\sim\\|\\\\leq\\|\\\\geq\\|<\\|>\\|=\\|\\$\\|\\\\)\\|\\\\in")
  ;; TODO add // in outer-name
  (define-and-bind-text-object "-" "&" "&"))



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

;; (defun dwt/insert-dollar ()
;;   (interactive)
;;   (unless (texmathp)
;;     (insert "$$")
;;     (left-char)))

(defun dwt/insert-dollar ()
  "Insert a pair of dollar when texmathp returns false. If there is a word at point, also wrap it."
  (interactive)
  (if (not (texmathp))
      (progn
        (if (thing-at-point 'word)
            (progn
              (call-interactively #'backward-word)
              (insert "$")
              (call-interactively #'forward-word)
              (insert "$")
              (left-char 1)
              )
          (insert "$$")
          (left-char 1)))
    (progn
      (call-interactively #'cdlatex-math-modify))))

(defun dwt/insert-superscript ()
  "If it's in math environment, insert a superscript, otherwise insert dollar and also wrap the word at point"
  (interactive)
  (if (texmathp)
      (progn
        (insert "^{}")
        (left-char))
    (progn
      (if (thing-at-point 'word)
          (progn
            (call-interactively #'backward-word)
            (insert "$")
            (call-interactively #'forward-word)
            (insert "^{}$")
            (left-char 2)
            )
        (insert "$^{}$")
        (left-char 4)))))

(defun dwt/insert-subscript ()
  "If it's in math environment, insert a subscript, otherwise insert dollar and also wrap the word at point"
  (interactive)
  (if (texmathp)
      (progn
        (insert "_{}")
        (left-char))
    (progn
      (if (thing-at-point 'word)
          (progn
            (call-interactively #'backward-word)
            (insert "$")
            (call-interactively #'forward-word)
            (insert "_{}$")
            (left-char 2)
            )
        (insert "$_{}$")
        (left-char 4)))))


(defun dwt/insert-transpose ()
  "If it's in math environment, insert a transpose, otherwise insert dollar and also wrap the word at point"
  (interactive)
  (if (texmathp)
      (progn
        (insert "^{t}"))
    (progn
      (if (thing-at-point 'word)
          (progn
            (call-interactively #'backward-word)
            (insert "$")
            (call-interactively #'forward-word)
            (insert "^{T}$"))
        (insert "$^{T}$"))
      (left-char))))
(map!
 :map LaTeX-mode-map
 (
  :localleader
  :desc "View" "v" #'TeX-view
  :desc "Run" "c" #'dwt/TeX-save-and-run-all
  :desc "Toggle TeX-Fold" "f" #'TeX-fold-mode
  :desc "Preview Environment" "e" #'preview-environment
  :desc "Preview Buffer" "b" #'preview-buffer
  :desc "Preview at Point" "p" #'preview-at-point
  :desc "Clean preview" "R" #'preview-clearout-buffer
  :desc "Clean preview" "r" #'preview-clearout-at-point
  :desc "Master" "m" #'TeX-command-master
  :desc "Input String" "s" #'dwt/insert
  ;; :desc "Command" "c" "TeX-command-master"
  :desc "toc" "t" #'reftex-toc))
;; test if () can separate key word in map!
;; :n "[X" #'dwt/insert-subscript

;; TODO add tex template
;; for beamer: ...
;; for paper: ...
;; for homework: ...

;;;###autoload
(defun dwt/TeX-save-and-run-all ()
  (interactive)
  (save-buffer)
  (call-interactively #'TeX-command-run-all))

;;;###autoload
(defun dwt/new-TeX-dir ()
  "Make new dir in DIR-PATH with name DIR-NAME."
  (interactive)
  (let (project-path dir-name subdir-names)
    (setq project-path (ivy-read "Switch to project: " projectile-known-projects))
    ;; TODO list only the name of dir rather than their path
    (setq subdir-names '())
    (dolist (path (f-directories project-path))
      (push (car (last (split-string path "/"))) subdir-names))
    ;; (setq dir-name (ivy-read "New dir name: " (f-directories project-path)))
    (setq dir-name (ivy-read "New dir name: " subdir-names))
    (unless (member dir-name subdir-names)
      (make-directory (concat project-path dir-name))
      (find-file (concat project-path dir-name "/" dir-name ".tex")))))

;; (defun dwt/insert-bar ()
;;   "Insert `-' in text environment, while `_{}' in math environment."
;;   (interactive)
;;   (if (texmathp)
;;       (progn (insert "_{}")
;;              (backward-char))
;;     (progn (insert "-"))))


;; (defun dwt/insert-semicolon ()
;;   "Insert `;' in text environment, while `^{}' in math environment."
;;   (interactive)
;;   (if (texmathp)
;;       (progn (insert "^{}")
;;              (backward-char))
;;     (progn (insert ";"))))


;; (defun dwt/insert-colon ()
;;   "Insert `:' in text environment, while `^{T}' in math environment."
;;   (interactive)
;;   (if (texmathp)
;;       (progn (insert "^{T}"))
;;     (progn (insert ":"))))

(map! :leader
      :desc "New TeX dir" "ol" #'dwt/new-TeX-dir)

;; set company-backends
;; default:
;; Value in #<buffer optimization.tex>
;; (company-reftex-labels company-reftex-citations
;;                        (+latex-symbols-company-backend company-auctex-macros company-auctex-environments)
;;                        company-dabbrev company-yasnippet company-ispell company-capf)
;; new:
(after! latex
  (add-to-list '+latex--company-backends #'company-dabbrev nil #'eq)
  (add-to-list '+latex--company-backends #'company-yasnippet nil #'eq)
  (add-to-list '+latex--company-backends #'company-ispell nil #'eq)
  (add-to-list '+latex--company-backends #'company-capf nil #'eq)
  (set-company-backend! 'latex-mode +latex--company-backends))




(add-hook 'LaTeX-mode-hook
          (lambda ()
                                        ; bind { and  } to next math and previous math
            (define-key evil-normal-state-local-map (kbd "}") 'dwt/find-math-next)
            (define-key evil-visual-state-local-map (kbd "}") 'dwt/find-math-next)
            (define-key evil-normal-state-local-map (kbd "{") 'dwt/find-math-prev)
            (define-key evil-visual-state-local-map (kbd "{") 'dwt/find-math-prev)))
            ;; (define-key evil-insert-state-local-map (kbd "M-\\") 'dwt/insert-dollar)
            ;; (define-key evil-insert-state-local-map (kbd "M-[") 'dwt/insert-superscript)
            ;; (define-key evil-insert-state-local-map (kbd "M--") 'dwt/insert-subscript)))
;; (define-key evil-insert-state-local-map (kbd "M-]") 'dwt/insert-transpose)
;; (define-key evil-insert-state-local-map (kbd "M-8") 'dwt/insert-star)

(map! :map TeX-mode-map
      :i ";" #'dwt/insert-subscript
      :i "\";" #'(lambda () (interactive) (insert ";"))
      :i ":" #'dwt/insert-superscript
      :i "\":" #'(lambda () (interactive) (insert ":"))
      ;; :i "\"" #'dwt/insert-dollar)
      :i "'" #'dwt/insert-dollar
      :i "\"'" #'(lambda () (interactive) (insert "'"))
      )

(setq cdlatex-math-modify-prefix (read-kbd-macro "\"\""))
;; TODO
;; add ;,:,' to cdlatex math symbol or modify list
;; to insert : in latex
;; (insert-char ?:) or (insert ":")

;;;###autoload
(defun dwt/insert (input-string)
  "Input string"
  (interactive "sEnter String: ")
  (insert input-string))

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

(use-package org-latex-impatient
  :defer t
  :hook (org-mode . org-latex-impatient-mode)
  :init
  (setq org-latex-impatient-tex2svg-bin
        ;; location of tex2svg executable
        "~/node_modules/mathjax-node-cli/bin/tex2svg")
  (setq org-latex-impatient-scale 3.0))
