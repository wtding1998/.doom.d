;;; dwt/dwt-use/config.el -*- lexical-binding: t; -*-

;;; TODO write the configuration of how to enter certain files quickly.

;; (defun dwt/create-config-links (label link)
;;   (insert label ": ")
;;   (insert-button link
;;                  'action (lambda (_) (find-file link))
;;                  'follow-link t)
;;   (insert "\n"))

;; (defun dwt/quick-open-configuration ()
;;   (interactive)
;;   (let ((buf (get-buffer-create "*Config Links*"))
;;         (configs '(("ZSH" . "~/.zshrc")
;;                    ("Doom" . "~/.doom.d")
;;                    ("Vanilia" . "~/.emacs.d.vanilia")
;;                    ("Emacs" . "~/.emacs.d")
;;                    )))
;;     (with-current-buffer buf
;;       (erase-buffer)
;;       (insert "My own configuration file :\n")
;;       (dolist (config configs)
;;         (dwt/create-config-links (car config) (cdr config)))
;;       (pop-to-buffer buf t))))

;;;###autoload
;; (defun dwt/ivy-open-configuration ()
;;   (interactive)
;;   (let ((configs '("~/.zshrc"
;;                    "~/.vim/init"
;;                    "~/.config/kitty/kitty.conf"
;;                    "~/.doom.d/"
;;                    "~/.config/zathura/zathurarc"
;;                    "~/.config/fcitx/rime/default.custom.yaml"
;;                    "~/.config/ranger/rifle.conf"
;;                    "~/.emacs.d.vanilia/init.el"
;;                    "~/Library/Preferences/DOSBox-X 0.83.23 Preferences"
;;                    "/mnt/c/Users/56901/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1"
;;                    "~/.emacs.d/"
;;                    "~/.config")))
;;     (ivy-read "Open Configs: " configs :action 'find-file)))
;; (map! :leader :desc "Open configuration" "oP" #'dwt/ivy-open-configuration)

(setq dwt/recentf-exculde-files '("roam/"))
;;;###autoload
(defun dwt/clean-recentf ()
  "Clean roam files in recentf list."
  (interactive)
  (let ((recentf-exclude dwt/recentf-exculde-files))
    (recentf-cleanup)))

;;; proxy
;; (setq dwt/proxy "http://172.29.80.1:1081")
;; (defun show-proxy ()
;;   "Show http/https proxy."
;;   (interactive)
;;   (if url-proxy-services
;;       (message "Current proxy is \"%s\"" dwt/proxy)
;;     (message "No proxy")))

;; (defun set-proxy ()
;;   "Set http/https proxy."
;;   (interactive)
;;   (setq url-proxy-services `(("http" . ,dwt/proxy)
;;                              ("https" . ,dwt/proxy)))
;;   (show-proxy))

;; (defun unset-proxy ()
;;   "Unset http/https proxy."
;;   (interactive)
;;   (setq url-proxy-services nil)
;;   (show-proxy))

;; (defun toggle-proxy ()
;;   "Toggle http/https proxy."
;;   (interactive)
;;   (if url-proxy-services
;;       (unset-proxy)
;;     (set-proxy)))

;; https://emacs-china.org/t/topic/5507
;; add path
(when IS-MAC
  ;; (condition-case err
  ;;     (let ((path (with-temp-buffer
  ;;                   (insert-file-contents-literally "~/.path")
  ;;                   (buffer-string))))
  ;;       (setenv "PATH" path)
  ;;       (setq exec-path (append (parse-colon-path path) (list exec-directory))))
  ;;   (error (warn "%s" (error-message-string err))))

  (use-package! netease-cloud-music
    :defer t
    :commands (netease-cloud-music)
    :init
    (map! :leader
          :desc "music" "tm" #'netease-cloud-music)
    :config
    (setq netease-cloud-music-repeat-mode "playlist")
    (map! :leader
          "tn" #'netease-cloud-music-play-next-song
          "tp" #'netease-cloud-music-play-previous-song
          "tR" #'netease-cloud-music-random-play
          "tx" #'netease-cloud-music-pause-or-continue
          "t/" #'netease-cloud-music-ask-play)
    (map! :map netease-cloud-music-mode-map
          :n "<RET>" #'netease-cloud-music-play-song-at-point
          :n "n" #'netease-cloud-music-play-next-song
          :n "p" #'netease-cloud-music-play-previous-song
          :n "N" #'netease-cloud-music-random-play
          :n "f" #'netease-cloud-music-search-song
          :n "F" #'netease-cloud-music-search-playlist
          :n "x" #'netease-cloud-music-pause-or-continue
          :n "X" #'netease-cloud-music-kill-current-song
          :n "q" #'netease-cloud-music-back
          :n "Q" #'netease-cloud-music-close
          :n "/" #'netease-cloud-music-ask-play
          :n "c" #'netease-cloud-music-change-lyric-type
          :n "r" #'netease-cloud-music-change-repeat-mode
          :n "<tab>" #'netease-cloud-music-toggle-playlist-songs)))


;; weather
;; (defun dwt/weather ()
;;   "weather based on https://github.com/chubin/wttr.in."
;;   (interactive)
;;   (eww "zh-cn.wttr.in/longgang?TAFm"))

;; speed type
(use-package! speed-type
  :commands (speed-type-buffer
             speed-type-text))
(if IS-LINUX
    (setq dwt/emacs-config-dir "~/.config/emacs/")
  (setq dwt/emacs-config-dir "~/.emacs.d/"))
(setq dwt/repos-dir (concat dwt/emacs-config-dir ".local/straight/repos/"))
;;;###autoload
(defun dwt/goto-package-dir ()
  (interactive)
  (let* ((packages (directory-files dwt/repos-dir))
         (package-name (consult--read packages :prompt "Packages: "))
         (package-path (concat dwt/repos-dir package-name)))
    (find-file package-path)))

(if IS-LINUX
  (setq dwt/freqneutly-used-directories '("~/Downloads/" "~/Pictures/screenshot/" "~/windows_desktop/"))
  (setq dwt/freqneutly-used-directories '("~/Downloads/")))

(defun dwt/copy-file-from-screenshot-download()
  (interactive)
  (let (files-path new-files-path new-file-name file-path old-file-name extension-name)
    (dolist (directory-path dwt/freqneutly-used-directories)
      (setq new-files-path (directory-files directory-path 'full))
      (setq files-path (append new-files-path files-path)))
    (setq file-path (consult--read files-path :prompt "File Path: "))
    (setq old-file-name (file-name-nondirectory file-path))
    (setq extension-name (file-name-extension old-file-name))
    (setq new-file-name (consult--read (list (file-name-sans-extension old-file-name)) :prompt "New Name: "))
    (copy-file file-path (expand-file-name (concat new-file-name "." extension-name)))))


;;image cut settings
(defun dwt/org-download-clipboard-through-powershell()
  "to simplify the logic, use c:/Users/Public as temporary directoy, and move it into current directoy"
  (interactive)
  (let* ((powershell "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe")
         (file-name (format-time-string "screenshot_%Y%m%d_%H%M%S.png"))
         ;; (file-path-powershell (concat "c:/Users/\$env:USERNAME/" file-name))
         (file-path-wsl (concat "/mnt/d/Documents/screenshots/" file-name)))

    ;; (shell-command (concat powershell " -command \"(Get-Clipboard -Format Image).Save(\\\"C:/Users/\\$env:USERNAME/" file-name "\\\")\""))
    (shell-command (concat powershell " -command \"(Get-Clipboard -Format Image).Save(\\\"D:/Documents/screenshots/" file-name "\\\")\""))
    (if (file-exists-p file-path-wsl)
        (progn
          (org-indent-line)
          (insert (concat "#+ATTR_LATEX: :width 0.5\\textwidth\n"))
          (insert (concat "[[file:" file-path-wsl "]] ")))
      (message "No image exists"))))

(defun dwt/new-window-dir ()
  "open the current dir, and choose new dir in a new window"
  (interactive)
  (find-file ".")
  (evil-window-vsplit)
  (call-interactively #'consult-dir))


(defun dwt/new-window-dir-new-workspce ()
  "open the current dir, and choose new dir in a new window in the new workspace"
  (interactive)
  (let ((current-dir default-directory))
    (+workspace/new)
    (find-file current-dir)
    (evil-window-vsplit)
    (call-interactively #'consult-dir)))


(map! :leader :desc "goto package dir" "hG" #'dwt/goto-package-dir
              :desc "move screenshot" "f1" #'dwt/copy-file-from-screenshot-download
              :desc "org download screenshot" "f2" #'dwt/org-download-clipboard-through-powershell
              :desc "new window dir" "f3" #'dwt/new-window-dir
              :desc "new window dir workspace" "f4" #'dwt/new-window-dir-new-workspce)

;; ;;;###autoload
;; (defun dwt/replace-path ()
;;   (interactive)
;;   (save-excursion
;;     (goto-char (point-min))
;;     (while (search-forward "\\\\" nil t)
;;       (replace-match "$"))
;;     (while (search-forward "\\)" nil t)
;;       (replace-match "$"))))

;;;###autoload
(defun dwt/replace-newline-by-space-point (p1 p2)
    (narrow-to-region p1 p2)
    (goto-char (point-min))
    (save-excursion
      (while (search-forward "\n" nil t)
        (replace-match " ")))
    (widen))

;;;###autoload
(defun dwt/replace-newline-by-space ()
  (interactive)
  (if (use-region-p)
      (dwt/replace-newline-by-space-point (region-beginning) (region-end))
      (dwt/replace-newline-by-space-point (point) (point-max))))

(map! :leader "omr" #'dwt/replace-newline-by-space)
(map! :leader "o_" #'calendar)
(map! :leader "o-" #'+calendar/open-calendar)
;; (re-search-forward "D\\\\:\\\\\\\\OneDrive\\\\\\\\Documents\\\\\\\\zotero\\\\\\\\storage\\\\\\\\")
;; (anzu-query-replace-regexp \\\\OneDrive\\\\Documents\\\\zotero\\\\storage\\\\\([A-Z0-9]+\)\\\\)

(use-package! fanyi
  :defer t
  :commands (fanyi-dwim)
  :init
  (map! :leader
        :desc "fanyi" "te" #'fanyi-dwim
        :desc "osx-dict" "tE" #'osx-dictionary-search-input))

(use-package! jieba
  :defer t
  :commands (jieba-mode))

(use-package! chatgpt
  :defer t
  :init (map! :leader
              :desc "query" "tq" #'chatgpt-query)
  :config
  (unless (boundp 'python-interpreter)
    (defvaralias 'python-interpreter 'python-shell-interpreter))
  (setq chatgpt-repo-path (expand-file-name "straight/repos/ChatGPT.el/" doom-local-dir))
  (setq chatgpt-query-format-string-map '(
                                          ;; ChatGPT.el defaults
                                          ("doc" . "Please write the documentation for the following function.\n\n%s")
                                          ("bug" . "There is a bug in the following function, please help me fix it.\n\n%s")
                                          ("understand" . "What does the following function do?\n\n%s")
                                          ("improve" . "Please improve the following code.\n\n%s")
                                          ;; your new prompt
                                          ("my-custom-type" . "My custom prompt.\n\n%s")))
  (set-popup-rule! (regexp-quote "*ChatGPT*")
    :side 'bottom :size .5 :ttl nil :quit t :modeline nil))

;; (use-package! typing
;;   :load-path "~/mycode/emacs-tying"
;;   :commands (typing-of-emacs))
(use-package! cliphist
  :config
  (map! :leader
        :desc "cliphist-paste" "s[" #'cliphist-paste-item
        :desc "cliphist-select" "s]" #'cliphist-select-item))

;;;###autoload
(defun dwt/open-with-vscode ()
  "Open current file with vscode. https://emacs-china.org/t/leader-vscode/19166/28"
  (interactive)
  (let ((line (number-to-string (line-number-at-pos)))
        (column (number-to-string (current-column))))
    (apply 'call-process "code" nil nil nil (list (concat buffer-file-name ":" line ":" column) "--goto"))))

(map! :n "gV" #'dwt/open-with-vscode)

;;;###autoload
(defun dwt/remove-package-dir ()
  "Remove the el and elc files of a package in Doom Emacs."
  (interactive)
  (let* ((repos-dir "~/.emacs.d/.local/straight/repos/")
         (build-dir "~/.emacs.d/.local/straight/build-29.0.91/")
         (packages (directory-files repos-dir))
         (package-name (consult--read packages :prompt "Package Name: "))
         (package-path (concat repos-dir package-name))
         (build-path (concat build-dir package-name)))
    (delete-directory package-path t t)
    (delete-directory build-path t t)))

;;; magit
(after! magit
  ;; control the initial state of each part
  ;; https://emacs-china.org/t/magit-magit-status/24181
  (setq magit-section-initial-visibility-alist
    '((stashes . hide)
      (untracked . hide)
      (unstaged . show)
      (unpushed . show)
      (unpulled . show)))
  (setq magit-status-initial-section '(2))
  (setq-default magit-diff-refine-hunk 'all)
  (add-hook 'magit-mode-hook #'(lambda () (interactive) (visual-line-mode 1))))

;;;###autoload
(defun dwt/buffers-in-all-windows ()
  "Get a list of buffers displayed in all windows of the current frame."
  (let (buffers)
    (walk-windows
     (lambda (window)
       (let ((buffer (window-buffer window)))
         (unless (minibufferp buffer) ; Exclude minibuffer from the list
           (push buffer buffers)))))
    buffers))

;;;###autoload
(defun dwt/switch-to-org-buffer-window ()
  "Switches to the window displaying the first buffer with org-mode in all windows of the current frame."
  (interactive)
  (let ((buffers (dwt/buffers-in-all-windows)))
    (catch 'found-org-buffer
      (dolist (buffer buffers)
        (when (with-current-buffer buffer (derived-mode-p 'org-mode))
          (let ((org-window (get-buffer-window buffer)))
            (if org-window
                (progn
                  (select-window org-window)
                  (throw 'found-org-buffer t))
              (message "No window found displaying buffer with org-mode."))))))))

(use-package! titlecase
  :init
  (map! :v "gC" #'titlecase-region)
  (map! :n "gC" #'titlecase-sentence)
  :config
  ;; (setq titlecase-style 'sentence)
  (setq titlecase-style 'wikipedia)
  (setq titlecase-dwim-non-region-function 'titlecase-sentence))

(use-package! atomic-chrome
  :defer t
  :config
  (atomic-chrome-start-server)
  (setq atomic-chrome-default-major-mode 'python-mode)
  (setq atomic-chrome-extension-type-list '(ghost-text))
  ;;(atomic-chrome-start-httpd)
  (setq atomic-chrome-server-ghost-text-port 4001)
  (setq atomic-chrome-url-major-mode-alist
        '(("github\\.com" . gfm-mode)
          ("overleaf.com" . latex-mode)
          ("750words.com" . latex-mode)))
  ; Select the style of opening the editing buffer by atomic-chrome-buffer-open-style.
  ; full: Open in the selected window.
  ; split: Open in the new window by splitting the selected window (default).
  ; frame: Create a new frame and window in it. Must be using some windowing pacakge.
  (setq atomic-chrome-buffer-open-style 'split))

;; (use-package! blink-search
;;   :config
;;   (add-to-list 'load-path "~/.emacs.d/.local/straight/repos/blink-search/backend"))
;;
;;; which-key coppied from https://discourse.doomemacs.org/t/echo-area-covers-bottom-of-which-key/3026/2
(after! which-key
  (defadvice! fix-which-key--show-popup (fn act-popup-dim)
    :around #'which-key--show-popup
    (let ((height (car act-popup-dim))
          (width  (cdr act-popup-dim)))
      (funcall fn (cons (+ height 1) width)))))

(defcustom dwt/last-loaded-session nil
  "The last loaded session.")

(defadvice! dwt/save-last-loaded-session (fn file)
  :around #'doom/load-session
  (funcall fn file)
  (unless (string-equal file dwt/last-loaded-session)
    (customize-save-variable 'dwt/last-loaded-session file)))

(map! :leader
      "qj" #'dwt/load-last-loaded-session
      "qJ" #'dwt/save-current-session-to-last-loaded-session)

(use-package! pass
  :init
  (map! :leader
        "oP" #'pass)
  :config
  (setq pass-username-fallback-on-filename t))

(use-package! projectile
  :config
  (setq projectile-project-search-path '(("~/my_projects" . 1))))

;; https://github.com/doomemacs/doomemacs/issues/7981
(define-key y-or-n-p-map " " #'y-or-n-p-insert-y)
