;;; dwt/dwt-complete/autoload.el -*- lexical-binding: t; -*-


;;;###autoload
(defun dwt/dired-projectile ()
  "Open dired in a project"
  (interactive)
  (unless projectile-mode (projectile-mode 1))
  (let (project-path)
    (setq project-path (consult--read  projectile-known-projects :prompt "Project: "))
    (dired project-path)))

;;;###autoload
(defun dwt/embark-insert-file-name (file)
  "Insert file name of FILE."
  (interactive "FFile: ")
  (insert (file-name-nondirectory (substitute-in-file-name file))))
