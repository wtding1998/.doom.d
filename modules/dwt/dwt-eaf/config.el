;;; dwt/dwt-eaf/config.el -*- lexical-binding: t; -*-

(use-package! eaf
  :load-path "~/.doom.d/emacs-application-framework"; Set to "/usr/share/emacs/site-lisp/eaf" if installed from AUR
  :defer t
  :custom
  (eaf-find-alternate-file-in-dired t)
  :config
  (eaf-bind-key scroll_up "C-n" eaf-pdf-viewer-keybinding)
  (eaf-bind-key scroll_down "C-p" eaf-pdf-viewer-keybinding)
  (eaf-bind-key take_photo "p" eaf-camera-keybinding))
