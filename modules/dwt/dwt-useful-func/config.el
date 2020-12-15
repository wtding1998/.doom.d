;;; dwt/dwt-use/config.el -*- lexical-binding: t; -*-

;;; TODO write the configuration of how to enter certain files quickly.

(defun dwt/create-config-links (label link)
  (insert label ": ")
  (insert-button link
                 'action (lambda (_) (find-file link))
                 'follow-link t)
  (insert "\n"))

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
                   "~/.doom.d/"
                   "~/.emacs.d.vanilia/init.el"
                   "~/.emacs.d/"
                   "~/.config")))
    (ivy-read "Open Configs: " configs :action 'find-file)))
(map! :leader :desc "Open configuration" "op" #'dwt/ivy-open-configuration)
