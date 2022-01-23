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
                   "~/.emacs.d/"
                   "~/.config")))
    (ivy-read "Open Configs: " configs :action 'find-file)))
(map! :leader :desc "Open configuration" "op" #'dwt/ivy-open-configuration)

;;;###autoload
(defun dwt/clean-recentf ()
  "Clean roam files in recentf list."
  (interactive)
  (let ((recentf-exclude '("roam/")))
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
  (condition-case err
      (let ((path (with-temp-buffer
                    (insert-file-contents-literally "~/.path")
                    (buffer-string))))
        (setenv "PATH" path)
        (setq exec-path (append (parse-colon-path path) (list exec-directory))))
    (error (warn "%s" (error-message-string err))))

  (use-package! netease-cloud-music
    :defer t
    :commands (netease-cloud-music)
    :init
    (map! :leader
          :desc "music" "tm" #'netease-cloud-music)
    :config
    (evil-set-initial-state 'netease-cloud-music-mode 'emacs)))

;; weather
(defun dwt/weather ()
  "weather based on https://github.com/chubin/wttr.in."
  (interactive)
  (eww "zh-cn.wttr.in/longgang?TAFm"))

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

(map! :leader :desc "goto package dir" "hG" #'dwt/goto-package-dir)

(defun dwt/replace-path ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "\\\\" nil t)
      (replace-match "$"))
    (while (search-forward "\\)" nil t)
      (replace-match "$"))))


;; (re-search-forward "D\\\\:\\\\\\\\OneDrive\\\\\\\\Documents\\\\\\\\zotero\\\\\\\\storage\\\\\\\\")
;; (anzu-query-replace-regexp \\\\OneDrive\\\\Documents\\\\zotero\\\\storage\\\\\([A-Z0-9]+\)\\\\)
