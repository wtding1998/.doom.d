;;; dwt/dwt-latex/autoload.el -*- lexical-binding: t; -*-


;; ;;;###autoload
;; (defun dwt/bibtex-completion-edit-notes(keys)
;;   "Open the notes associated with the entries in KEYS.
;; Creates new notes where none exist yet."
;;   (dolist (key keys)
;;     (let* ((entry (bibtex-completion-get-entry key))
;;            (year (or (bibtex-completion-get-value "year" entry)
;;                      (car (split-string (bibtex-completion-get-value "date" entry "") "-"))))
;;            (entry (push (cons "year" year) entry)))
;;       (if (and bibtex-completion-notes-path
;;                (f-directory? bibtex-completion-notes-path))
;;                                         ; One notes file per publication:
;;           (let* ((path (f-join bibtex-completion-notes-path
;;                                (s-concat key bibtex-completion-notes-extension))))
;;             (find-file path)
;;             (unless (f-exists? path)
;;               ;; First expand BibTeX variables, then org-capture template vars:
;;               (call-interactively #'org-id-get-create)
;;               (insert (bibtex-completion-fill-template
;;                        entry
;;                        bibtex-completion-notes-template-multiple-files))
;;               (let ((pdf (bibtex-completion-find-pdf key bibtex-completion-find-additional-pdfs)))
;;                 (cond
;;                   ((> (length pdf) 1)
;;                    (let* ((pdf (f-uniquify-alist pdf))
;;                           (choice (completing-read "File to attach: " (mapcar 'cdr pdf) nil t))
;;                           (file (car (rassoc choice pdf))))
;;                       (org-entry-put nil "NOTER_DOCUMENT" file)))
;;                   (pdf
;;                     (org-entry-put nil "NOTER_DOCUMENT" (car pdf)))
;;                   (t
;;                     (message "No PDF(s) found for this entry: %s"
;;                             key))))
;;               (call-interactively #'evil-force-normal-state)))))))

;; ;;;###autoload
;; (defun dwt/bibtex-completion-noter-attach-pdf-path (keys &optional fallback-action)
;;   "Open the PDFs associated with the marked entries using the function specified in `bibtex-completion-pdf-open-function'.
;; If multiple PDFs are found for an entry, ask for the one to open
;; using `completion-read'.  If FALLBACK-ACTION is non-nil, it is
;; called in case no PDF is found."
;;   (dolist (key keys)
;;     (let ((pdf (bibtex-completion-find-pdf key bibtex-completion-find-additional-pdfs)))
;;       (cond
;;        ((> (length pdf) 1)
;;         (let* ((pdf (f-uniquify-alist pdf))
;;                (choice (completing-read "File to open: " (mapcar 'cdr pdf) nil t))
;;                (file (car (rassoc choice pdf))))
;;           (org-entry-put nil "NOTER_DOCUMENT"  file)))
;;        (pdf
;;         (org-entry-put nil "NOTER_DOCUMENT" (car pdf)))
;;        (t
;;         (message "No PDF(s) found for this entry: %s"
;;                  key)))))

;; ;;;###autoload
;;   (defun dwt/ivy-bibtex-open-pdf ()
;;     "Open pdf of the choosen bibliography"
;;     (interactive)
;;     (let ((ivy-bibtex-default-action 'ivy-bibtex-open-pdf))
;;       (call-interactively #'ivy-bibtex))))


;;;###autoload
(defun dwt/collect-latex-input-files ()
  "Collect all filenames used in \\input{...} commands in the current .tex file."
  (interactive)
  (let ((file-list '()))
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "\\\\input{\\([^}]+\\)}" nil t)
        (let ((filename (match-string 1)))
          (add-to-list 'file-list filename))))
    (setq dwt/latex-input-files file-list)
    (message "Input files: %s" (mapconcat 'identity file-list ", "))))

;;;###autoload
(defun dwt/copy-latex-preamble-files ()
  "Copy the LaTeX preamble files to a directory named `latex_preamble`."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (search-forward "\\string~\/OneDrive\/Documents\/research\/")
    (replace-match ""))
  (basic-save-buffer)
  (let ((preamble-dir (expand-file-name dwt/latex-preamble-dir))
        (dest-dir (expand-file-name "latex_preamble" (file-name-directory buffer-file-name)))
        (files dwt/latex-input-files))
    (unless (file-exists-p dest-dir)
      (make-directory dest-dir))
    (dolist (file files)
      (let ((source-file (expand-file-name file preamble-dir))
            (dest-file (expand-file-name file dest-dir)))
        (if (file-exists-p source-file)
            (copy-file source-file dest-file t)
          (message "File not found: %s" source-file))))
    (message "Preamble files copied to %s" dest-dir)))

;;;###autoload
(defun dwt/process-latex-preamble ()
  "Collect LaTeX input files and copy them to the `latex_preamble` directory."
  (interactive)
  (dwt/collect-latex-input-files)
  (dwt/copy-latex-preamble-files))

;;;###autoload
(defun dwt/avy-goto-backslash-word (char &optional arg)
  "Jump to the currently visible word that starts with CHAR after a backslash (\\).
The window scope is determined by `avy-all-windows' (ARG negates it)."
  (interactive (list (read-char "char: " t)
                     current-prefix-arg))
  (avy-with avy-goto-backslash-word
    (avy-jump (concat "\\\\" (regexp-quote (string char)))
              :window-flip arg
              :beg (point-min)
              :end (point-max))))

;;;###autoload
(defun dwt/avy-goto-backslash-word-2chars (char1 char2 &optional arg)
  "Jump to the currently visible word that starts with CHAR1 and CHAR2 after a backslash (\\).
The window scope is determined by `avy-all-windows' (ARG negates it)."
  (interactive (list (read-char "First char: " t)
                     (read-char "Second char: " t)
                     current-prefix-arg))
  (avy-with avy-goto-backslash-word-2chars
    (avy-jump (concat "\\\\" (regexp-quote (string char1 char2)))
              :window-flip arg
              :beg (point-min)
              :end (point-max))))

;;;###autoload
(defun dwt/replace-cha-in-math-env (cha)
  "Find CHA in the buffer, check if it's in a math environment and not preceded by \b, then replace CHA with \bCHA."
  (interactive "sEnter the string to replace: ")  ;; Prompt for the parameter interactively
  (let ((case-fold-search nil))  ;; case-sensitive search
    (save-excursion
      (goto-char (point-min))  ;; start at the beginning of the buffer
      (while (search-forward cha nil t)  ;; Look for CHA
          ;; Check if we are inside a math environment and not preceded by \b
        (when (and (texmathp)  ;; inside a math environment
                   (not (looking-back (concat "\\\\b" cha)))  ;; check if \b is not before CHA
                   (not (looking-back (concat "\\mathcal{" cha))))  ;; check if \b is not before CHA
          ;; Move backward to before CHA and insert \b
          (forward-char (- 0 (length cha)))
          (insert "\\b"))))))

;;;###autoload
(defun dwt/replace-cha-in-math-env-for-list ()
  "Run dwt/replace-cha-in-math-env for each string in dwt/latex-rename-cha list."
  (interactive)
  (dolist (cha dwt/latex-rename-cha)  ;; Loop over each string in the list
    (dwt/replace-cha-in-math-env cha)))  ;; Call your function for each string

;;;###autoload
(defun dwt/TeX-save-and-run-all ()
  (interactive)
  (save-buffer)
  ;; (call-interactively #'TeX-command-run-all)
  (TeX-command "dwtLaTeXMk" #'TeX-master-file))

;;;###autoload
(defun dwt/latex-file ()
  (interactive)
  (TeX-save-document
   (TeX-master-file))
  (TeX-command "LaTeX" 'TeX-master-file -1))

;;;###autoload
(defun dwt/bibtex-latex-file ()
  (interactive)
  (save-buffer)
  (TeX-command "BibTeX" #'TeX-master-file))

;;;###autoload
(defun dwt/clean-emacs-latex-file ()
  (interactive)
  (TeX-command "Clean" #'TeX-master-file)
  (TeX-command "Clean auctex" #'TeX-master-file)
  (TeX-command "Clean git" #'TeX-master-file)
  (async-shell-command "rm -f indent.log"))

;;;###autoload
(defun dwt/archieve-latex-file ()
  (interactive)
  (call-interactively #'+format/buffer)
  (dwt/process-latex-preamble)
  (dwt/clean-emacs-latex-file))

;;;###autoload
(defun dwt/replace-math-deli-oneside ()
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "\\(" nil t)
      (replace-match "$"))
    (while (search-forward "\\)" nil t)
      (replace-match "$"))))

;;;###autoload
(defun dwt/replace-math-deli ()
  (interactive)
  (dwt/replace-math-deli-oneside)
  (dwt/replace-math-deli-oneside))

;;;###autoload
(defun dwt/format-latex-file ()
  (interactive)
  (call-interactively #'dwt/replace-math-deli)
  (call-interactively #'+format/buffer))

;;;###autoload
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

;;;###autoload
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

;;;###autoload
(defun dwt/insert (input-string)
  "Input string"
  (interactive "sEnter String: ")
  (insert input-string))

;;;###autoload
(defun dwt/set-cdlatex-keymap ()
  "Set cdlatex-keymap. Do not know why sometimes the keymap fails"
  (setq ;; cdlatex-math-symbol-prefix ?\; ;; doesn't work at the moment :(
    cdlatex-math-symbol-alist
    '( ;; adding missing functions to 3rd level symbols
      (?_    ("\\downarrow"  ""           "\\inf"))
      (?1    ("\\cup"           "\\sqrt{?}"     ""))
      (?2    ("\\cap"           "\\sqrt{?}"     ""))
      (?3    ("\\nabla"           "\\dim"  ""))
      (?4    ("\\nabla^2"           ""  ""))
      (?5    ("\\partial "           ""  ""))
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
      (?A    "\\abs"           nil          t    nil  nil))))

;;;###autoload
(defun dwt/set-cdlatex-keymap-manual ()
  (interactive)
  (when (derived-mode-p 'latex-mode)
    (call-interactively #'revert-buffer)
    (dwt/set-cdlatex-keymap)))

;;;###autoload
(defun dwt/string-before-word ()
  (char-to-string (char-before (car (bounds-of-thing-at-point 'word)))))

;;;###autoload
(defun dwt/evil-multiedit-clean-nonmath-candidate ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (call-interactively #'evil-multiedit-next)
      (let ((face (get-text-property (point) 'face)))
        (unless
          (if (listp face)
              (and (member 'font-latex-math-face face)
                   (not (member 'font-latex-sedate-face face))
                   (not (member 'font-lock-constant-face face)))
            (eq face 'font-latex-math-face))
        ;; (unless (and (eq (get-text-property (point) 'face) 'font-latex-math-face) (not (string-equal "\\" (dwt/string-before-word))))
          (call-interactively #'evil-multiedit-toggle-or-restrict-region))))))

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

;;; bibtex
;;;###autoload
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

;;;###autoload
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

;;;###autoload
(defun dwt/compile-latex-idle ()
  (interactive)
  (when (derived-mode-p 'latex-mode)
    (TeX-command "dwtLaTeXMk" #'TeX-master-file)))

;;;###autoload
(defun dwt/citar-open-files-by-system ()
  (interactive)
  (let ((citar-file-open-functions (list (cons t #'dwt/open-in-system))))
    (call-interactively #'citar-open-files)))

;;;###autoload
(defun dwt/open-latexmk-vterm-buffer ()
  "If the current buffer is a .tex file, create a vterm buffer named latexmk-<master-file-name>,
and send the latexmk command with the correct TeX engine."
  (interactive)
  (when (and (derived-mode-p 'tex-mode) buffer-file-name)
    ;; (let* ((master-file (TeX-master-file))
    (let* ((working-directory (file-name-directory (buffer-file-name)))
           (master-file (TeX-master-file t))
           (master-file-name (file-name-sans-extension master-file))
           (latex-vterm-buffer-name (concat "*vterm: latexmk-" (file-name-nondirectory master-file-name) "*")))
      ;; Open the vterm buffer with the appropriate name
      (if (get-buffer latex-vterm-buffer-name)
          (progn
            (+popup-buffer (get-buffer latex-vterm-buffer-name))
            (+popup/other)
            (call-interactively #'evil-insert))
          (progn
            (let* ((tex-engine (or TeX-engine 'xetex))  ;; Default to 'latex' if TeX-engine is not set
                   (tex-engine-str (pcase tex-engine
                                     ('luatex "lualatex")
                                     ('pdftex "pdflatex")
                                     (_ "xelatex")))  ;; Default fallback
                   (command (concat "latexmk -pvc -" tex-engine-str " " master-file)))
              (message (concat "Create vterm buffer:" latex-vterm-buffer-name))
              (vterm latex-vterm-buffer-name)
              ;; Change the working directory to the master file directory
              (with-current-buffer latex-vterm-buffer-name
                (vterm-send-string command))))))))

;;;###autoload
(defun dwt/latex-indent-align ()
  (interactive)
  (call-interactively #'evil-indent)
  (call-interactively #'align))
