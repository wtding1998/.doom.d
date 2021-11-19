;;; dwt/dwt-pdf/config.el -*- lexical-binding: t; -*-
(after! pdf-tools
  (map! :map pdf-view-mode-map :n "w" #'wsl/open-in-default-program
        :map pdf-view-mode-map :n "zu" #'dwt/open-by-zathura
        :map pdf-view-mode-map :n "J" #'pdf-view-next-page
        :map pdf-view-mode-map :n "K" #'pdf-view-previous-page
        :map pdf-view-mode-map :n "d" #'pdf-view-scroll-up-or-next-page
        :map pdf-view-mode-map :n "e" #'pdf-view-scroll-down-or-previous-page
        :map pdf-view-mode-map :n "S" #'pdf-history-backward
        :map pdf-view-mode-map :n "D" #'pdf-history-forward
        :map pdf-view-mode-map :n "C-j" #'pdf-history-forward
        :map pdf-view-mode-map :n "C-k" #'pdf-history-backward))

(use-package! pdf-view
  :hook (pdf-tools-enabled . pdf-view-themed-minor-mode)
  :hook (pdf-tools-enabled . pdf-view-auto-slice-minor-mode))

;;;###autoload
(defun dwt/open-by-zathura ()
  (interactive)
  (when (string-equal (file-name-extension (buffer-name)) "pdf")
    (async-shell-command (concat "zathura " (buffer-name)))))
