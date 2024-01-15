;;; dwt/dwt-complete/autoload.el -*- lexical-binding: t; -*-


;;;###autoload
(defun dwt/goto-recent-directory ()
  "Open recent directory with dired"
  (interactive)
  (unless recentf-mode (recentf-mode 1))
  (let ((collection
         (delete-dups
          (append (mapcar 'file-name-directory recentf-list)))))
    (ivy-read "Directories: " collection :action 'dired)))

;;;###autoload
(defun dwt/dired-projectile ()
  "Open dired in a project"
  (interactive)
  (unless projectile-mode (projectile-mode 1))
  (let (project-path)
    (setq project-path (ivy-read "Project: " projectile-known-projects))
    (dired project-path)))

;;;###autoload
(defun dwt/embark-insert-file-name (file)
  "Insert file name of FILE."
  (interactive "FFile: ")
  (insert (file-name-nondirectory (substitute-in-file-name file))))
