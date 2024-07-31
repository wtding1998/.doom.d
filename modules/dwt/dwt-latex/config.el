;; ;;; dwt/latex/config.el -*- lexical-binding: t; -*-


;; === latex init ===
(add-hook 'LaTeX-mode-hook 'turn-on-cdlatex)
(add-hook 'LaTeX-mode-hook 'hl-todo-mode)
(add-hook 'LaTeX-mode-hook (lambda () (interactive) (setq evil-shift-width 2)))
(use-package! cdlatex
  :defer t
  :init
  (setq cdlatex-takeover-dollar nil
        cdlatex-takeover-parenthesis nil
        cdlatex-takeover-subsuperscript nil)
  :config
  (setq cdlatex-insert-auto-labels-in-env-templates nil
        cdlatex-use-dollar-to-ensure-math nil)
  (push (list "lstlisting" "\\begin{lstlisting}\n?\n\\end{lstlisting}" ) cdlatex-env-alist-default)
  ;; (define-key cdlatex-mode-map (kbd "<C-return>") nil)
  (defun dwt/latex-indent-align ()
    (interactive)
    (call-interactively #'evil-indent)
    (call-interactively #'align))
  (map! :map cdlatex-mode-map
        :n "=" #'dwt/latex-indent-align
        :i "_" nil
        :i "^" nil))


(after! tex
  ;; (use-package! popweb
  ;;   :load-path ("~/.emacs.d/.local/straight/repos/popweb/extension/latex"
  ;;               "~/.emacs.d/.local/straight/repos/popweb")
  ;;   :config
  ;;   (require 'popweb-latex)
  ;;   (add-hook 'latex-mode-hook #'popweb-latex-mode))
  ;;; this mode show dismatch parens
  ;;; but it doesn't work will for (1,0]
  (remove-hook 'TeX-update-style-hook #'rainbow-delimiters-mode)
  ;;; use xetex ass default engin
  (setq-default TeX-engine 'xetex
                TeX-PDF-mode t)
  (setq dwt/latex-preamble-dir "~/OneDrive/Documents/research/latex_preamble/")
  ;;; auctex preview scale
  (after! preview
    (if IS-LINUX
      (setq-default preview-scale 1.4)
      (setq-default preview-scale 1.4)))
  (set-popup-rules!
    ;; '(("^\\*Python*" :side right :size 15 :select t)))
    '(("^\\*TeX Help*" :size 15)))
  (add-to-list 'TeX-command-list '("Shell Escape"
                                   "%`xelatex%(mode)%' -shell-escape %t"
                                   TeX-run-TeX
                                   nil
                                   t
                                   :help "For Minted"))

  (add-to-list 'TeX-command-list '("pdflatex"
                                   "%`pdflatex%(mode)%' --synctex=1%(mode)% %t"
                                   TeX-run-TeX
                                   nil
                                   t
                                   :help "pdflatex"))
;; (add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex --synctex=1%(mode)%' %t" TeX-run-TeX nil t)
  ;; (setq TeX-command-default "XeLaTeX"
  ;;       TeX-save-query nil
  ;;       TeX-show-compilation t)
  (add-to-list 'TeX-command-list '("DVI2PDF"
                                   "dvipdf %d"
                                   TeX-run-command
                                   nil                              ; ask for confirmation
                                   t                                ; active in all modes
                                   :help "Convert DVI->PDF"))
  (add-to-list 'TeX-command-list '("Clean auctex"
                                   "rm -rf ./.auctex-auto && rm -rf _region_.prv"
                                   TeX-run-command
                                   nil                              ; ask for confirmation
                                   t                                ; active in all modes
                                   :help "Remove .auctex dir"))
  (add-to-list 'TeX-command-list '("Clean git"
                                   "rm -rf ./.git && rm -f .gitignore"
                                   TeX-run-command
                                   nil                              ; ask for confirmation
                                   t                                ; active in all modes
                                   :help "Remove git"))
  (add-to-list 'TeX-command-list '("Copy preamble"
                                   ;; "mkdir -p preamble && cp ~/OneDrive/Documents/research/latex_preamble/*.tex ./preamble && zip -r ../%(s-filename-only).zip ./ -x ./git"
                                   "mkdir -p latex_preamble && cp ~/OneDrive/Documents/research/latex_preamble/*.tex ./latex_preamble"
                                   TeX-run-command
                                   nil                              ; ask for confirmation
                                   t                                ; active in all modes
                                   :help "Copy preamble"))
  (setq TeX-source-correlate-start-server t)
  (setq TeX-view-program-selection '((output-pdf "PDF Tools")
                                     (output-pdf "Zathura")
                                     (output-pdf "preview-pane")
                                     (output-pdf "Evince")
                                     ((output-dvi has-no-display-manager)
                                      "dvi2tty")
                                     ((output-dvi style-pstricks)
                                      "dvips and gv")
                                     (output-dvi "xdvi")
                                     (output-html "xdg-open")))
    ;; FIXME: if the cursor is in the usepackage, will get error
  (defun dwt/view-pdf-by-zathura ()
    "view pdf by pdf tools"
    (interactive)
    (let ((TeX-view-program-selection '((output-pdf "Zathura"))))
      (TeX-view)))

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

  ;; (define-and-bind-text-object "=" "\\\\sim\\|\\\\leq\\|\\\\geq\\|<\\|>\\|=\\|\\$\\|\\\\(\\|\\\\in"  "\\\\sim\\|\\\\leq\\|\\\\geq\\|<\\|>\\|=\\|\\$\\|\\\\)\\|\\\\in")
  (setq dwt/tex-pair-regex "\\\\sim\\|\\\\leq\\|\\\\geq\\|<\\|>\\|=\\|\\\\in")
  (define-and-bind-text-object "=" dwt/tex-pair-regex dwt/tex-pair-regex)

  (defun dwt/find-math-next()
    "Goto the next math environment in tex buffer."
    (interactive)
    (while (texmathp)
      (evil-forward-word-begin))
    (while (not (texmathp))
      (evil-forward-word-begin)))

  (defun dwt/find-math-prev()
    "Goto the last math environment in tex buffer."
    (interactive)
    (while (texmathp)
      (evil-backward-word-begin))
    (while (not (texmathp))
      (evil-backward-word-begin)))

  (defun dwt/insert-inline-math-env ()
    "Insert a pair of dollar when texmathp returns false. If there is a word at point, also wrap it."
    (interactive)
    (when (derived-mode-p 'tex-mode)
      (if (not (texmathp))
          (progn
            (if (thing-at-point 'word)
                (progn
                  (call-interactively #'backward-word)
                  (insert "\\(")
                  (call-interactively #'forward-word)
                  (insert "\\)")
                  (left-char 3))

              (insert "\\(\\)")
              (left-char 3)))
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
              (insert "\\(")
              (call-interactively #'forward-word)
              (insert "^{}\\)")
              (left-char 3))

          (insert "\\(^{}\\)")
          (left-char 6)))))

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
              (insert "\\(")
              (call-interactively #'forward-word)
              (insert "_{}\\)")
              (left-char 3))

          (insert "\\(_{}\\)")
          (left-char 6)))))

  ;; (defun dwt/insert-space ()
  ;;   "Wrap a single char with inline math"
  ;;   (interactive)
  ;;   (if (string-equal "-" (string (char-before (- (point) 1))))
  ;;       (insert " ")
  ;;       (progn
  ;;         (if (and (not (texmathp)) (thing-at-point-looking-at "[[:alpha:]]"))
  ;;           (let ((length-current-word (length (word-at-point))))
  ;;             (if (and (equal length-current-word 1) (not (string-equal (word-at-point) "a")) (not (string-equal (word-at-point) "I")) (not (string-equal (word-at-point) "A")))
  ;;                 (progn
  ;;                   (call-interactively #'backward-word)
  ;;                   (insert "\\( ")
  ;;                   (call-interactively #'forward-word)
  ;;                   (insert " \\)")
  ;;                   (backward-char 3))
  ;;               (insert " ")))
  ;;           (insert " ")))))

  ;; (defun dwt/insert-space ()
  ;;   "Wrap a single char with inline math"
  ;;   (interactive)
  ;;   (if (texmathp)
  ;;       (insert " ")
  ;;     (progn
  ;;       (let ((current-point-word (thing-at-point 'word)))
  ;;         (cond ((not current-point-word) (insert " "))
  ;;               ((> (length current-point-word) 1) (insert " "))
  ;;               ((not (string-match "\\([A-Za-z]\\)" current-point-word)) (insert " "))
  ;;               ((string-match "\\([aIA]\\)" current-point-word) (insert " "))
  ;;               ((not (string-equal " " (string (char-before (- (point) 1))))) (insert " "))
  ;;               (t (dwt/wrap-inline-math)))))))


  (defun dwt/insert-space ()
    "Wrap a single char with inline math"
    (interactive)
    (if (texmathp)
        (insert " ")
      (progn
        (let ((current-char (string (char-before)))
              (last-char (string (char-before (- (point) 1)))))
          (cond ((not (string-match "\\([A-Za-z]\\)" current-char)) (insert " "))
                ((string-match "\\([aIA]\\)" current-char) (insert " "))
                ((equal (line-beginning-position) (- (point) 1)) (dwt/wrap-inline-math))
                ((not (string-equal last-char " ")) (insert " "))
                (t (dwt/wrap-inline-math)))))))

  ;; (defun dwt/wrap-inline-math ()
  ;;   (if (derived-mode-p 'org-mode)
  ;;       (progn
  ;;         (backward-char)
  ;;         (insert "\\( ")
  ;;         (forward-char)
  ;;         (insert " \\)")
  ;;         (backward-char 3))
  ;;       (progn
  ;;         (backward-char)
  ;;         (insert "$ ")
  ;;         (forward-char)
  ;;         (insert " $")
  ;;         (backward-char 2))))
  (defun dwt/wrap-inline-math ()
    (backward-char)
    (insert "\\( ")
    (forward-char)
    (insert " \\)")
    (backward-char 3))

  (defun dwt/copy-next-label ()
    "Copy the next label."
    (interactive)
    (let ((pattern "\\b\\(label\\|cref\\|eqref\\)\\b")) ; Define a regular expression pattern
        (if (search-forward-regexp pattern nil t)
            (progn
              (goto-char (match-beginning 0))
              (execute-kbd-macro "f{yi{"))
          (message "No label found."))))


  (defun dwt/insert-transpose ()
    "If it's in math environment, insert a transpose, otherwise insert dollar and also wrap the word at point"
    (interactive)
    (if (texmathp)
        (progn
          (insert "^{T}"))
      (progn
        (if (thing-at-point 'word)
            (progn
              (call-interactively #'backward-word)
              (insert "$")
              (call-interactively #'forward-word)
              (insert "^{T}$"))
          (insert "$^{T}$"))
        (left-char))))

  (defun dwt/remove-command (cmd)
    "change \\cmd{...} to ..."
    (interactive "sEnter the command to remove: ")
    (save-excursion
      (evil-ex (format "%%s/\\\\%s\\\{\\(.*?\\)\\\}/\\1/g" cmd))))


  (map! :map LaTeX-mode-map
        :n "<RET>" #'dwt/TeX-save-and-run-all
        :localleader
        :desc "View" "v" #'TeX-view
        :desc "Output" "o" #'TeX-recenter-output-buffer
        :desc "Error" "e" #'TeX-next-error
        :desc "View by zathura" "d" #'dwt/view-pdf-by-zathura
        :desc "Run" "c" #'dwt/latex-file
        :desc "Run" "x" #'dwt/bibtex-latex-file
        ;; :desc "Toggle TeX-Fold" "f" #'TeX-fold-mode
        :desc "Preview Environment" "e" #'preview-environment
        :desc "Preview Buffer" "b" #'preview-buffer
        :desc "Preview at Point" "p" #'preview-at-point
        :desc "Clean preview" "R" #'preview-clearout-buffer
        :desc "Clean preview" "r" #'preview-clearout-at-point
        :desc "Master" "m" #'TeX-command-master
        ;; :desc "Input String" "s" #'dwt/insert
        :desc "Copy next label" "s" #'dwt/copy-next-label
        :desc "toc" "=" #'reftex-toc
        :desc "format" "f" #'dwt/format-latex-file
        :desc "clean" "F" #'dwt/clean-emacs-latex-file
        :desc "archieve" "A" #'dwt/archieve-latex-file
        :desc "goto label" "l" #'reftex-goto-label)

  (defun dwt/TeX-save-and-run-all ()
    (interactive)
    (save-buffer)
    (call-interactively #'TeX-command-run-all))

  (defun dwt/latex-file ()
    (interactive)
    (basic-save-buffer)
    (TeX-command "LaTeX" #'TeX-master-file))

  (defun dwt/bibtex-latex-file ()
    (interactive)
    (save-buffer)
    (TeX-command "BibTeX" #'TeX-master-file))

  (defun dwt/clean-emacs-latex-file ()
    (interactive)
    (TeX-command "Clean" #'TeX-master-file)
    (TeX-command "Clean auctex" #'TeX-master-file)
    (TeX-command "Clean git" #'TeX-master-file)
    (async-shell-command "rm -f indent.log"))

  (defun dwt/archieve-latex-file ()
    (interactive)
    (save-excursion
      (goto-char (point-min))
      (search-forward "\\string~\/OneDrive\/Documents\/research\/")
      (replace-match ""))
    (dwt/clean-emacs-latex-file)
    (call-interactively #'+format/buffer)
    (dwt/process-latex-preamble))

  (defun dwt/replace-math-deli ()
    (interactive)
    (save-excursion
      (goto-char (point-min))
      (while (search-forward "\\(" nil t)
        (replace-match "$"))
      (while (search-forward "\\)" nil t)
        (replace-match "$"))))

  (defun dwt/format-latex-file ()
    (interactive)
    (call-interactively #'dwt/replace-math-deli)
    (call-interactively #'dwt/replace-math-deli)
    (call-interactively #'+format/buffer))

  (defun dwt/latex-double-quote ()
    (interactive)
    (let ((input-key (edmacro-format-keys (vector (read-key "input:")))))
      (if (string-equal input-key "\"")
        (progn (insert "\"\"")
              (backward-char))
        (if (string-equal input-key ":")
            (insert ":")
            (if (string-equal input-key "SPC")
                (insert " ")
                (insert input-key))))))

  ; exclude spell fu faces in latex-mode
  (setf (alist-get 'latex-mode +spell-excluded-faces-alist)
        ' (font-latex-math-face
           font-latex-sedate-face
           font-lock-constant-face
           font-lock-comment-face
           font-lock-function-name-face
           font-lock-keyword-face
           font-lock-variable-name-face)))


;;;###autoload
(defun dwt/new-latex-dir-project ()
  (interactive)
  (let (project-path dir-name subdir-names)
    (setq project-path (consult-dir--pick "Switch to project: "))
    (setq subdir-names '())
    (dolist (path (f-directories project-path))
      (push (car (last (split-string path "/"))) subdir-names))
    (setq dir-name (consult--read subdir-names :prompt "New dir name: " :initial (format-time-string "%Y%m%d_")))
    (make-directory (concat project-path dir-name))
    (write-file (concat project-path dir-name "/ref.bib"))
    (write-file (concat project-path dir-name "/" dir-name ".tex"))
    (find-file (concat project-path dir-name "/" dir-name ".tex"))))

;;;###autoload
(defun dwt/new-latex-dir-default-dir ()
  (interactive)
  (let ((project-name (consult--read '() :prompt "New project name: " :initial (format-time-string "%Y%m%d_"))))
    (dwt/create-latex-project default-directory project-name)))

(defun dwt/create-latex-project (dir project-name)
  "Create a LaTeX project.
DIR is the base directory.
PROJECT-NAME is the name of the project."
  (interactive "DDirectory: \nsProject name: ")
  (let* ((project-dir (expand-file-name project-name dir))
         (bib-file (expand-file-name "ref.bib" project-dir))
         (tex-file (expand-file-name (concat project-name ".tex") project-dir)))
    ;; Create the project directory
    (unless (file-exists-p project-dir)
      (make-directory project-dir t))
    ;; Create an empty ref.bib file
    (with-temp-buffer
      (write-region (point-min) (point-min) bib-file))
    ;; Create an empty project-name.tex file
    (with-temp-buffer
      (write-region (point-min) (point-min) tex-file))
    ;; Open the project-name.tex file
    (find-file tex-file)))

(map! :leader
      :desc "New TeX dir" "ol" #'dwt/new-latex-dir-project
      :desc "New TeX dir in project" "oL" #'dwt/new-latex-dir-default-dir)

(set-company-backend! 'latex-mode '(+latex--company-backends company-dabbrev company-yasnippet))
;; set company-backends
;; default:
;; Value in #<buffer optimization.tex>
;; (company-reftex-labels company-reftex-citations
;;                        (+latex-symbols-company-backend company-auctex-macros company-auctex-environments)
;;                        company-dabbrev company-yasnippet company-ispell company-capf)
(add-to-list '+latex--company-backends #'company-yasnippet nil #'eq)
;; (add-to-list '+latex--company-backends #'company-auctex-macros nil #'eq)
(add-to-list '+latex--company-backends #'company-dabbrev nil #'eq)
(add-to-list '+latex--company-backends #'company-math-symbols-latex nil #'eq)

(after! cdlatex
  (map! :map cdlatex-mode-map
        :i "<SPC>" #'dwt/insert-space
        ;; :i "\"" #'dwt/latex-double-quote
        ;; :i "_" #'dwt/insert-subscript
        ;; :i "^" #'dwt/insert-superscript
        :i ";" #'dwt/insert-subscript
        :i ":" #'dwt/insert-superscript
        ;; :i "M-n" #'cdlatex-tab
        :nv "}" #'dwt/find-math-next
        :nv "{" #'dwt/find-math-prev)

  (defun dwt/insert (input-string)
    "Input string"
    (interactive "sEnter String: ")
    (insert input-string))

  (defun dwt/set-cdlatex-keymap ()
    "Set cdlatex-keymap. Do not know why sometimes the keymap fails"
    (interactive)
    (setq ;; cdlatex-math-symbol-prefix ?\; ;; doesn't work at the moment :(
      cdlatex-math-symbol-alist
      '( ;; adding missing functions to 3rd level symbols
        (?_    ("\\downarrow"  ""           "\\inf"))
        (?1    ("\\cup"           "\\sqrt{?}"     ""))
        (?2    ("\\cap"           "\\sqrt{?}"     ""))
        (?3    ("\\nabla"           "\\dim"  ""))
        (?4    ("\\nabla^2"           ""  ""))
        (?5    ("\\partial"           ""  ""))
        (?j    ("\\| ? \\|"           ""  ""))
        (?9    ("\\left(?\\right)"           "\\left[?\\right]"  ""))
        (?0    ("\\left\\{?\\right\\}"           "\\left[?\\right]"  ""))
        (?^    ("\\uparrow"    ""           "\\sup"))
        (?H    ("\\nabla^2"    ""           ""))
        (?T    ("\\Theta"    ""           ""))
        (?k    ("\\kappa"      ""           "\\ker"))
        (?E    ("\\exists"      "\\varnothing"           ""))
        (?m    ("\\mu"         ""           "\\lim"))
        (?c    ("\\contr{?}"             "\\circ"     "\\cos"))
        (?d    ("\\delta"      "\\partial"  "\\dim"))
        (?D    ("\\Delta"      "\\nabla"    "\\deg"))
        (?,    ("\\preceq"     ""  ""))
        ;; no idea why \Phi isnt on 'F' in first place, \phi is on 'f'.
        (?F    ("\\Phi"))
        ;; now just conveniance
        (?.    ("\\cdot" "\\dots" "\\succeq"))
        (?:    ("\\vdots" "\\ddots"))
        (?_     ("_"          ""             ""))
        (?4     ("$"          ""             ""))
        (?7     ("\\nabla "          ""             ""))
        (?i     ("\\grad "          ""             ""))
        (?*    ("\\times" "\\star" "\\ast")))
      cdlatex-math-modify-alist
      '( ;; my own stuff
        (?a    "\\mathbb"        nil          t    nil  nil)
        (?h    "\\hat"        nil          t    nil  nil)
        (?q    "\\matr"        nil          t    nil  nil)
        (?v    "\\vect"        nil          t    nil  nil)
        ;; (?t    "\\tens"        nil          t    nil  nil)
        (?T    "\\text"        nil          t    nil  nil)
        (?1    "\\tilde"           nil          t    nil  nil)
        (?2    "\\hat"           nil          t    nil  nil)
        (?3    "\\bar"           nil          t    nil  nil)
        (?l    "\\label"           "\\label"          t    nil  nil)
        (?s    "\\mathscr"           nil          t    nil  nil)
        (?A    "\\abs"           nil          t    nil  nil)))
    (when (derived-mode-p 'latex-mode)
      (call-interactively #'revert-buffer)))
  (dwt/set-cdlatex-keymap))

(after! latex
  (add-to-list 'TeX-outline-extra '("\\\\frametitle\\b" 4))

  (defun dwt/string-before-word ()
    (char-to-string (char-before (car (bounds-of-thing-at-point 'word)))))

  (defun dwt/evil-multiedit-clean-nonmath-candidate ()
    (interactive)
    (save-excursion
      (goto-char (point-min))
      (while (call-interactively #'evil-multiedit-next)
        (unless (and (texmathp) (not (string-equal "\\" (dwt/string-before-word))))
          (call-interactively #'evil-multiedit-toggle-or-restrict-region)))))

  (map! :map evil-multiedit-state-map
        "C-j" #'dwt/evil-multiedit-clean-nonmath-candidate))


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
        :n "rl" nil
        :n "r" #'reftex-toc-rescan
        :n "c" #'reftex-toc-toggle-context)
  (setq! reftex-toc-follow-mode t
         reftex-toc-split-windows-horizontally t
         reftex-toc-split-windows-fraction 0.25))

(use-package! org-latex-impatient
  :defer t
  :commands (org-latex-impatient-mode)
  ;; :hook ((org-mode . org-latex-impatient-mode))
         ;; (latex-mode . org-latex-impatient-mode))
  :init
  (map! :leader
        :desc "org-impatient" "to" #'dwt/toggle-org-latex-impatient-mode)
  :config
  (setq org-latex-impatient-tex2svg-bin
        ;; location of tex2svg executable
        "~/node_modules/mathjax-node-cli/bin/tex2svg")
;; ("\\newcommand{\\ensuremath}[1]{#1}" "\\renewcommand{\\usepackage}[2][]{}")
  (setq org-latex-impatient-user-latex-definitions '("\\newcommand{\\contr}[1]{\\mathop{\\bullet_{#1}}}"
                                                     "\\newcommand{\\tens}[1]{\\boldsymbol{\\mathcal{#1}}}"
                                                     "\\newcommand{\\grad}{\\operatorname{grad}}"
                                                     "\\newcommand{\\rank}{\\operatorname{rank}}"
                                                     "\\newcommand{\\tr}{\\operatorname{tr}}"
                                                     "\\newcommand{\\DD}{\\operatorname{D}}"
                                                     "\\newcommand{\\diag}[1]{\\operatorname{diag}\\{#1\\}}"
                                                     "\\newcommand{\\St}[1]{\\text{St}}"
                                                     "\\newcommand{\\matr}[1]{\\boldsymbol{#1}}"))

  ;; (setq org-latex-impatient-border-width 0)
  (setq dwt/org-latex-inhibit-env '("theorem" "proof" "lemma"))
  (setq org-latex-impatient-inhibit-envs (append dwt/org-latex-inhibit-env org-latex-impatient-inhibit-envs))
  (when IS-LINUX
    (setq org-latex-impatient-scale 1.2)))

;;;###autoload
(defun dwt/toggle-org-latex-impatient-mode ()
  (interactive)
  (if (bound-and-true-p org-latex-impatient-mode)
      (progn
        (unless (derived-mode-p 'org-mode)
          (hl-line-mode 1))
        (org-latex-impatient-mode -1))
      (progn
        (hl-line-mode -1)
        (org-latex-impatient-mode 1))))


(use-package! evil-tex
  :after tex
  :config
  (map! :map evil-tex-mode-map
        :n "[[" nil
        :n "]]" nil)
  (evil-tex-bind-to-env-map '(("q" . "quote")
                              ("f" "\\begin{figure}[!ht]" . "\\end{figure}")))
  (evil-tex-bind-to-delim-map '(("|" "\\|" . "\\|")))
  (cl-destructuring-bind (inner-map . outer-map)
      (if (and (boundp  'evil-surround-local-inner-text-object-map-list)
              (boundp  'evil-surround-local-outer-text-object-map-list))
          ;; deifine everything on local keymaps if evil-surround is up-to-date
          ;; i.e before https://github.com/emacs-evil/evil-surround/pull/165
          (cons evil-tex-inner-text-objects-map evil-tex-outer-text-objects-map)
        ;; pollute the global namespace if evil-surround is too old
        (cons evil-inner-text-objects-map evil-outer-text-objects-map))

    (define-key outer-map ":" 'evil-tex-a-superscript)
    (define-key outer-map ";" 'evil-tex-a-subscript)
    (define-key inner-map ":" 'evil-tex-inner-superscript)
    (define-key inner-map ";" 'evil-tex-inner-subscript))

  (setq evil-tex-surround-delimiters
    `((?m "\\(" . "\\)")
      (?M "\\[" . "\\]")
      (?$ "$" . "$")
      (?c . ,#'evil-tex-surround-command-prompt)
      (?e . ,#'evil-tex-surround-env-prompt)
      (?d . ,#'evil-tex-surround-delim-prompt)
      ;; (?' . ,#'evil-tex-surround-cdlatex-accents-prompt)
      (?q "`" . "'")
      (?Q "``" . "''")
      (?: "^{" . "}")
      (?\; "_{" . "}")
      (?T "&" . "&"))))

(use-package! bibtex
  :config
  (setq dwt/excluded-fields '("file" "langid" "abstract" "urldate" "issn" "doi"))
  (defun dwt/delete-lines-containing-excluded-fields ()
    "Delete lines containing any string from the list `dwt/excluded-fields`."
    (interactive)
    (let ((excluded-fields dwt/excluded-fields))
      (save-excursion
        (dolist (field excluded-fields)
          (goto-char (point-min))
          (while (re-search-forward (regexp-quote (concat field " = ")) nil t)
            (beginning-of-line)
            (delete-region (point) (progn (forward-line 1) (point)))))))
    (basic-save-buffer))
  (map! :map bibtex-mode-map
        :localleader
        :desc "search entry" "s" #'bibtex-search-entry
        :desc "next entry" "]" #'bibtex-next-entry
        :desc "prev entry" "[" #'bibtex-previous-entry
        :desc "delete excluded fields" "d" #'dwt/delete-lines-containing-excluded-fields)
  (map! :map bibtex-mode-map
        :desc "next entry" :n "]e" #'bibtex-next-entry
        :desc "next entry" :n "[e" #'bibtex-previous-entry)

  ;; Define the text object function
  (defun bibtex-entry-text-object (count &optional beg end type)
    "Select the BibTeX entry."
    (let ((start (save-excursion
                  (bibtex-beginning-of-entry)
                  (point)))
          (finish (save-excursion
                    (bibtex-end-of-entry)
                    (point))))
      (evil-range start finish type)))

  ;; Register the text object
  (evil-define-text-object my-evil-bibtex-entry (count &optional beg end type)
    "BibTeX entry text object."
    (bibtex-entry-text-object count beg end type))

  ;; Bind the text object to key sequences
  (define-key evil-outer-text-objects-map "E" 'my-evil-bibtex-entry)
  (define-key evil-inner-text-objects-map "E" 'my-evil-bibtex-entry))
;; (use-package! ivy-bibtex
;;   :commands (bibtex-completion-candidates)
;;   :init
;;   (setq bibtex-completion-bibliography '("~/Zotero/My Library.bib"))
;;   (run-with-idle-timer 5 nil #'bibtex-completion-candidates)
;;   :config
;;   ;; (setq bibtex-completion-notes-template-multiple-files "${=key=}\n#+filetags:paper \n${author-or-editor} (${year}): ${title}\n* ${author-or-editor} (${year}): ${title}\n")
;;   (setq bibtex-completion-notes-template-multiple-files "#+filetags:paper\n#+title:${title}\n#+OPTIONS: H:1\n* ${title}\n")
;;   (setq bibtex-completion-no-export-fields (list "language" "file" "urldate" "abstract" "keywords" "url" "note" "doi" "issn" "month" "isbn" "address"))
;;   ;; (setq bibtex-completion-bibliography '("~/org/tensor.bib" "~/org/second-optim.bib" "~/org/matrix-SD.bib" "~/org/book.bib" "~/org/manifold.bib" "~/org/optimization.bib"))
;;   (setq bibtex-completion-bibliography org-cite-global-bibliography)
;;   (setq bibtex-completion-notes-path "~/org/roam")
;;   ;; (setq bibtex-completion-library-path "~/OneDrive/zotfile")
;;   (setq bibtex-completion-library-path nil)
;;   (setq ivy-bibtex-default-action 'ivy-bibtex-edit-notes)
;;   (ivy-bibtex-ivify-action dwt/bibtex-completion-noter-attach-pdf-path dwt/ivy-bibtex-noter-attach-pdf-path)
;;   (ivy-set-actions
;;     'ivy-bibtex
;;     '(("p" ivy-bibtex-open-pdf "Open PDF")
;;       ;; ("a" ivy-bibtex-open-any "Open PDF, URL, or DOI")
;;       ("i" ivy-bibtex-insert-bibtex "Insert Bibtex")
;;       ("n" dwt/ivy-bibtex-noter-attach-pdf-path "Insert Noter Pdf Path")
;;       ("k" ivy-bibtex-insert-key "Insert Key")
;;       ("c" ivy-bibtex-insert-citation "Insert Citation")
;;       ("e" ivy-bibtex-edit-notes "Edit Notes")
;;       ("u" ivy-bibtex-open-url-or-doi "Open URL, or DOI")))
;;   (setq bibtex-completion-edit-notes-function 'dwt/bibtex-completion-edit-notes)
;;   (map! :leader :desc "open pdf" "nB" #'dwt/ivy-bibtex-open-pdf))

(use-package! citar
  :defer 20
  :init
  (setq citar-bibliography '("~/Zotero/My Library.bib")
        citar-notes-paths '("~/org/roam"))
  :config
  (map! :leader
        "nB" #'citar-open-files
        "nE" #'citar-open-entry))

(use-package! citar-org-roam
  :after (citar org-roam)
  :defer 20
  :init
  (setq citar-org-roam-note-title-template "${author} - ${title}")
  (setq citar-org-roam-capture-template-key "n")
  :config (citar-org-roam-mode 1))
