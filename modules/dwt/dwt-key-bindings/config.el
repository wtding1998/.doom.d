;;; dwt/bindings/config.el -*- lexical-binding: t; -*-

;; my-function
;; (defun dwt-forward-jump-sexp()
;;   (interactive)
;;   (call-interactively #'sp-end-of-sexp)
;;   (forward-char 1))

;; (defun dwt-backward-jump-sexp()
;;   (interactive)
;;   (call-interactively #'sp-beginning-of-sexp)
;;   (backward-char 1))

;;; evil-key-binding
(map! :nvm "Z" (kbd "%") ;; normal+visual+motion
      :nvm "L" (kbd "$")
      :nvm "H" (kbd "0")
      :nvm "J" (kbd "5j")
      :nvm "K" (kbd "5k")
      ;; :nvm "W" (kbd "5w")
      ;; :nvm "B" (kbd "5b")
      :nv "8" (kbd "^")
      :nv "9" (kbd "$")
      :nv "[q" (kbd "C-c C-c")
      :nv "[p" 'goto-last-change
      :nv "]p" 'goto-last-change-reverse
      :nv "[z" 'goto-last-change
      :nv "]z" 'goto-last-change-reverse
      :nv "[g" 'git-gutter:previous-hunk
      :nv "]g" 'git-gutter:next-hunk
      :n "Q" 'kill-current-buffer
      :i "C-v" 'evil-paste-before
      ;; C-n, C-p is binded to evil bydefault, to make them available in company-mode, disable them firstly
      :i "C-n" nil
      :i "C-p" nil
      ;; cursor move
      ;; :i "C-k" 'previous-line
      ;; :i "C-j" 'next-line
      ;; :i "C-l" 'right-char
      ;; :i "C-h" 'left-char
      ;; show doc
      :n "gh" #'+lookup/documentation
      :n "ge" #'awesome-tab-ace-jump
      :n "gj" #'evil-avy-goto-char-2
      :n "gb" #'avy-goto-char-2
      :n "go" #'avy-goto-line
      :n "-" #'evil-append-line
      :i "C-SPC" 'evil-visual-char)


(evil-define-key '(normal visual) prog-mode-map (kbd "<tab>a") #'align)
(evil-define-key 'visual prog-mode-map (kbd "<tab><tab>") #'indent-region)
(evil-define-key 'visual 'global (kbd "gC") #'capitalize-region)
(evil-define-key 'normal prog-mode-map (kbd "<tab><tab>") #'indent-for-tab-command)
;; (evil-define-key 'normal 'global (kbd "<tab>t") #'awesome-tab-ace-jump)
;; (evil-define-key 'normal 'global (kbd "<tab>T") #'awesome-tab-counsel-switch-group)
(evil-define-key 'normal prog-mode-map (kbd"<tab>j") #'evil-toggle-fold)
;;; doom-leader-def
;; https://www.reddit.com/r/emacs/comments/doxfya/how_to_add_a_keybinding_to_an_existing_prefix/
;; https://github.com/hlissner/doom-emacs/blob/develop/docs/api.org#map
;; create a new prefix and add key-binding:
(map! (:leader
       ;; :desc "test" :prefix "a"
       :desc "shell command" ";" #'shell-command
       :desc "eval expression" ":" #'eval-expression
       :desc "buffer" "," #'counsel-ibuffer
       :desc "M-x" "<SPC>" #'counsel-M-x
       :desc "snippet" "it" #'company-yasnippet
       ;; :desc "jump item" "ii" #'evilmi-jump-items
       :desc "delete item" "id" #'evilmi-delete-items
       :desc "select item" "is" #'evilmi-select-items

       ;; replace gitgutter
       ;; :desc "next hunk" "g[" #'diff-hl-previous-hunk
       ;; :desc "previous hunk" "g]" #'diff-hl-next-hunk

       ;; change the exitnet keybinding
       ;; :desc "my swiper buffer" "s s" #'my-swiper
       :desc "comment" "c l" #'evilnc-comment-or-uncomment-lines

       :desc "delete other windows" "1" #'delete-other-windows
       :desc "delete window" "0" #'delete-window
       :desc "winner-undo" "2" #'winner-undo
       :desc "winner-redo" "3" #'winner-redo

       ;; :desc "previous buffer" "[" #'previous-buffer
       ;; :desc "next buffer" "]" #'next-buffer

       :desc "popup term" "`" #'tmm-menubar

       :desc "easy motion" "se" #'evil-avy-goto-char-2

       :desc "vterm-yank" "vv" #'vterm-repl-yank

       :desc "kill-ring" "kk" #'counsel-browse-kill-ring

       ;; winner
       :desc "winner-undo" "w[" #'winner-undo
       :desc "winner-redi" "w]" #'winner-redo

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

       ;; help
       :desc "battery" "hB" #'battery))


(map! "M-`" #'+vterm/toggle)

;; === redo map key binding ===
(map! :n "U" 'undo-fu-only-redo)

(map! :n "D" 'evil-avy-goto-char-2
      :n "zs" 'basic-save-buffer
      :map emacs-lisp-mode-map :n "ze" #'eval-last-sexp)

;; TODO bind "ze" in normal state to eval-last-sexp in elisp mode
;; (add-hook 'elisp-mode-hook
;;         (lambda ()
;;           (define-key evil-normal-state-local-map (kbd "ze") 'eval-last-sexp)))

(map! "C-s" #'+default/search-buffer)

;;; python key binding
;; (after! python
;;   (map!
;;    :map python-mode-map
;;    :localleader
;;    :desc debug "d" #'realgud:pdb))
;; test
;; test
;; === Chenbin's set for comma leader ===
;; copied from https://github.com/redguardtoo/emacs.d/blob/b61d75b8e3359304f4b4781ad11443a4524c79db/lisp/init-evil.el#L426
;; {{ use `,` as leader key
;; use <general> pacage
(general-create-definer my-comma-leader-def
  :prefix ","
  :states '(normal visual))
;; === comma leader def ===
;;; comma leader def
(my-comma-leader-def
  "," 'evilnc-comment-operator
  "." 'repeat
  "[" 'winner-undo
  "]" 'winner-redo

  ;; latex
  "pp" 'preview-at-point
  "pb" 'preview-buffer
  "pr" 'preview-clearout-buffer
  ;; "prb" 'preview-clearout-buffer
  ;; "prs" 'preview-clearout-section
  ;; "prp" 'preview-clearout-at-point
  "ps" 'preview-section
  "pe" 'preview-environment
  ;; "pr" 'preview-region
  "pm" 'magic-latex-buffer
  "'" 'cdlatex-math-modify
  "`" 'cdlatex-math-symbol
  "le" 'cdlatex-environment
  "lt" 'reftex-toc
  "lc" 'TeX-command-master

  ;; yasnippet
  "yn" #'yas-new-snippet
  "yv" #'yas-visit-snippet-file
  "yy" 'company-snippet

  ;; symbol-overlay
  "si" 'symbol-overlay-put
  "sn" 'symbol-overlay-switch-forward
  "sp" 'symbol-overlay-switch-backward
  "sm" 'symbol-overlay-mode
  "sr" 'symbol-overlay-remove-all

  ;; function
  "fb" 'beginning-of-defun
  "fe" 'end-of-defun
  "fa" 'mark-defun

  ;; evil-mark-replace and evil-multiedit
  "rv" 'evilmr-replace-in-defun
  "rb" 'evilmr-replace-in-buffer
  "rt" 'evilmr-tag-selected-region
  "rr" 'evilmr-replace-in-tagged-region
  "rd" 'evil-multiedit-match-and-next ;; use C-d instead
  "rD" 'evil-multiedit-match-and-prev
  "re" 'evil-multiedit-toggle-or-restrict-region
  "rn" 'evil-multiedit-next
  "rp" 'evil-multiedit-prev

  ;; buffer
  ;; tabs
  "1" #'awesome-tab-select-visible-tab
  "2" #'awesome-tab-select-visible-tab
  "3" #'awesome-tab-select-visible-tab
  "4" #'awesome-tab-select-visible-tab
  "5" #'awesome-tab-select-visible-tab
  "6" #'awesome-tab-select-visible-tab
  "7" #'awesome-tab-select-visible-tab
  "8" #'awesome-tab-select-visible-tab
  "tt" #'awesome-tab-ace-jump'
  ;; "bb" 'awesome-tab-ace-jump

  ;; sdcv
  "es" 'sdcv-search-pointer+
  "et" 'sdcv-search-pointer
  "ei" 'sdcv-search-input
  "ey" 'youdao-dictionary-search-at-point
  "ep" 'youdao-dictionary-search-at-point-posframe

  ;; diff-hl
  "g]" 'diff-hl-next-hunk
  "g[" 'diff-hl-previous-hunk

  ;; clipboard
  ;; FIXME copy-to-x-clipboard sometimes wrong
  "aa" 'copy-to-x-clipboard ; used frequently
  "px" 'paste-from-x-clipboard ; used frequently

  ;; eval
  "er" 'eval-region
  "xe" 'eval-last-sexp

  "bu" 'backward-up-list
  "bb" (lambda () (interactive) (switch-to-buffer nil)) ; to previous buffer
  "m" 'counsel-evil-marks
  "em" 'my-erase-visible-buffer
  "eb" 'eval-buffer
  ;; "sd" 'sudo-edit
  ;; "sc" 'scratch
  "ee" 'eval-expression
  "aw" 'ace-swap-window
  "af" 'ace-maximize-window
  "ac" 'aya-create
  "bs" '(lambda () (interactive) (goto-edge-by-comparing-font-face -1))
  ;; "es" 'goto-edge-by-comparing-font-face
  "vj" 'my-validate-json-or-js-expression
  "kc" 'kill-ring-to-clipboard
  "fn" 'cp-filename-of-current-buffer
  "fp" 'cp-fullpath-of-current-buffer
  "dj" 'dired-jump ;; open the dired from current file
  "xo" 'ace-window
  "ff" 'my-toggle-full-window ;; I use WIN+F in i3
  "ip" 'find-file-in-project
  ;; "tt" 'find-file-in-current-directory
  "jj" 'find-file-in-project-at-point
  ;; "kk" 'find-file-in-project-by-selected
  "kn" 'find-file-with-similar-name ; ffip v5.3.1
  "fd" 'find-directory-in-project-by-selected
  "trm" 'get-term
  "tff" 'toggle-frame-fullscreen
  "tfm" 'toggle-frame-maximized
  "ti" 'fastdef-insert
  ;; "th" 'fastdef-insert-from-history
  "cl" 'evilnc-comment-or-uncomment-lines
  "cq" 'evilnc-quick-comment-or-uncomment-to-the-line
  "cc" 'evilnc-copy-and-comment-lines
  "cp" 'evilnc-comment-or-uncomment-paragraphs
  "ct" 'evilnc-comment-or-uncomment-html-tag ; evil-nerd-commenter v3.3.0 required
  "ci" 'org-clock-in
  "co" 'org-clock-out
  "cr" 'org-clock-report
  "cd" 'org-deadline
  "cs" 'org-schedule
  "ct" 'org-todo
                                        ; "ca" 'org-archive-subtree
  "ic" 'my-imenu-comments
  ;; {{ window move
  "wh" 'evil-window-left
  "wl" 'evil-window-right
  "wk" 'evil-window-up
  "wj" 'evil-window-down
  ;; }}
  "cby" 'cb-switch-between-controller-and-view
  "cbu" 'cb-get-url-from-controller
  ;; "rt" 'counsel-etags-recent-tag
  ;; "ft" 'counsel-etags-find-tag
  "kk" 'counsel-browse-kill-ring
  "cf" 'counsel-grep ; grep current buffer
  "gf" 'counsel-git ; find file
  "gg" 'my-counsel-git-grep ; quickest grep should be easy to press
  "gd" 'ffip-show-diff-by-description ;find-file-in-project 5.3.0+
  "gt" 'my-evil-goto-definition ; "gt" is occupied by evil
  "gl" 'my-git-log-trace-definition ; find history of a function or range
  "sh" 'my-select-from-search-text-history
  "rjs" 'run-js
  "jsr" 'js-send-region
  "jsb" 'js-clear-send-buffer
  "kb" 'kill-buffer-and-window ;; "k" is preserved to replace "C-g"
  "ls" 'highlight-symbol
  "lq" 'highlight-symbol-query-replace
  "ln" 'highlight-symbol-nav-mode ; use M-n/M-p to navigation between symbols
  "ii" 'my-imenu-or-list-tag-in-current-file
  "." 'evil-ex
  ;; @see https://github.com/pidu/git-timemachine
  ;; p: previous; n: next; w:hash; W:complete hash; g:nth version; q:quit
  "tm" 'my-git-timemachine
  ;; toggle overview,  @see http://emacs.wordpress.com/2007/01/16/quick-and-dirty-code-folding/
  "oo" 'compile
  "c$" 'org-archive-subtree ; `C-c $'
  ;; org-do-demote/org-do-premote support selected region
  "c<" 'org-do-promote ; `C-c C-<'
  "c>" 'org-do-demote ; `C-c C->'
  "cam" 'org-tags-view ; `C-c a m': search items in org-file-apps by tag
                                        ; "cxi" 'org-clock-in ; `C-c C-x C-i'
                                        ; "cxo" 'org-clock-out ; `C-c C-x C-o'
                                        ; "cxr" 'org-clock-report ; `C-c C-x C-r'
  ;; "qq" 'my-multi-purpose-grep
  "dd" 'counsel-etags-grep-current-directory
  ;; "rr" 'my-counsel-recentf
  "da" 'diff-region-tag-selected-as-a
  "db" 'diff-region-compare-with-b
  "di" 'evilmi-delete-items
  ;; "si" 'evilmi-select-items
  "jb" 'js-beautify
  "jp" 'my-print-json-path
  ;; "0" 'delete-window
  ;; "1" 'delete-other-windows
  ;; "2" 'split-window-vertically
  ;; "3" 'split-window-horizontally
  "s2" 'ffip-split-window-vertically
  "s3" 'ffip-split-window-horizontally
  "xr" 'rotate-windows
  "xt" 'toggle-two-split-window
  "uu" 'winner-undo
  "ur" 'winner-redo
  "fs" 'ffip-save-ivy-last
  "fr" 'ffip-ivy-resume
  "fc" 'cp-ffip-ivy-last
  "ss" 'my-swiper
  ;; "fb" 'flyspell-buffer
  ;; "fe" 'flyspell-goto-next-error
  ;; "fa" 'flyspell-auto-correct-word
  "lb" 'langtool-check-buffer
  "ll" 'langtool-goto-next-error
  ;; "pe" 'flymake-goto-prev-error
  ;; "ne" 'flymake-goto-next-error
  "oga" 'org-agenda
  "ogd" 'org-agenda-day-view
  "ogw" 'org-agenda-week-view
  "otl" 'org-toggle-link-display
  "oa" '(lambda ()
          (interactive)
          (my-ensure 'org)
          (counsel-org-agenda-headlines))
  "ut" 'undo-tree-visualize
  "ar" 'align-regexp
  "wrn" 'httpd-restart-now
  "wrd" 'httpd-restart-at-default-directory
  "bk" 'buf-move-up
  "bj" 'buf-move-down
  "bh" 'buf-move-left
  "bl" 'buf-move-right
  "x0" 'winum-select-window-0-or-10
  ;; "x1" 'winum-select-window-1
  "x1" 'delete-other-windows
  "x2" 'winum-select-window-2
  "x3" 'winum-select-window-3
  "x4" 'winum-select-window-4
  "x5" 'winum-select-window-5
  "x6" 'winum-select-window-6
  "x7" 'winum-select-window-7
  "x8" 'winum-select-window-8
  "x9" 'winum-select-window-9
  "xm" 'counsel-M-x
  "xx" 'er/expand-region
  "xf" 'counsel-find-file
  "xb" 'ivy-switch-buffer-by-pinyin
  ;; "xh" 'mark-whole-buffer
  "xh" 'previous-buffer
  "xl" 'next-buffer
  "xk" 'kill-buffer
  "xs" 'save-buffer
  "xc" 'save-buffers-kill-emacs
  "xz" 'my-switch-to-shell
  "vf" 'vc-rename-file-and-buffer
  "vc" 'vc-copy-file-and-rename-buffer
  "xv" 'vc-next-action ; 'C-x v v' in original
  "va" 'git-add-current-file
  "vk" 'git-checkout-current-file
  "vg" 'vc-annotate ; 'C-x v g' in original
  "vv" 'vc-msg-show
  "v=" 'git-gutter:popup-hunk
  "hh" 'cliphist-paste-item
  "yu" 'cliphist-select-item
  "ih" 'my-goto-git-gutter ; use ivy-mode
  "ir" 'ivy-resume
  "ww" 'narrow-or-widen-dwim
  "ycr" 'my-yas-reload-all
  "wf" 'popup-which-function)

