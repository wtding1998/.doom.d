;;; dwt/dwt-pdf/config.el -*- lexical-binding: t; -*-
(after! pdf-tools
  (map! :map pdf-view-mode-map :n "zu" #'wsl/open-in-default-program
        :map pdf-view-mode-map :n "zU" #'dwt/open-by-zathura))

;;;###autoload
(defun dwt/open-by-zathura ()
  (interactive)
  (when (string-equal (file-name-extension (buffer-name)) "pdf")
    (async-shell-command (concat "zathura " (buffer-name)))))
