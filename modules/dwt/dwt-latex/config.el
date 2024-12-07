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
    '(("^\\*TeX Help*" :size 15)))

  (add-to-list 'TeX-engine-alist '(pdftex "PdfTeX" "pdftex" "pdflatex" "pdftex"))
  ;; HACK: force the output extension to be pdf. To fix the issue where it is xdv casued by latexmk -xelatex
  (defun dwt/TeX-output-extension-override (&rest _args)
    "Advice to make `TeX-output-extension` always return \"pdf\"."
    "pdf")

  (advice-add 'TeX-output-extension :override #'dwt/TeX-output-extension-override)
  (add-to-list 'TeX-command-list '("dwtLaTeXMk"
                                   "latexmk -%(latex) %t"
                                   TeX-run-TeX
                                   nil
                                   t
                                   :help "Run my latexmk"))
  (add-to-list 'TeX-command-list '("Shell Escape"
                                   "%`xelatex%(mode)%' -shell-escape -interaction=nonstopmode %t"
                                   TeX-run-TeX
                                   nil
                                   t
                                   :help "For Minted"))

  (add-to-list 'TeX-command-list '("pdflatex"
                                   "%`pdflatex%(mode)%' -synctex=1 -interaction=nonstopmode %t"
                                   TeX-run-TeX
                                   nil
                                   t
                                   :help "pdflatex"))
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
  (add-to-list 'TeX-view-program-selection '(output-pdf "PDF Tools"))
  (add-to-list 'TeX-view-program-selection '(output-pdf "Sioyek"))
  ; deal with file name with space by add "" around %1
  (add-to-list 'TeX-view-program-list '("Sioyek" "sioyek %o --forward-search-file \"%b\" --forward-search-line %n --inverse-search \"emacsclient +%2 \\\"%1\\\"\""))
  (setq TeX-debug-warnings nil)
  ;; (setq TeX-debug-bad-boxes t)
  (run-with-idle-timer 10 t #'dwt/compile-latex-idle)
  (defun dwt/view-pdf-by-the-other-viewer ()
    "view pdf by pdf tools"
    (interactive)
    (let ((inhibit-message t))
      (dwt/toggle-view-program)
      (TeX-view)
      (dwt/toggle-view-program)))

  (defun dwt/toggle-view-program ()
    "Toggle view program between first and second viewer"
    (interactive)
    (let ((first (nth 0 TeX-view-program-selection))
          (second (nth 1 TeX-view-program-selection)))
      (setq TeX-view-program-selection
            (cons second
                  (cons first
                        (nthcdr 2 TeX-view-program-selection))))
     (message "%s" (car TeX-view-program-selection))))

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
    "change \\cmd{xxx} to xxx"
    (interactive "sEnter the command to remove: ")
    (save-excursion
      (evil-ex (format "%%s/\\\\%s\\\{\\(.*?\\)\\\}/\\1/g" cmd))))

;;; latex mode map
  (map! :map LaTeX-mode-map
        :n "<RET>" #'dwt/TeX-save-and-run-all
        :localleader
        :desc "View" "v" #'TeX-view
        :desc "Output" "o" #'TeX-recenter-output-buffer
        :desc "View by the other" ";" #'dwt/view-pdf-by-the-other-viewer
        :desc "Run" "c" #'dwt/latex-file
        :desc "Bibtex" "b" #'dwt/bibtex-latex-file
        :desc "Toggle view" "t" #'dwt/toggle-view-program
        ;; :desc "Toggle TeX-Fold" "f" #'TeX-fold-mode
        :desc "Preview Environment" "e" #'TeX-error-overview
        :desc "Preview Buffer" "B" #'preview-buffer
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

  ; exclude spell fu faces in latex-mode
  (setf (alist-get 'latex-mode +spell-excluded-faces-alist)
        ' (font-latex-math-face
           font-latex-sedate-face
           font-lock-constant-face
           font-lock-comment-face
           font-lock-function-name-face
           font-lock-keyword-face
           font-lock-variable-name-face)))



(map! :leader
      :desc "New TeX dir" "ol" #'dwt/new-latex-dir-project
      :desc "New TeX dir in project" "oL" #'dwt/new-latex-dir-default-dir)

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
        :nv "{" #'dwt/find-math-prev
        :nv "g\\" #'dwt/avy-goto-backslash-word
        :nv "g|" #'dwt/avy-goto-backslash-word-2chars))

(after! reftex
  (set-company-backend! 'reftex-mode 'company-reftex-labels 'company-reftex-citations '(+latex-symbols-company-backend company-auctex-symbols
                                                                                        company-dabbrev company-yasnippet dwt/company-existing-commands)))

(after! latex
  (setq dwt/latex-rename-cha '("X" "Y" "Z" "I"))
  (add-to-list 'TeX-outline-extra '("\\\\frametitle\\b" 4))
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
  (map! :map bibtex-mode-map
        :localleader
        :desc "search entry" "s" #'bibtex-search-entry
        :desc "next entry" "]" #'bibtex-next-entry
        :desc "prev entry" "[" #'bibtex-previous-entry
        :desc "delete excluded fields" "d" #'dwt/delete-lines-containing-excluded-fields)
  (map! :map bibtex-mode-map
        :desc "next entry" :n "]e" #'bibtex-next-entry
        :desc "next entry" :n "[e" #'bibtex-previous-entry)

  ;; Register the text object
  (evil-define-text-object my-evil-bibtex-entry (count &optional beg end type)
    "BibTeX entry text object."
    (bibtex-entry-text-object count beg end type))


  (evil-define-text-object evil-bibtex-key-object (count &optional beg end type)
    "Select the BibTeX key at point."
    (let ((start (save-excursion
                  (when (re-search-backward "@\\w+{" nil t) ; Move to the start of the BibTeX entry
                    (search-forward "{") ; Move to the start of the BibTeX key
                    (point))))
          (end (save-excursion
                (when (and (re-search-backward "@\\w+{" nil t)
                          (search-forward "{")) ; Find the start of the key
                  (re-search-forward "," nil t) ; Find characters up to the comma or end brace
                  (point)))))
      (if (and start end)
          (evil-range start (1- end) type) ; Adjust end to exclude the comma
        (user-error "No BibTeX key found"))))

  ;; Bind the text object to key sequences
  (define-key evil-outer-text-objects-map "E" 'my-evil-bibtex-entry)
  (define-key evil-inner-text-objects-map "E" 'my-evil-bibtex-entry)
  (define-key evil-outer-text-objects-map "K" 'evil-bibtex-key-object)
  (define-key evil-inner-text-objects-map "K" 'evil-bibtex-key-object))
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
        "nE" #'citar-open-entry)
  (setq citar-templates
    '((main . "${author editor:30%sn}     ${date year issued:4}     ${title:48}")
      (suffix . "          ${=key= id:15}    ${=type=:12}")
      (preview . "${author editor:%etal} (${year issued date}) ${title}, ${journal journaltitle publisher container-title collection-title}.\n")
      (note . "Notes on ${author editor:%etal}, ${title}"))))

(use-package! citar-org-roam
  :after (citar org-roam)
  :defer 20
  :init
  (setq citar-org-roam-note-title-template "${author} - ${title}")
  (setq citar-org-roam-capture-template-key "n")
  :config (citar-org-roam-mode 1))
