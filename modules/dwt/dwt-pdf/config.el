;;; dwt/dwt-pdf/config.el -*- lexical-binding: t; -*-
(after! pdf-tools
  (map! :map pdf-view-mode-map :n "zu" #'wsl/open-in-default-program
        :map pdf-view-mode-map :n "zU" #'dwt/open-by-zathura
        :map pdf-view-mode-map :n "J" #'pdf-view-next-page
        :map pdf-view-mode-map :n "K" #'pdf-view-previous-page
        :map pdf-view-mode-map :n "C-j" #'pdf-history-forward
        :map pdf-view-mode-map :n "C-k" #'pdf-history-backward))

;;;###autoload
(defun dwt/open-by-zathura ()
  (interactive)
  (when (string-equal (file-name-extension (buffer-name)) "pdf")
    (async-shell-command (concat "zathura " (buffer-name)))))
