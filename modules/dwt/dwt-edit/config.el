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
(define-key evil-normal-state-map (kbd "C-d") 'evil-multiedit-match-and-next)
;; Match selected region.
(define-key evil-visual-state-map (kbd "C-d") 'evil-multiedit-match-and-next)
;; Insert marker at point
(define-key evil-insert-state-map (kbd "C-d") 'evil-multiedit-toggle-marker-here)

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
