;;; dwt/dwt-wsl2/config.el -*- lexical-binding: t; -*-

;; open url by windows explorer
(defun wsl-browse-url-xdg-open (url &optional ignored)
  (interactive (browse-url-interactive-arg "URL: "))
  (shell-command-to-string (concat "explorer.exe " url)))
(advice-add #'browse-url-xdg-open :override #'wsl-browse-url-xdg-open)

;; ;;;###autoload
;; (defmacro wsl--open-with (id &optional app dir)
;;   `(defun ,(intern (format "wsl/%s" id)) ()
;;      (interactive)
;;      (wsl-open-with ,app ,dir)))

;; ;;;###autoload
;; (defun wsl-open-with (&optional app-name path)
;;   "Send PATH to APP-NAME on WSL."
;;   (interactive)
;;   (let* ((path (expand-file-name
;;                 (replace-regexp-in-string
;;                  "'" "\\'"
;;                  (or path (if (derived-mode-p 'dired-mode)
;;                               (dired-get-file-for-visit)
;;                             (buffer-file-name)))
;;                  nil t)))
;;          (command (format "%s `wslpath -w %s`" (shell-quote-argument app-name) path)))
;;     (message command)
;;     (shell-command-to-string command)))

;; (wsl--open-with open-in-default-program "explorer.exe" buffer-file-name)
;; (wsl--open-with reveal-in-explorer "explorer.exe" default-directory)

;;;###autoload
(defun dwt/reveal-in-explorer ()
  (interactive)
  (shell-command "explorer.exe ."))

;;;###autoload
(defun dwt/open-in-windows ()
  (interactive)
  (let* ((file-path (if (derived-mode-p 'dired-mode)
                        (dired-get-filename)
                        (buffer-file-name)))
         (file-name (file-name-nondirectory file-path))
         (command (format "explorer.exe %s" file-name)))
    (shell-command-to-string command)))

(map! :leader
      ;; :desc "reveal in windows" "oe" #'wsl/reveal-in-explorer
      :desc "reveal in windows" "oe" #'dwt/reveal-in-explorer
      :desc "open by windows program" "ow" #'dwt/open-in-windows)
