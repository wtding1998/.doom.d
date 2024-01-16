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


(defun dwt/get-file-from-citekey (citekey)
  (let ((string-cite-key (symbol-name citekey)))
    (message string-cite-key)
    (car (gethash string-cite-key (citar-get-files string-cite-key)))))
