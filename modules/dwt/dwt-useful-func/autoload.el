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
