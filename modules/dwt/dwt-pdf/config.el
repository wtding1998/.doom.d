;;; dwt/dwt-pdf/config.el -*- lexical-binding: t; -*-

(use-package! pdf-view
  :hook ((pdf-tools-enabled . pdf-view-themed-minor-mode)
         (pdf-tools-enabled . pdf-view-auto-slice-minor-mode)
         (pdf-tools-enabled . hide-mode-line-mode))
  :config
  (map! :map pdf-view-mode-map
        :n "t" #'pdf-view-themed-minor-mode
        :n "M" #'hide-mode-line-mode
        :n "w" #'wsl/open-in-default-program
        :n "zu" #'dwt/open-by-zathura
        :n "J" #'pdf-history-forward
        :n "K" #'pdf-history-backward
        :n "d" #'pdf-view-scroll-up-or-next-page
        :n "e" #'pdf-view-scroll-down-or-previous-page
        :n "S" #'pdf-history-backward
        :n "D" #'pdf-history-forward
        :n "C-j" #'pdf-history-forward
        :n "C-k" #'pdf-history-backward))

;;;###autoload
(defun dwt/open-by-zathura ()
  (interactive)
  (when (string-equal (file-name-extension (buffer-name)) "pdf")
    (async-shell-command (concat "zathura " (buffer-name)))))
