;;; dwt/vterm/config.el -*- lexical-binding: t; -*-


(after! vterm
  (defun dwt/vterm-toggle-current-dir ()
    "Insert cd path to the current buffer besides vterm"
    (interactive)
    (when (derived-mode-p 'vterm-mode)
      (let* ((current-window-list (window-list))
             (current-window (nth 1 current-window-list))
             (current-buffer-besides-vterm (window-buffer current-window))
             (current-dir (file-name-directory (buffer-file-name current-buffer-besides-vterm))))
        (vterm-send-string "cd ")
        (vterm-send-string current-dir))))
        
  (map! :map vterm-mode-map
        :n "q" #'dwt/vterm-toggle-current-dir)

  ;; disable the alt+num in vterm
  (map! :map vterm-mode-map
        "M-1" nil
        "M-2" nil
        "M-3" nil
        "M-4" nil
        "M-5" nil
        "M-6" nil
        "M-7" nil
        "M-8" nil
        "M-9" nil)


  (map! :map vterm-mode-map :i "C-w" #'vterm-send-C-w
        :map vterm-mode-map :i "C-u" #'vterm-send-C-u
        :map vterm-mode-map :i "C-e" #'vterm-send-C-e
        :map vterm-mode-map :i "C-d" #'vterm-send-C-d
        ;; :map vterm-mode-map :i "C-v" #'(lambda () (interactive) (vterm-yank) (vterm-send-backspace))
        :map vterm-mode-map :i "C-v" #'vterm-yank
        :map vterm-mode-map :i "M-v" #'vterm-yank
        :map vterm-mode-map :n "p"   #'(lambda () (interactive) (vterm-yank))
        :map vterm-mode-map :i "C-a" #'vterm-send-C-a)
  ;; (set-popup-rules!
  ;;   '(("^\\*doom:vterm" :size 15 :select t)))
  (when IS-MAC
    (map! :leader "oT" #'+macos/open-in-iterm))
  (map! :leader "ot" #'+vterm/here))
