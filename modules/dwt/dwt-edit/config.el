;;; dwt/edit/config.el -*- lexical-binding: t; -*-
;;; evil-snipe
(use-package! evil-snipe
  :defer t
  :config
  (setq evil-snipe-scope 'visible)
  (setq evil-snipe-repeat-scope 'visible)
  (setq evil-snipe-spillover-scope 'buffer))

;;; indent in elisp
(add-hook 'emacs-lisp-mode-hook
  (function (lambda ()
          (setq evil-shift-width 2 tab-width 2))))

;;; kill-ring
(defun my-prepare-candidate-fit-into-screen (s)
  (let* ((w (frame-width))
         ;; display kill ring item in one line
         (key (replace-regexp-in-string "[ \t]*[\n\r]+[ \t]*" "\\\\n" s)))
    ;; strip the whitespace
    (setq key (replace-regexp-in-string "^[ \t]+" "" key))
    ;; fit to the minibuffer width
    (if (> (length key) w)
        (setq key (concat (substring key 0 (- w 4)) "...")))
    (cons key s)))

(defun my-select-from-kill-ring (fn)
  "If N > 1, yank the Nth item in `kill-ring'.
If N is nil, use `ivy-mode' to browse `kill-ring'."
  (interactive "P")
  (let* ((candidates (cl-remove-if
                       (lambda (s)
                         (or (< (length s) 5)
                             (string-match-p "\\`[\n[:blank:]]+\\'" s)))
                       (delete-dups kill-ring)))
          (ivy-height (/ (frame-height) 2)))
     (ivy-read "Browse `kill-ring':"
               (mapcar #'my-prepare-candidate-fit-into-screen candidates)
               :action fn)))

(defun my-delete-selected-region ()
  "Delete selected region."
  (when (region-active-p)
    (delete-region (region-beginning) (region-end))))

(defun my-insert-str (str)
  "Insert STR into current buffer."
  ;; ivy8 or ivy9
  (if (consp str) (setq str (cdr str)))
  ;; evil-mode?
  (if (and (functionp 'evil-normal-state-p)
           (boundp 'evil-move-cursor-back)
           (evil-normal-state-p)
           (not (eolp))
           (not (eobp)))
      (forward-char))

  (my-delete-selected-region)

  ;; insert now
  (insert str)
  str)

(defun counsel-browse-kill-ring (&optional n)
  "If N > 1, assume just yank the Nth item in `kill-ring'.
If N is nil, use `ivy-mode' to browse `kill-ring'."
  (interactive "P")
  (my-select-from-kill-ring (lambda (s)
                              (let* ((plain-str (my-insert-str s))
                                     (trimmed (string-trim plain-str)))
                                (setq kill-ring (cl-delete-if
                                                 `(lambda (e) (string= ,trimmed (string-trim e)))
                                                 kill-ring))
                                (kill-new plain-str)))))

;;; evil-multiedit
;; Highlights all matches of the selection in the buffer.
;; (use-package! evil-multiedit
;;   :defer t
;;   :config
;;   )

(define-key evil-visual-state-map "R" 'evil-multiedit-match-all)
;; Match the word under cursor (i.e. make it an edit region). Consecutive presses will
;; incrementally add the next unmatched match.
(define-key evil-normal-state-map (kbd "C-k") 'evil-multiedit-match-and-next)
;; Match selected region.
(define-key evil-visual-state-map (kbd "C-k") 'evil-multiedit-match-and-next)
;; Insert marker at point
(define-key evil-insert-state-map (kbd "C-k") 'evil-multiedit-toggle-marker-here)

(after! evil-multiedit
  ;; RET will toggle the region under the cursor
  (define-key evil-multiedit-state-map (kbd "RET") 'evil-multiedit-toggle-or-restrict-region)
  ;; ...and in visual mode, RET will disable all fields outside the selected region
  (define-key evil-motion-state-map (kbd "RET") 'evil-multiedit-toggle-or-restrict-region)
  ;; For moving between edit regions
  (define-key evil-multiedit-state-map (kbd "C-n") 'evil-multiedit-next)
  (define-key evil-multiedit-state-map (kbd "C-p") 'evil-multiedit-prev)
  (define-key evil-multiedit-insert-state-map (kbd "C-n") 'evil-multiedit-next)
  (define-key evil-multiedit-insert-state-map (kbd "C-p") 'evil-multiedit-prev)
  )


;;; awesome-pair
;; (require 'awesome-pair)
;; (dolist (hook (list
;;             'c-mode-common-hook
;;             'c-mode-hook
;;             'c++-mode-hook
;;             'java-mode-hook
;;             'haskell-mode-hook
;;             'emacs-lisp-mode-hook
;;             'lisp-interaction-mode-hook
;;             'lisp-mode-hook
;;             'maxima-mode-hook
;;             'ielm-mode-hook
;;             'sh-mode-hook
;;             'makefile-gmake-mode-hook
;;             'php-mode-hook
;;             'python-mode-hook
;;             'js-mode-hook
;;             'go-mode-hook
;;             'qml-mode-hook
;;             'jade-mode-hook
;;             'css-mode-hook
;;             'ruby-mode-hook
;;             'coffee-mode-hook
;;             'rust-mode-hook
;;             'qmake-mode-hook
;;             'lua-mode-hook
;;             'swift-mode-hook
;;             'minibuffer-inactive-mode-hook
;;             ))
;; (add-hook hook '(lambda () (awesome-pair-mode 1))))
;; (define-key awesome-pair-mode-map (kbd "(") 'awesome-pair-open-round)
;; (define-key awesome-pair-mode-map (kbd "[") 'awesome-pair-open-bracket)
;; (define-key awesome-pair-mode-map (kbd "{") 'awesome-pair-open-curly)
;; (define-key awesome-pair-mode-map (kbd ")") 'awesome-pair-close-round)
;; (define-key awesome-pair-mode-map (kbd "]") 'awesome-pair-close-bracket)
;; (define-key awesome-pair-mode-map (kbd "}") 'awesome-pair-close-curly)
;; (define-key awesome-pair-mode-map (kbd "=") 'awesome-pair-equal)
;; (define-key awesome-pair-mode-map (kbd "%") 'awesome-pair-match-paren)
;; (define-key awesome-pair-mode-map (kbd "\"") 'awesome-pair-double-quote)

;; (define-key awesome-pair-mode-map (kbd "SPC") 'awesome-pair-space)

;; (define-key awesome-pair-mode-map (kbd "M-o") 'awesome-pair-backward-delete)
;; (define-key awesome-pair-mode-map (kbd "C-d") 'awesome-pair-forward-delete)
;; (define-key awesome-pair-mode-map (kbd "C-k") 'awesome-pair-kill)

;; ;; (define-key awesome-pair-mode-map (kbd "M-\"") 'awesome-pair-wrap-double-quote)
;; ;; (define-key awesome-pair-mode-map (kbd "M-[") 'awesome-pair-wrap-bracket)
;; ;; (define-key awesome-pair-mode-map (kbd "M-{") 'awesome-pair-wrap-curly)
;; ;; (define-key awesome-pair-mode-map (kbd "M-(") 'awesome-pair-wrap-round)
;; ;; (define-key awesome-pair-mode-map (kbd "M-)") 'awesome-pair-unwrap)

;; (define-key awesome-pair-mode-map (kbd "M-p") 'awesome-pair-jump-right)
;; (define-key awesome-pair-mode-map (kbd "M-n") 'awesome-pair-jump-left)
;; (define-key awesome-pair-mode-map (kbd "M-:") 'awesome-pair-jump-out-pair-and-newline)

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
    '("SPC" . eval-defun))
  )
