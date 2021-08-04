;; ;;; dwt/latex/config.el -*- lexical-binding: t; -*-


;; === latex ===
(add-hook 'LaTeX-mode-hook 'turn-on-cdlatex)
(add-hook 'LaTeX-mode-hook 'hl-todo-mode)
;; (add-hook! LaTeX-mode

;;; use xetex ass default engine
(setq-default TeX-engine 'xetex
              TeX-PDF-mode t)
;;; auctex preview scale
(after! preview
  (unless IS-MAC
    (setq-default preview-scale 2.5)))

(use-package! cdlatex
  :defer t
  :hook (cdlatex-mode . (lambda()
                          (define-key cdlatex-mode-map (kbd "(") nil)))
  :config
  (define-key cdlatex-mode-map (kbd "<C-return>") nil)
  (defun dwt/latex-indent-align ()
    (interactive)
    (call-interactively #'evil-indent)
    (call-interactively #'align))
  (map! :map cdlatex-mode-map :n "=" #'dwt/latex-indent-align))

(after! tex
  (set-popup-rules!
    ;; '(("^\\*Python*" :side right :size 15 :select t)))
    '(("^\\*TeX Help*" :size 15)))
  (add-to-list 'TeX-command-list '("Shell Escape"
                                   "%`xelatex%(mode)%' -shell-escape %t"
                                   TeX-run-TeX
                                   nil
                                   t
                                   :help "For Minted"))
  ;; (setq TeX-command-default "XeLaTeX"
  ;;       TeX-save-query nil
  ;;       TeX-show-compilation t)
 (add-to-list
  'TeX-command-list
  '("DVI2PDF"
    "dvipdf %d"
    TeX-run-command
    nil                              ; ask for confirmation
    t                                ; active in all modes
    :help "Convert DVI->PDF"))
 (setq TeX-source-correlate-start-server t)
 (if IS-MAC
   (add-to-list 'TeX-view-program-list
               '("skim"
                 ("skim "
                   (mode-io-correlate " ")
                   "%o")
                 "skim"))
   (add-to-list 'TeX-view-program-list
               '("zathura"
                 ("zathura "
                   (mode-io-correlate " ")
                   "%o")
                 "zathura"))

  (defun dwt/view-pdf-by-pdf-tools ()
    (interactive)
    "Open pdf tool for .tex file"
    (let ((f-name (file-name-sans-extension (buffer-name)))
          (f-type (file-name-extension (buffer-name))))
      (when (string= f-type "tex")
        (when (file-exists-p (concat f-name ".pdf"))
          (call-interactively #'evil-window-vsplit)
          (other-window 1)
          (find-file (concat f-name ".pdf"))))))

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
  (define-and-bind-text-object "-" "&" "&")))



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
;; TODO set \( \) to be dollar in org-mode
(defun dwt/insert-inline-math-env ()
  "Insert a pair of dollar when texmathp returns false. If there is a word at point, also wrap it."
  (interactive)
  (when (derived-mode-p 'tex-mode)
    (if (not (texmathp))
        (progn
          (if (thing-at-point 'word)
              (progn
                (call-interactively #'backward-word)
                (insert "$")
                (call-interactively #'forward-word)
                (insert "$")
                (left-char 1))
                
            (insert "$$")
            (left-char 1)))
      (progn
        (call-interactively #'cdlatex-math-modify))))
  (when (derived-mode-p 'org-mode)
    (if (not (texmathp))
        (progn
          (if (thing-at-point 'word)
              (progn
                (call-interactively #'backward-word)
                (insert "\\(")
                (call-interactively #'forward-word)
                (insert " \\)")
                (left-char 3))
                
            (insert "\\( \\)")
            (left-char 3)))
      (progn
        (call-interactively #'cdlatex-math-modify)))))

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
            (left-char 2))
            
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
            (left-char 2))
            
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

(map! :map LaTeX-mode-map
      :n "<RET>" #'(lambda () (interactive) (when (texmathp)
                                             (call-interactively #'preview-at-point))))
(map!
 :map LaTeX-mode-map
 (
  :localleader
  :desc "View" "v" #'TeX-view
  :desc "View by pdf-tools" "d" #'dwt/view-pdf-by-pdf-tools
  :desc "Run" "C" #'dwt/TeX-save-and-run-all
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
  :desc "toc" "=" #'reftex-toc))

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


;;;###autoload
(defun dwt/latex-double-quote ()
  (interactive)
  (let ((input-key (edmacro-format-keys (vector (read-key "input:")))))
    (if (string-equal input-key "\"")
        (call-interactively #'cdlatex-math-modify)
      (insert input-key))))


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
  (add-to-list 'TeX-outline-extra '("\\\\frametitle\\b" 4))
  (add-to-list '+latex--company-backends #'company-dabbrev nil #'eq)
  (add-to-list '+latex--company-backends #'company-yasnippet nil #'eq)
  ;; disable company-ispell for performance under mac
  ;; (add-to-list '+latex--company-backends #'company-ispell nil #'eq)
  (add-to-list '+latex--company-backends #'company-capf nil #'eq)
  (set-company-backend! 'latex-mode +latex--company-backends))

(map! :map cdlatex-mode-map
      ;; :i "\";" #'(lambda () (interactive) (insert ";"))
      ;; :i "\"_" #'(lambda () (interactive) (insert "_"))
      ;; :i "\"$" #'(lambda () (interactive) (insert "$"))
      ;; :i "\":" #'(lambda () (interactive) (insert ":"))
      ;; :i "\"" #'dwt/insert-inline-math-env)
      ;; :i "\"'" #'(lambda () (interactive) (insert "'"))
      :i "\"" #'dwt/latex-double-quote
      :i ";" #'dwt/insert-subscript
      :i "'" #'dwt/insert-inline-math-env
      :i ":" #'dwt/insert-superscript
      :i "M-n" #'cdlatex-tab
      :nv "}" #'dwt/find-math-next
      :nv "{" #'dwt/find-math-prev)

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
  (setq! reftex-section-levels '(("part" . 0)
                                 ("chapter" . 1)
                                 ("section" . 2)
                                 ("subsection" . 3)
                                 ("subsubsection" . 4)
                                 ("frametitle" . -3)
                                 ("paragraph" . 5)
                                 ("subparagraph" . 6)
                                 ("addchap" . -1)
                                 ("addsec" . -2)))
  (map! :map reftex-toc-map
        :n "i" #'reftex-toc-toggle-index
        :n "c" #'reftex-toc-toggle-context)
  (setq! reftex-toc-follow-mode t
         reftex-toc-split-windows-horizontally t
         reftex-toc-split-windows-fraction 0.25))
   

;;; find next or previous math environment

(use-package! org-latex-impatient
  ;; :defer t
  ;; :hook (org-mode . org-latex-impatient-mode)
  :init
  (setq org-latex-impatient-tex2svg-bin
        ;; location of tex2svg executable
        "~/node_modules/mathjax-node-cli/bin/tex2svg")
;; ("\\newcommand{\\ensuremath}[1]{#1}" "\\renewcommand{\\usepackage}[2][]{}")
  (setq org-latex-impatient-user-latex-definitions '("\\newcommand{\\contr}[1]{\\mathop{\\bullet_{#1}}}" "\\newcommand{\\tens}[1]{\\boldsymbol{\\mathcal{#1}}}" "\\newcommand{\\matr}[1]{\\boldsymbol{#1}}"))
  (setq org-latex-impatient-border-width 0)
  ;; (setq dwt/org-latex-inhibit-env '("theorem" "proof" "lemma"))
  ;; (setq org-latex-impatient-inhibit-envs (append dwt/org-latex-inhibit-env org-latex-impatient-inhibit-envs))
  (unless IS-MAC
    (setq org-latex-impatient-scale 1.5)))
;;
(after! cdlatex
  (setq ;; cdlatex-math-symbol-prefix ?\; ;; doesn't work at the moment :(
   cdlatex-math-symbol-alist
   '( ;; adding missing functions to 3rd level symbols
     (?_    ("\\downarrow"  ""           "\\inf"))
     (?2    ("^2"           "\\sqrt{?}"     ""))
     (?3    ("^3"           "\\sqrt[3]{?}"  ""))
     (?^    ("\\uparrow"    ""           "\\sup"))
     (?H    ("\\nabla^2"    ""           ""))
     (?k    ("\\kappa"      ""           "\\ker"))
     (?m    ("\\mu"         ""           "\\lim"))
     (?c    ("\\contr"             "\\circ"     "\\cos"))
     (?d    ("\\delta"      "\\partial"  "\\dim"))
     (?D    ("\\Delta"      "\\nabla"    "\\deg"))
     ;; no idea why \Phi isnt on 'F' in first place, \phi is on 'f'.
     (?F    ("\\Phi"))
     ;; now just conveniance
     (?.    ("\\cdot" "\\dots"))
     (?:    ("\\vdots" "\\ddots"))
     (?_     ("_"          ""             ""))
     (?4     ("$"          ""             ""))
     (?*    ("\\times" "\\star" "\\ast")))
   cdlatex-math-modify-alist
   '( ;; my own stuff
     (?a    "\\mathbb"        nil          t    nil  nil)
     (?q    "\\matr"        nil          t    nil  nil)
     (?t    "\\tens"        nil          t    nil  nil)
     (?1    "\\hat"           nil          t    nil  nil)
     (?s    "\\mathscr"           nil          t    nil  nil)
     (?A    "\\abs"           nil          t    nil  nil))))
