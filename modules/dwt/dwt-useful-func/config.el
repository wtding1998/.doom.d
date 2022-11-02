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
(defun dwt/ivy-open-configuration ()
  (interactive)
  (let ((configs '("~/.zshrc"
                   "~/.vim/init"
                   "~/.config/kitty/kitty.conf"
                   "~/.doom.d/"
                   "~/.config/zathura/zathurarc"
                   "~/.config/fcitx/rime/default.custom.yaml"
                   "~/.config/ranger/rifle.conf"
                   "~/.emacs.d.vanilia/init.el"
                   "~/Library/Preferences/DOSBox-X 0.83.23 Preferences"
                   "/mnt/c/Users/56901/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1"
                   "~/.emacs.d/"
                   "~/.config")))
    (ivy-read "Open Configs: " configs :action 'find-file)))
(map! :leader :desc "Open configuration" "oP" #'dwt/ivy-open-configuration)

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

;;;###autoload
(defun dwt/goto-package-dir ()
  (interactive)
  (let* ((repos "~/.emacs.d/.local/straight/repos/")
         (packages (directory-files repos))
         (package-name (ivy-read "Package Name: " packages))
         (package-path (concat repos package-name)))
    (find-file (concat package-path))))

(defun dwt/copy-file-from-screenshot()
  (interactive)
  (let* ((screenshot "~/Pictures/screenshot/")
         (files (directory-files screenshot))
         (file-name (ivy-read "Screenshot Name: " files))
         (new-file-name (ivy-read "New File Name: " (list file-name)))
         (file-path (concat screenshot file-name)))
    (copy-file file-path (expand-file-name new-file-name))))


(map! :leader :desc "goto package dir" "hG" #'dwt/goto-package-dir
              :desc "copy screenshot" "f1" #'dwt/copy-file-from-screenshot)

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
