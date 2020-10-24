;;; dwt/dwt-python/config.el -*- lexical-binding: t; -*-

;;;###autoload
(defun +python/send-region-to-repl (beg end &optional inhibit-auto-execute-p)
  "Execute the selected region in the REPL.
Opens a REPL if one isn't already open. If AUTO-EXECUTE-P, then execute it
immediately after."
  (interactive "rP")
  (let ((selection (buffer-substring-no-properties beg end))
        (repl-buffer (get-buffer "*Python*")))
    (unless repl-buffer
      (+python/open-ipython-repl))
    (let ((origin-window (selected-window))
          (selection
           (with-temp-buffer
             (insert selection)
             (goto-char (point-min))
             ;; deletethe empty line in the beginning
             (when (> (skip-chars-forward "\n") 0)
               (delete-region (point-min) (point)))
             ;; TODO learn the usage of `indent-rigidly'
             (indent-rigidly (point) (point-max)
                             (- (skip-chars-forward " \t")))
             ;; Trim string of trailing string matching REGEXP and add new line
             (concat (string-trim-right (buffer-string))
                     "\n"))))
      ;; open new window if the window of repl not open
      ;; if create new window, the cursor till fouc to repl finally
      (unless (window-valid-p (get-buffer-window "*Python*"))
        (+python/open-ipython-repl)
        ;; FIXME should switch to origin-window
        (other-window 1))
      ;; insert the selected region
      (with-selected-window (get-buffer-window repl-buffer)
        (with-current-buffer repl-buffer
          (dolist (line (split-string selection "\n"))
            (insert line)
            (if inhibit-auto-execute-p
                (insert "\n")
              ;; `comint-send-input' isn't enough because some REPLs may not use
              ;; comint, so just emulate the keypress.
              (execute-kbd-macro (kbd "RET")))
            (sit-for 0.001)
            (redisplay 'force)))
        (when (and (eq origin-window (selected-window))
                   (bound-and-true-p evil-local-mode)))))))

;;;###autoload
(defun +python/send-current-line-to-repl ()
  "Send current line to repl."
  (interactive)
  (+python/send-region-to-repl (line-beginning-position) (line-end-position)))

(add-hook 'python-mode-hook
          (lambda ()
            (define-key global-map (kbd "S-<return>") nil)
            (define-key evil-visual-state-local-map (kbd "S-<return>") '+python/send-region-to-repl)
            (define-key evil-normal-state-local-map (kbd "S-<return>") '+python/send-current-line-to-repl)
            (define-key evil-insert-state-local-map (kbd "S-<return>") '+python/send-current-line-to-repl)))
