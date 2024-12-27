;;; dwt/dwt-python/autoload.el -*- lexical-binding: t; -*-

;;;###autoload
(defun dwt/run-current-py-in-vterm (arg)
  "Send current line to repl."
  (interactive "P")
  (when (string-equal (file-name-extension (buffer-name)) "py")
    (save-buffer)
    (let ((vterm-repl-name (concat "*vterm:" (buffer-name) "*"))
          (ori-file-name (buffer-name)))
      (if-let (win (get-buffer-window vterm-repl-name))
              (if (eq (selected-window) win)
                  (delete-window win)
                (select-window win)
                (when (bound-and-true-p evil-local-mode)
                  (evil-change-to-initial-state))
                (goto-char (point-max)))
            (setenv "PROOT" (or (doom-project-root) default-directory))
            (let ((buffer (get-buffer-create vterm-repl-name)))
              (with-current-buffer buffer
                (unless (eq major-mode 'vterm-mode)
                  (vterm-mode))
                (+vterm--change-directory-if-remote))
              (+popup-buffer buffer)))
      (with-current-buffer (get-buffer-create vterm-repl-name)
        (vterm-send-string (concat "python " ori-file-name))
        (unless arg
          (vterm-send-return)))
      (when arg
        (select-window (get-buffer-window vterm-repl-name))
        (evil-insert-state)))))

;;;###autoload
(defun dwt/python-run ()
  (interactive)
  (basic-save-buffer)
  (compile (format "%s %s" dwt/python-name (buffer-file-name))))

;;;###autoload
(defun dwt/python-run-in-vterm ()
  (interactive)
  (basic-save-buffer)
  (let ((fname (buffer-file-name))
        (dname (file-name-directory (buffer-file-name))))
    (unless (buffer-live-p (get-buffer "*doom:vterm-popup:main*"))
      (vterm "*doom:vterm-popup:main*"))
    (+popup-buffer (get-buffer "*doom:vterm-popup:main*"))
    (+popup/other)
    (vterm-send-string (format "%s %s" dwt/python-name fname))
    (vterm-send-return)))
