;;; dwt/dwt-python/config.el -*- lexical-binding: t; -*-

;;;###autoload
(defun dwt/send-region-to-repl (beg end &optional inhibit-auto-execute-p)
  "Execute the selected region in the REPL.
Opens a REPL if one isn't already open. If AUTO-EXECUTE-P, then execute it
immediately after."
  (interactive "rP")
  (let ((selection (buffer-substring-no-properties beg end))
        (repl-buffer (get-buffer "*Python*")))
    (unless repl-buffer
      (+python/open-repl))
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
        (+python/open-repl)
        ;; FIXME should switch to origin-window
        (other-window 1))
      ;; insert the selected region
      (with-selected-window (get-buffer-window repl-buffer)
        (with-current-buffer repl-buffer
          (dolist (line (split-string selection "\n"))
            (unless (string-equal line "")
              (insert line)
              (if inhibit-auto-execute-p
                  (insert "\n")
                ;; `comint-send-input' isn't enough because some REPLs may not use
                ;; comint, so just emulate the keypress.
                (execute-kbd-macro (kbd "RET")))
              (sit-for 0.001)
              (redisplay 'force)))
          (execute-kbd-macro(kbd "RET")))
        (when (and (eq origin-window (selected-window))
                   (bound-and-true-p evil-local-mode)))))))

(defun dwt/send-current-line-to-repl ()
  (interactive)
  (dwt/send-region-to-repl (line-beginning-position) (line-end-position)))

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

(after! python
  ;; (setq python-shell-exec-path '("home/wtding/miniconda3/bin/python"))
  ;;; pyvenv
  (if IS-LINUX
    (setenv "WORKON_HOME" "/home/wtding/miniconda3/envs")
    (setenv "WORKON_HOME" "/Users/dingwentao/miniforge3/envs"))
  (map! :map python-mode-map :localleader
        "v" #'pyvenv-workon
        "m" #'dwt/python-run)

  (defun dwt/python-run ()
    (interactive)
    (compile (format "python %s" (buffer-file-name))))

  (set-popup-rules!
    ;; '(("^\\*Python*" :side right :size 15 :select t)))
    '(("^\\*Python*" :size 15 :select t)))
  (map! :map python-mode-map :localleader "s" #'run-python
        "r" #'python-shell-send-region
        "f" #'python-shell-send-file
        "d" #'python-shell-send-defun))
(add-hook 'python-mode-hook
        (lambda ()
          (define-key global-map (kbd "S-<return>") nil)
          (define-key evil-visual-state-local-map (kbd "S-<return>") 'dwt/send-region-to-repl)
          (define-key evil-normal-state-local-map (kbd "S-<return>") 'dwt/send-current-line-to-repl)
          (define-key evil-insert-state-local-map (kbd "S-<return>") 'dwt/send-current-line-to-repl)))

;; (use-package! conda
;;   :config
;;   (when IS-MAC
;;     (setq conda-anaconda-home (expand-file-name "~/miniforge3/")
;;           conda-env-home-directory (expand-file-name "~/miniforge3/"))))

(use-package! anaconda-mode
  :config
  (set-company-backend! 'anaconda-mode '(company-anaconda company-capf company-yasnippet company-files :with company-dabbrev-code)))

(when IS-LINUX
  (use-package! elpy
    :defer t
    :commands elpy-enable
    :init
    (setq elpy-rpc-python-command "python3")
    (setq elpy-rpc-virtualenv-path 'current)))
