;;; dwt/dwt-org/autoload.el -*- lexical-binding: t; -*-

;;;###autoload
(defun insert-property(&optional p)
      "insert PROPERTY value of pdftools link"
      (unless p (setq p "TEST"))
      (message "property passed is: %s" p)
      (let ((pvalue
               (save-window-excursion
                 (message "%s" (org-capture-get :original-buffer))
                 (switch-to-buffer (org-capture-get :original-buffer))
                 (message "retrieved property is: %s" (org-entry-get (point) p))
                 (org-entry-get (point) p))))
          pvalue))

;;;###autoload
(defun dwt/get-file-from-citekey (citekey)
  (let ((string-cite-key (symbol-name citekey)))
    (message string-cite-key)
    (car (gethash string-cite-key (citar-get-files string-cite-key)))))

;;;###autoload
(defun dwt/org-set-export-path-smart ()
  "Insert the custom #+EXPORT_FILE_NAME property after the
  :PROPERTIES: drawer's :END: line in the current Org file.
  If no :END: is found, it inserts it at the beginning of the file."
  (interactive)
  (when (string-equal (file-name-extension (buffer-file-name)) "org")
    (let* ((filename (file-name-nondirectory (buffer-file-name)))
           (basename (file-name-sans-extension filename))
           ;; Construct the full export line with the dynamic file name.
           (export-string (format "#+EXPORT_FILE_NAME: ~/my_projects/org_tex/%s.pdf\n" basename)))

      ;; Preserve the cursor position while operating on the buffer
      (save-excursion
        (goto-char (point-min))

        ;; Search for the :END: line (start of line, exact match)
        (if (re-search-forward "^:END:" nil t)
            ;; SUCCESS: :END: found.
            (progn
              (forward-line 1) ; Move past the :END: line
              (insert "\n")
              (insert export-string)
              (message "Inserted EXPORT_FILE_NAME after :END:."))

          ;; FAILURE: :END: not found. Insert at the start.
          (progn
            (goto-char (point-min))
            (insert export-string)
            (message "Inserted EXPORT_FILE_NAME at file beginning (no :END: found).")))))))
