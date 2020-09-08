;;; dwt/rime/config.el -*- lexical-binding: t; -*-

;;; rime
(use-package! rime
  :defer t
  :custom
  (default-input-method "rime")
  (rime-show-candidate 'posframe)
:config
;; set rime configuration dir
(setq rime-user-data-dir "~/.config/fcitx/rime")

;; set UI
(setq rime-posframe-properties
                        (list :font "WenQuanYi Micro Hei Mono"))

;; use English automatically after English words
(setq rime-disable-predicates
                        '(rime-predicate-evil-mode-p
                                rime-predicate-tex-math-or-command-p
                                rime-predicate-evil-mode-p
                                rime-predicate-space-after-cc-p
                                rime-predicate-current-uppercase-letter-p
                                rime-predicate-after-ascii-char-p))

;; Force to enter chinese ignoring rime-disable-predicates
(define-key rime-mode-map (kbd "M-c") 'rime-force-enable)
;; fix the bug of posframe
  (defun +rime--posframe-display-content-a (args)
    "给 `rime--posframe-display-content' 传入的字符串加一个全角空
格，以解决 `posframe' 偶尔吃字的问题。"
    (cl-destructuring-bind (content) args
      (let ((newresult (if (string-blank-p content)
                           content
                         (concat content "　"))))
        (list newresult))))

  (if (fboundp 'rime--posframe-display-content)
      (advice-add 'rime--posframe-display-content
                  :filter-args
                  #'+rime--posframe-display-content-a)
    (error "Function `rime--posframe-display-content' is not available.")))
