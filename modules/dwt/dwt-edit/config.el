;;; dwt/edit/config.el -*- lexical-binding: t; -*-

;;; evil
(after! evil
  ;; fix C-` problem in windows terminal
  (map! :ni "C-@" #'+popup/toggle)
  ;;; disable evil message
  (setq evil-insert-state-message nil)
  (setq evil-normal-state-message nil)
  (setq evil-visual-state-message nil)
  ;; better default setting
  (setq evil-want-fine-undo t)
  ;; allow cross line
  (setq evil-cross-lines t)
  (map! :map global-map
        :i "s-<backspace>" #'evil-delete-backward-word)
  (map! :g "s-<backspace>" #'evil-delete-backward-word)
  ;;; evil-key-binding
  (map!
        :n "Q" #'kill-current-buffer
        :n "[f" #'+evil/previous-frame
        :n "]f" #'+evil/next-frame
        :n "[F" #'+evil/previous-file
        :n "]F" #'+evil/next-file
        :n "[[" #'previous-buffer
        :n "]]" #'next-buffer
        ;; C-n, C-p is binded to evil by default
        ;; to make them available in company-mode, disable them firstly
        :i "C-n" nil
        :i "C-p" nil
        :i "M-d" #'backward-delete-char-untabify
        ;; since I do not use repeat
        :n "-" #'basic-save-buffer
        ;; show doc
        :n "gh" #'+lookup/documentation
        ;; ace jump
        :nv "g1" #'evil-avy-goto-char
        :nv "g2" #'evil-avy-goto-char-2
        :nv "g3" #'evil-avy-goto-word-1
        :nv "g4" #'evil-avy-goto-word-0
        :n "zw" #'widen
        :nv "g/" #'evil-avy-goto-char-timer
        :nv "go" #'avy-goto-line
        ;; :nv "g[" #'evil-avy-goto-word-1
        ;; :nv "g]" #'evil-avy-goto-char
        :nv "ga" #'evil-avy-goto-word-0
        :v "gC" #'capitalize-region
        :v "v" #'er/expand-region
        :g "C-s" #'+default/search-buffer
        :g "M-`" #'+vterm/toggle
        ;; :n "U" 'undo-fu-only-redo
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
        :desc "shell command" ":" #'shell-command
        :desc "eval expression" "'" #'eval-expression
        :desc "buffer" "," #'persp-switch-to-buffer
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
        ;; shell command
        :desc "shell command" ">" #'async-shell-command
        ;; file
        :desc "file log" "fh" #'magit-log-buffer-file
        :desc "find file other window" "fv" #'find-file-other-window
        ;; link
        :desc "insert link" "nl" #'org-insert-link
        :desc "store link" "nL" #'org-store-link
        ;; help
        :desc "battery" "hB" #'battery)
  ;;; use C-z to undo and C-S-z to redo
  (map! :i "C-z" #'evil-undo)
  (map! :i "C-S-z" #'undo-fu-only-redo)

  ;;; basic edit setting
  (setq word-wrap-by-category t)

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
  :defer t
  :hook (emacs-lisp-mode . parinfer-rust-mode)
  :init
  (setq parinfer-rust-auto-download nil)
  :config
  (setq parinfer-rust-preferred-mode "indent"))

;; avy
(after! avy
  (setq avy-single-candidate-jump t))

;; (use-package! gcmh
;;   :init
;;   (setq garbage-collection-messages t))

;;;###autoload
(defun dwt/test ()
  "An command for test."
  (interactive)
  (message "test"))

(map! :ni "<f5>" #'dwt/test)

(use-package! evil-motion-trainer
  :defer t
  :commands (evil-motion-trainer-mode)
  ;; :hook ((prog-mode . evil-motion-trainer-mode)
  ;;        (latex-mode . evil-motion-trainer-mode)
  ;;        (org-mode . evil-motion-trainer-mode))
  :config
  (setq evil-motion-trainer-threshold 5))

(use-package! evil-matchit
  :commands (evil-matchit-mode))

(after! spell-fu
  (setq spell-fu-idle-delay 0.5))

(use-package! emacs-devdocs-browser
  :defer t
  :commands (devdocs-browser-open devdocs-browser-open-in)
  :init
  (map! :leader "cb" #'devdocs-browser-open
                "cB" #'devdocs-browser-open-in))

;;; refer to https://github.com/doomemacs/doomemacs/issues/2480 about how to set new leader key
(setq doom-localleader-alt-key "C-SPC m")
(map! :map general-override-mode-map
      :ein "C-SPC" #'doom/leader)

(use-package! vundo
  :config
  (map! :n "g7" #'vundo
        :map vundo-mode-map
        :n "h" #'vundo-backward
        :n "l" #'vundo-forward
        :n "j" #'vundo-next
        :n "k" #'vundo-previous
        :n "a" #'vundo-stem-root
        :n "e" #'vundo-stem-end))


(after! prettify-symbols
  (setq prettify-symbols-unprettify-at-point t))

(use-package! evil-textobj-line
  :after evil)

(use-package! smart-hungry-delete
  :commands (smart-hungry-delete-backward-char)
  :init
  (map! :i "C-M-d" #'smart-hungry-delete-backward-char))

(use-package! symbol-overlay
  :commands (symbol-overlay-put)
  :init
  (map! :vn "g8" #'symbol-overlay-put
        :vn "g0" #'symbol-overlay-switch-forward
        :vn "g9" #'symbol-overlay-switch-backward
        :vn "g]" #'symbol-overlay-jump-next
        :vn "g[" #'symbol-overlay-jump-prev
        :vn "g)" #'symbol-overlay-remove-all
        :vn "g(" #'symbol-overlay-mode))

(after! iedit
  :config
  (map! :map iedit-mode-keymap "TAB" nil))

(use-package! eldoc-box
  :hook ((eldoc-mode . eldoc-box-hover-mode)))

(use-package! evil-terminal-cursor-changer
  :when (not (display-graphic-p))
  :config
  (setq etcc-term-type-override 'xterm)
  (etcc-on))
