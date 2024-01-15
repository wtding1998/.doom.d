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
