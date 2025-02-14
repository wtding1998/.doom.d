;;; dwt/dwt-wsl2/config.el -*- lexical-binding: t; -*-

(defvar dwt/system-default "ii_wrapper")
(when IS-MAC
  ;; (setq ns-right-command-modifier 'control)
  (setq mac-command-modifier 'meta)
  (setq mac-right-command-modifier 'meta)
  (setq mac-option-modifier 'super)
  (setq mac-right-option-modifier 'super)
  (load! "modules/os/macos/autoload.el" doom-emacs-dir)
  (+macos--open-with open-in-terminal "Terminal" default-directory)
  (map! :leader
        :desc "open in terminal" "ot" #'+macos/open-in-terminal
        :desc "open externally" "ow" #'+macos/open-in-default-program
        :desc "open in finder" "oe" #'+macos/reveal-in-finder)

  (setq dwt/system-default "open")


  (defun dwt/org-screenshot ()
    "Take a screenshot into a time stamped unique-named file in the
  same directory as the org-buffer and insert a link to this file."
    (interactive)
    (org-display-inline-images)
    (setq filename
          (concat)
          (make-temp-name
            (concat (file-name-nondirectory (buffer-file-name))
                    "_imgs/"
                    (format-time-string "%Y%m%d_%H%M%S_")) ) ".png")
    (unless (file-exists-p (file-name-directory filename))
      (make-directory (file-name-directory filename)))
    ; take screenshot
    (if (eq system-type 'darwin)
        (call-process "screencapture" nil nil nil "-i" filename))
    (if (eq system-type 'gnu/linux)
        (call-process "import" nil nil nil filename))
    ; insert into file if correctly taken
    (if (file-exists-p filename)
      (insert (concat "[[file:" filename "]]")))))

;; open url by windows explorer
(when IS-LINUX
  (map! :leader
        ;; :desc "reveal in windows" "oe" #'wsl/reveal-in-explorer
        :desc "reveal in windows" "oe" #'dwt/reveal-in-explorer
        :desc "open by windows program" "ow" #'dwt/open-in-system)
  (defun system-browse-url-xdg-open (url &optional ignored)
    (interactive (browse-url-interactive-arg "URL: "))
    (message (concat dwt/system-default " " url))
    (shell-command-to-string (concat dwt/system-default " " url)))
  (advice-add #'browse-url-xdg-open :override #'system-browse-url-xdg-open)

  ;; pasted from  emacs china
  (defun dwt/yank-image-from-win-clipboard-through-powershell()
    "to simplify the logic, use c:/Users/Public as temporary directoy, then move it into current directoy

  Anyway, if need to modify the file name, please DONT delete or modify file extension \".png\",
  otherwise this function don't work and don't know the reason
  "
    (interactive)
    (let* ((powershell "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe")
           (file-name (format "%s" (read-from-minibuffer "Img Name:" (format-time-string "screenshot_%Y%m%d_%H%M%S.png"))))
          ;; (file-path-powershell (concat "c:/Users/\$env:USERNAME/" file-name))
           (file-path-wsl (concat "./images/" file-name)))
      (if (file-exists-p "./images")
          (ignore)
        (make-directory "./images"))
      (shell-command (concat powershell " -command \"(Get-Clipboard -Format Image).Save(\\\"D:/wsl-images/" file-name "\\\")\""))
      (rename-file (concat "/mnt/d/wsl-images/" file-name) file-path-wsl)
      (format "%s" file-path-wsl)))


  (defun dwt/yank-image-link-into-org-from-wsl ()
    "call `my-yank-image-from-win-clipboard-through-powershell' and insert image file link with org-mode format"
    (interactive)
    (let* ((file-path (dwt/yank-image-from-win-clipboard-through-powershell))
           (file-link (format "#+CAPTION: %s\n[[%s]]" (file-name-sans-extension (file-name-nondirectory file-path)) file-path)))

      (insert file-link)))

  (map! :leader
        :desc "yank img" "tI" #'dwt/yank-image-link-into-org-from-wsl))

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
  (shell-command (format "%s ." dwt/system-default)))

;;;###autoload
(defun dwt/open-in-system (&optional file-path)
  "Open FILE-PATH in the system's default application.
If called interactively, use the current file in Dired or the current buffer."
  (interactive)
  (let* ((path (or file-path
                   (if (derived-mode-p 'dired-mode)
                       (dired-get-filename)
                     (buffer-file-name))))
         (command (format "%s %s" dwt/system-default (shell-quote-argument path))))
    (unless path
      (user-error "No file path provided or found"))
    (message "Opening: %s" path)
    (message command)
    (shell-command-to-string command)))
