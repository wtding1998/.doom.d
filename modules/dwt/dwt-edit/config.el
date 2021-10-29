;;; dwt/edit/config.el -*- lexical-binding: t; -*-

;;; evil
(after! evil
  (when IS-MAC
    (setq mac-command-modifier 'meta)
    (setq mac-right-command-modifier 'meta)
    (setq mac-option-modifier 'super)
    (setq mac-right-option-modifier 'super))
  ;; fix C-` problem in windows terminal
  (map! :ni "C-@" #'+popup/toggle)
  ;;; disable evil message
  (setq evil-insert-state-message nil)
  (setq evil-normal-state-message nil)
  (setq evil-visual-state-message nil)
  ;; better default setting
  (setq evil-want-fine-undo t)
  ;;; evil-key-binding
  (map! :nvm "Z" #'evil-jump-item
        :nvm "L" #'evil-end-of-line
        :nvm "H" #'evil-digit-argument-or-evil-beginning-of-line
        ;; :nvm "J" #'(lambda () (interactive) (evil-next-line 5))
        ;; :nvm "K" #'(lambda () (interactive) (evil-previous-line 5))
        :nvm "J" (kbd "5j")
        :nvm "K" (kbd "5k")
        :nv "[q" (kbd "C-c C-c")
        :nv "[Q" (kbd "C-c C-k")
        :nv "[p" #'goto-last-change
        :nv "]p" #'goto-last-change-reverse
        :nv "[z" #'goto-last-change
        :nv "]z" #'goto-last-change-reverse
        :n "Q" #'kill-current-buffer
        :i "C-v" #'evil-paste-before
        ;; C-n, C-p is binded to evil by default
        ;; to make them available in company-mode, disable them firstly
        :i "C-n" nil
        :i "C-p" nil
        ;; since I do not use repeat
        :n "'" #'basic-save-buffer
        ;; show doc
        :n "gh" #'+lookup/documentation
        ;; ace jump
        :n "ge" #'awesome-tab-ace-jump
        :n "zw" #'widen
        :nv "ga" #'evil-avy-goto-char-timer
        :nv "go" #'avy-goto-line
        :v "gC" #'capitalize-region
        :g "C-s" #'+default/search-buffer
        :g "M-`" #'+vterm/toggle
        :n "U" 'undo-fu-only-redo
        :nv "D" 'evil-avy-goto-char-2

        ;;; add new command with this prefix
        ;; :n "r" nil
        ;;; inden t and fold
        :map prog-mode-map
        :nv "<tab>a" #'align
        :v "<tab><tab>" #'indent-region
        :n "<tab><tab>" #'indent-for-tab-command
        :n "<tab>j" #'evil-toggle-fold

        :map global-map
        :leader
        ;; :desc "test" :prefix "a"
        :desc "winner undo""[" #'winner-undo
        :desc "winner undo""]" #'winner-redo
        :desc "shell command" "'" #'shell-command
        :desc "eval expression" ":" #'eval-expression
        :desc "buffer" "," #'persp-switch-to-buffer
        :desc "M-x" "<SPC>" #'counsel-M-x
        :desc "snippet" "it" #'company-yasnippet
        ;; :desc "jump item" "ii" #'evilmi-jump-items
        :desc "delete item" "id" #'evilmi-delete-items
        :desc "select item" "is" #'evilmi-select-items

        ;; toggle useful mode
        :desc "word wrap" "tw" #'toggle-word-wrap
        :desc "cdlatex" "tc" #'cdlatex-mode

        ;; window
        :desc "delete other windows" "1" #'delete-other-windows
        :desc "delete window" "0" #'delete-window
        :desc "winner-undo" "2" #'winner-undo
        :desc "winner-redo" "3" #'winner-redo
        :desc "window-size" "ww" #'hydra-window-size/body
        :desc "window-size" "w`'" #'evil-window-next

        ;; :desc "previous buffer" "[" #'previous-buffer
        ;; :desc "next buffer" "]" #'next-buffer
        :desc "ivy-resume" "`" #'ivy-resume
        :desc "counsel-buffer-or-recentf" ";" #'counsel-buffer-or-recentf

        ;; tabs
        :desc "kill other tabs" "t1" #'awesome-tab-kill-other-buffers-in-current-group
        :desc "switch tabs group" "tt" #'awesome-tab-counsel-switch-group
        :desc "next-group" "tn" #'awesome-tab-forward-group
        :desc "last-group" "tp" #'awesome-tab-backward-group
        :desc "kill-group" "tk" #'awesome-tab-kill-all-buffers-in-current-group
        ;; switch themes
        :desc "switch theme" "tT" #'dwt/random-load-theme

        ;; shell command
        :desc "shell command" ">" #'async-shell-command

        ;; file
        :desc "fzf" "fz" #'counsel-fzf
        :desc "file log" "fh" #'magit-log-buffer-file
        :desc "rg" "fg" #'counsel-rg
        :desc "find file other window" "fv" #'find-file-other-window
        :desc "open by extern program" "fo" #'counsel-find-file-extern

        ;; kill ring
        :desc "kill ring" "sa" #'counsel-yank-pop

        ;; link
        :desc "insert link" "nl" #'org-insert-link
        :desc "store link" "nL" #'org-store-link

        ;; help
        :desc "battery" "hB" #'battery)
  ;;; use C-z to undo and C-S-z to redo
  (map! :i "C-z" #'evil-undo)
  (map! :i "C-S-z" #'undo-fu-only-redo)

  (map! :map emacs-lisp-mode-map :n "ze" #'eval-last-sexp)
  ;; https://www.reddit.com/r/emacs/comments/doxfya/how_to_add_a_keybinding_to_an_existing_prefix/
  ;; https://github.com/hlissner/doom-emacs/blob/develop/docs/api.org#map
  ;; create a new prefix and add key-binding:

  ;;; window shrinkage
  (defhydra hydra-window-size (:color red)
    "Windows size"
    ("h" shrink-window-horizontally "shrink horizontal")
    ("j" shrink-window "shrink vertical")
    ("k" enlarge-window "enlarge vertical")
    ("l" enlarge-window-horizontally "enlarge horizontal")
    ("q" nil "quit")))

;;; evilnc-comment
(use-package! evil-nerd-commenter
  :config
  (map! :nv "gb" #'evilnc-copy-and-comment-operator))

;;; evil-snipe
(use-package! evil-snipe
  :config
  (setq evil-snipe-scope 'visible)
  (setq evil-snipe-repeat-scope 'visible)
  (setq evil-snipe-spillover-scope 'buffer))

;;; indent in elisp
(add-hook 'emacs-lisp-mode-hook
  (function (lambda ()
             (setq evil-shift-width 2 tab-width 2))))

;;; evil-multiedit
(use-package! evil-multiedit
  :after evil
  :config
  (map! :v "R" #'evil-multiedit-match-all
   :nv "M-d" #'evil-multiedit-match-and-next
   :nv "M-D" #'evil-multiedit-match-and-prev
   :i "M-d" #'evil-multiedit-toggle-marker-here
   :m "<RET>" #'evil-multiedit-toggle-or-restrict-region
   :map evil-multiedit-state-map
   "C-n" #'evil-multiedit-next
   "C-p" #'evil-multiedit-prev
   "<RET>" #'evil-multiedit-toggle-or-restrict-region
   :map evil-multiedit-insert-state-map
   "C-n" #'evil-multiedit-next
   "C-p" #'evil-multiedit-prev))

;;; evil-escape
(use-package! evil-escape
  :config
  (setq evil-escape-key-sequence "fd"))


;;; meow
;; Put these in the :config section in use-package
(use-package! meow
  :defer t
  ;; :init
  ;; (meow-global-mode 1)
  :custom
  ;; layout options: qwerty, dvorak, dvp, colemak
  (meow-layout 'qwerty)
  :config
  (meow-leader-define-key
   '("k" . kill-buffer)
   '("l" . goto-line)
   '("h" . other-window)
   '("o" . delete-other-windows)
   '("-" . split-window-below)
   '("/" . swiper)
   '("\\" . split-window-right)
   '("m" . magit-status)
   '("f" . find-file)
   '("F" . find-file-literally))
  (meow-leader-define-mode-key
   'emacs-lisp-mode
   '("RET" . eval-buffer)
   '("SPC" . eval-defun)))


(use-package! parinfer-rust-mode
  :init
  (setq parinfer-rust-auto-download nil)
  :config
  (setq parinfer-rust-preferred-mode "indent"))

;; (use-package! gcmh
;;   :init
;;   (setq garbage-collection-messages t))
