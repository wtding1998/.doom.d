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
