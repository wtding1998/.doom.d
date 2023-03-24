;;; dwt/dwt-pdf/config.el -*- lexical-binding: t; -*-

(use-package! pdf-tools
  :hook ((pdf-tools-enabled . pdf-view-auto-slice-minor-mode)
         (pdf-tools-disabled . hide-mode-line-mode))
         ;; (pdf-tools-enabled . pdf-view-themed-minor-mode))
  :config
  (map! :map pdf-view-mode-map
        :n "t" #'pdf-view-themed-minor-mode
        :n "M" #'hide-mode-line-mode
        :n "w" #'wsl/open-in-default-program
        :n "zu" #'dwt/open-by-zathura
        :n "J" #'pdf-history-forward
        :n "K" #'pdf-history-backward
        :n "q" #'previous-buffer
        :n "Q" #'kill-current-buffer
        :n "f" #'pdf-links-action-perform
        :n "F" #'pdf-links-isearch-link
        :n "d" #'pdf-view-scroll-up-or-next-page
        :n "e" #'pdf-view-scroll-down-or-previous-page
        :n "O" #'pdf-occur
        :n "[[" nil
        :n "]]" nil
        ;; :n "-" nil
        :n "C-j" #'pdf-history-forward
        :n "C-k" #'pdf-history-backward))

(after! saveplace-pdf-view
  (map! :map pdf-view-mode-map
        :n "q" #'previous-buffer))

;;;###autoload
(defun dwt/open-by-zathura ()
  (interactive)
  (when (string-equal (file-name-extension (buffer-name)) "pdf")
    (async-shell-command (concat "zathura " (buffer-name)))))
