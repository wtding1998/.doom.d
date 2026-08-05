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

;; 神圣座位：只保持最大编号，每次追加一条 `- [时间] 内容'
;;;###autoload
(defun dwt/sacred-seat-log ()
  "在 try_your_best.org 的 record/神圣座位 下记录一次神圣座位。
自动更新最大编号（只保留一行），并追加一条 `- [时间] 内容'。"
  (interactive)
  (let* ((file (expand-file-name "~/Library/CloudStorage/OneDrive-Personal/Documents/roam/try_your_best.org"))
         (buf (find-file-noselect file))
         (topic (read-string "What I have done: "))
         (max-n 0)
         num-line-pos)
    (with-current-buffer buf
      (goto-char (point-min))
      (unless (re-search-forward "^\\*\\* 神圣座位" nil t)
        (user-error "未找到「神圣座位」区域"))
      ;; 1. 统计最大编号，记住 number 行位置
      (while (re-search-forward "^- number \\([0-9]+\\)" nil t)
        (setq max-n (max max-n (string-to-number (match-string 1))))
        (setq num-line-pos (match-beginning 0)))
      (setq max-n (1+ max-n))
      ;; 2. 更新 number 行为最大值（没有则新建）
      (if num-line-pos
          (save-excursion
            (goto-char num-line-pos)
            (looking-at "- number [0-9]+")
            (replace-match (format "- number %d" max-n)))
        (save-excursion
          (goto-char (point-min))
          (re-search-forward "^\\*\\* 神圣座位" nil t)
          (if (re-search-forward "^\\* " nil t)
              (goto-char (match-beginning 0))
            (goto-char (point-max))
            (unless (bolp) (insert "\n")))
          (insert (format "- number %d\n" max-n))))
      ;; 3. 在子树末尾追加一条 item
      (goto-char (point-min))
      (re-search-forward "^\\*\\* 神圣座位" nil t)
      (if (re-search-forward "^\\* " nil t)
          (goto-char (match-beginning 0))
        (goto-char (point-max))
        (unless (bolp) (insert "\n")))
      (insert "- ")
      (org-insert-time-stamp nil t t)   ; ← 自动当前日期+时间
      (unless (string-empty-p topic)
        (insert " " topic))
      (insert "\n")
      (save-buffer))
    (message "神圣座位 #%d 已记录" max-n)))
