;;; dwt/dwt-useful-func/autoload.el -*- lexical-binding: t; -*-

;;;###autoload
(defun dwt/load-last-loaded-session ()
  (interactive)
  (doom/load-session dwt/last-loaded-session))

;;;###autoload
(defun dwt/save-current-session-to-last-loaded-session ()
  (interactive)
  (when (y-or-n-p (format "save to %s ? " dwt/last-loaded-session))
    (doom/save-session dwt/last-loaded-session)))

;;;###autoload
(defun dwt/idle-save-session-quick-save ()
  "Save session in idle time after new files are opened "
  (when dwt/idle-save-session-new-file-open
    (let ((inhibit-message t))
      (doom/save-session dwt/idle-save-session-path)
      (setq dwt/idle-save-session-new-file-open nil))))

;;;###autoload
(defun dwt/load-auto-saved-session ()
  (interactive)
  (doom/load-session dwt/idle-save-session-path))

;;;###autoload
(defun dwt/load-newest-session ()
  (interactive)
  (let* ((workspace-dir (file-name-concat doom-data-dir "workspaces"))
         (files (directory-files workspace-dir t))
         (newest-file nil)
         (newest-time 0))
    (dolist (file files newest-file)
      (when (file-regular-p file)
        (let ((mod-time (float-time (file-attribute-modification-time (file-attributes file)))))
          (when (> mod-time newest-time)
            (setq newest-time mod-time)
            (setq newest-file file)))))
    (doom/load-session newest-file)))

;;;###autoload
(defun dwt/calendar-goto-tomorrow ()
  (interactive)
  (calendar-goto-today)
  (calendar-forward-day 1))

;;;###autoload
(defun dwt/grep-in-all-tex-projects ()
  (interactive)
  (consult-ripgrep "~/my_projects" " -- -t tex"));; convert string to rg or search by #...#tex

;;;###autoload
(defun dwt/grep-in-my-preamble ()
  (interactive)
  (consult-ripgrep "~/OneDrive/Documents/research/latex_preamble"))

;;;###autoload
(defun dwt/grep-newcommand-in-all-projects ()
  (interactive)
  (consult-ripgrep "~/my_projects" "\\\\newcommand "))

;;;###autoload
(defun dwt/check-and-open-magit-status ()
  "Check conditions for git repos in ~/dotfiles and ~/.config/doom, and open magit-status if any condition is met:
1. Unstaged changes.
2. Local branch is behind the remote.
3. Remote branch has commits ahead of the local branch."
  (interactive)
  (+workspace-new "Git")
  (+workspace-switch "Git")
  (dolist (repo dwt/dotfiles)
    (let ((default-directory repo))
      (call-process-shell-command "git fetch")
      (message "Opening magit-status for %s" repo)
      (magit-status repo))))

;;;###autoload
(defun dwt/unset-dedicated-and-remove-buffer ()
  "Set the current window to be not dedicated and then remove it."
  (interactive)
  (set-window-dedicated-p (selected-window) nil)  ; Set the window to be not dedicated
  (kill-buffer))  ; Remove the current window

;;;###autoload
(defun dwt/buffers-in-all-windows ()
  "Get a list of buffers displayed in all windows of the current frame."
  (let (buffers)
    (walk-windows
     (lambda (window)
       (let ((buffer (window-buffer window)))
         (unless (minibufferp buffer) ; Exclude minibuffer from the list
           (push buffer buffers)))))
    buffers))

;;;###autoload
(defun dwt/switch-to-org-buffer-window ()
  "Switches to the window displaying the first buffer with org-mode in all windows of the current frame."
  (interactive)
  (let ((buffers (dwt/buffers-in-all-windows)))
    (catch 'found-org-buffer
      (dolist (buffer buffers)
        (when (with-current-buffer buffer (derived-mode-p 'org-mode))
          (let ((org-window (get-buffer-window buffer)))
            (if org-window
                (progn
                  (select-window org-window)
                  (throw 'found-org-buffer t))
              (message "No window found displaying buffer with org-mode."))))))))

;;;###autoload
(defun dwt/download-zotero-bib ()
  "Move a file from ~/Desktop/My Library.bib to ~/Zotero/My Library.bib and replace a specific string."
  (interactive)
  (let ((source-file "~/windows_desktop/My Library.bib")
        (target-file "~/Zotero/My Library.bib")
        (source-location "D:\\OneDrive\\zotfile\\")
        (target-location "~/OneDrive/zotfile/"))
    ;; Move the file
    (rename-file source-file target-file t)
    ;; Open the target file
    (find-file target-file)
    ;; Replace the string
    (goto-char (point-min))
    (while (search-forward source-location nil t)
      (replace-match target-location))
    ;; Save the file
    (save-buffer)
    ;; Close the file
    (kill-buffer (current-buffer))
    ;; Inform the user
    (message "File moved and string replaced successfully.")))
