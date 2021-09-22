;;; dwt/vterm/config.el -*- lexical-binding: t; -*-


(after! vterm
  (map! :map vterm-mode-map :i "C-w" #'vterm-send-C-w
        :map vterm-mode-map :i "C-u" #'vterm-send-C-u
        :map vterm-mode-map :i "C-e" #'vterm-send-C-e
        ;; :map vterm-mode-map :i "C-v" #'(lambda () (interactive) (vterm-yank) (vterm-send-backspace))
        :map vterm-mode-map :i "C-v" #'vterm-yank
        :map vterm-mode-map :n "p"   #'(lambda () (interactive) (vterm-yank) (vterm-send-backspace))
        :map vterm-mode-map :i "C-a" #'vterm-send-C-a)'
  (set-popup-rules!
    '(("^\\*doom:vterm" :size 15 :select t)))
  (when IS-MAC
    (map! :leader "oT" #'+macos/open-in-iterm))
  (map! :leader "ot" #'+vterm/here))
