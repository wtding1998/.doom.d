;;; dwt/dwt-complete/autoload.el -*- lexical-binding: t; -*-

;;;###autoload
(defun dwt/embark-insert-file-name (file)
  "Insert file name of FILE."
  (interactive "FFile: ")
  (insert (file-name-nondirectory (substitute-in-file-name file))))

;;;###autoload
(defun dwt/company-existing-commands (command &optional arg &rest ignored)
  "A `company-mode' backend for existing LaTeX commands in the current buffer."
  (interactive (list 'interactive))
  (cl-case command
    (interactive (company-begin-backend 'dwt/company-existing-commands))
    (prefix
     (let ((prefix (dwt/company-existing-commands-current-command)))
       prefix))
    (candidates
     (let ((prefix arg)
           (commands (dwt/company-existing-commands-collect arg)))
       ;; Remove the command at point from candidates
       (setq commands (remove (dwt/company-existing-commands-current-command) commands))
       (all-completions prefix commands)))))

;;;###autoload
(defun dwt/company-existing-commands-collect (prefix)
  "Collect all LaTeX commands in the current buffer that match PREFIX."
  (let (commands)
    (when prefix
      (message "Collecting commands matching prefix: %s" prefix) ;; Debug message
      (save-excursion
        (goto-char (point-min))
        (while (re-search-forward (concat "\\\\" (regexp-quote (substring prefix 1)) "[a-zA-Z]*") nil t)
          (push (match-string 0) commands))))
    (setq commands (delete-dups commands))
    commands))

;;;###autoload
(defun dwt/company-existing-commands-current-command ()
  "Return the LaTeX command prefix at point, if any."
  (save-excursion
    (let ((command (when (looking-back (rx "\\" (1+ letter)) (line-beginning-position))
                     (match-string 0))))
      command)))

;;;###autoload
(defun dwt/consult-recent-tex-file ()
  "Find recent .tex file using `completing-read'."
  (interactive)
  (let ((tex-files (seq-filter (lambda (file)
                                 (string-suffix-p ".tex" file))
                               (bound-and-true-p recentf-list))))
    (if tex-files
        (find-file
         (consult--read
          (mapcar #'consult--fast-abbreviate-file-name tex-files)
          :prompt "Find recent .tex file: "
          :sort nil
          :require-match t
          :category 'file
          :state (consult--file-preview)
          :history 'file-name-history))
      (user-error "No recent .tex files found"))))

;;;###autoload
(defun dwt/consult-recent-pdf-file ()
  "Find recent .pdf file using `completing-read'."
  (interactive)
  (let ((pdf-files (seq-filter (lambda (file)
                                 (string-suffix-p ".pdf" file))
                               (bound-and-true-p recentf-list))))
    (if pdf-files
        (find-file
         (consult--read
          (mapcar #'consult--fast-abbreviate-file-name pdf-files)
          :prompt "Find recent .pdf file: "
          :sort nil
          :require-match t
          :category 'file
          :state (consult--file-preview)
          :history 'file-name-history))
      (user-error "No recent .pdf files found"))))
