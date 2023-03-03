;;; dwt/dwt-eaf/config.el -*- lexical-binding: t; -*-

(use-package! eaf
  :load-path "~/.emacs.d/.local/straight/repos/emacs-application-framework"
  :config
  (require 'eaf-pdf-viewer)); Set to "/usr/share/emacs/site-lisp/eaf" if installed from AUR
  ;; :defer t
  ;; :init
  ;; (map! :leader "oE" #'eaf-open)
  ;; :custom
  ;; (eaf-find-alternate-file-in-dired t)
  ;; :config
  ;; (eaf-bind-key scroll_up "C-n" eaf-pdf-viewer-keybinding)
  ;; (eaf-bind-key scroll_down "C-p" eaf-pdf-viewer-keybinding)
  ;; (eaf-bind-key take_photo "p" eaf-camera-keybinding)
  ;; ;; terminal
  ;; (eaf-setq eaf-terminal-font-size "22")
  ;; (eaf-setq eaf-terminal-font-family "SF MONO")
  ;; (eaf-setq eaf-jupyter-font-size "22")
  ;; (eaf-setq eaf-jupyter-font-family "SF MONO")
  ;; (eaf-setq eaf-browser-default-zoom "2")
  ;; ;; switch insert mode
  ;; (add-to-list 'evil-insert-state-modes 'eaf-mode))
