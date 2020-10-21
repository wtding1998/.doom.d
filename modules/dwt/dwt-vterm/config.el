;;; dwt/vterm/config.el -*- lexical-binding: t; -*-

(defun xah-copy-line-or-region ()
  "Copy current line, or text selection.
  When called repeatedly, append copy subsequent lines.
  When `universal-argument' is called first, copy whole buffer (respects `narrow-to-region').

  URL `http://ergoemacs.org/emacs/emacs_copy_cut_current_line.html'
  Version 2017-03-17"
  ;; (interactive)
  (let (-p1 -p2)
    (if current-prefix-arg
        (setq -p1 (point-min) -p2 (point-max))
      (if (use-region-p)
          (setq -p1 (region-beginning) -p2 (region-end))
        (setq -p1 (line-beginning-position) -p2 (line-end-position))))
    (if (eq last-command this-command)
        (progn (progn ; hack. exit if there's no more next line
             (end-of-line) (forward-char) (backward-char))
           ;; (push-mark (point) "NOMSG" "ACTIVATE")
           (kill-append "\n" nil)
           (kill-append (buffer-substring-no-properties (line-beginning-position) (line-end-position)) nil)
           (message "Line copy appended"))
      (progn (kill-ring-save -p1 -p2)))))

(defun vterm-repl-yank (arg)
  "Copy the reion or current line and yank it in vterm-repl."
  (interactive "P")
  (xah-copy-line-or-region)
  (let ((vterm-repl-name (concat "*vterm-repl:" (file-name-extension (buffer-name)) "*")))
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
            (pop-to-buffer buffer)))
    (vterm-yank)
    (vterm-send-return)
    (when arg
      (evil-window-next 1))))

;; (after! vterm
;;   (define-key vterm-mode-map (kbd "C-c C-l") 'vterm-send-C-l)
;;   )
