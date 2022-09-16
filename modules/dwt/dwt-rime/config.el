;;; dwt/rime/config.el -*- lexical-binding: t; -*-

;;; rime
(use-package! rime
  :defer t
  :custom
  (default-input-method "rime")
  (rime-show-candidate 'posframe)
  ;; set to minibuffer for better performance
  ;; (rime-show-candidate 'minibuffer)
  :config
  (setq dwt/rime-modeline '(:eval (rime-lighter)))
  (setq-default +modeline-format-right (push "  " +modeline-format-right))
  (setq-default +modeline-format-right (push dwt/rime-modeline +modeline-format-right))
  ;; set rime configuration dir
  (setq rime-user-data-dir "~/.config/fcitx/rime")
  ;; set dir for mac especially
  (when IS-MAC
    (setq rime-librime-root "~/mycode/rime-1.7.2-osx/dist")
    ;; (setq rime-emacs-module-header-root "/opt/homebrew/Cellar/emacs-plus@29/29.0.50/include")
    (setq rime-emacs-module-header-root "/opt/homebrew/opt/emacs-plus@29/include")
    (setq rime-user-data-dir "~/Library/Rime"))
  ;; set UI
  ;; (unless IS-MAC
  ;;   (setq rime-posframe-properties
  ;;         (list :font "Source Han Serif CN")))
  ;; remove background https://github.com/DogLooksGood/emacs-rime/issues/149
  ;; color for mode line lighter
  (defun dwt/set-rime-face ()
    "Set the face of rime according to current theme."
    (interactive)
    (setq rime-posframe-properties
          (list :internal-border-width 1
                :internal-border-color "#282a2c"))
    ;; (set-face-attribute 'rime-indicator-face nil :inherit 'doom-modeline :foreground nil)
    ;; (set-face-attribute 'rime-indicator-dim-face nil :inherit 'error :foreground nil)
    ;; color for posframedhi
    ;; (set-face-attribute 'rime-default-face       nil :foreground (face-foreground 'widget-field) :background (face-background 'widget-field))
    (set-face-attribute 'rime-default-face       nil :foreground (face-foreground 'default) :background (face-background 'default))
    (set-face-attribute 'rime-code-face          nil :foreground nil :background nil :inherit 'rime-default-face)
    (set-face-attribute 'rime-candidate-num-face nil :inherit 'rime-default-face :foreground nil :background nil)
    (set-face-attribute 'rime-comment-face nil :inherit 'rime-default-face :foreground nil :background nil))
    ;; (set-face-attribute 'rime-highlight-candidate-face nil :inherit 'rime-default-face :foreground (face-foreground 'error) :background nil))

  (defun dwt/set-rime-fact-light ()
    (interactive)
    (setq rime-posframe-properties
          (list :internal-border-width 1
                :internal-border-color "#00538b"))
    ;; background: 背景 foreground: 除了候选项之外的其它选项
    (set-face-attribute 'rime-default-face       nil :foreground "#505050" :background "#f2eff3")
    ;; 数字
    (set-face-attribute 'rime-code-face          nil :foreground "#00538b" :background nil)
    (set-face-attribute 'rime-candidate-num-face nil :foreground "#00538b" :background nil)

    (set-face-attribute 'rime-comment-face       nil :foreground "#8fbcbb" :background nil)
    ;; 第一项
    (set-face-attribute 'rime-highlight-candidate-face       nil :foreground "#000000" :background nil))

  ;; use English automatically after English words
  (setq rime-disable-predicates
        '(rime-predicate-evil-mode-p
          rime-predicate-tex-math-or-command-p
          rime-predicate-evil-mode-p
          rime-predicate-prog-in-code-p
          rime-predicate-in-code-string-p
          rime-predicate-punctuation-after-space-cc-p
          rime-predicate-punctuation-after-ascii-p
          rime-predicate-space-after-cc-p
          rime-predicate-current-uppercase-letter-p
          rime-predicate-after-alphabet-char-p))

  ;; Force to enter chinese ignoring rime-disable-predicates
  (define-key rime-mode-map (kbd "M-c") 'rime-force-enable)
  ;; fix the bug of posframe
  (unless IS-MAC
    (defun +rime--posframe-display-content-a (args)
      "给 `rime--posframe-display-content' 传入的字符串加一个全角空
    格，以解决 `posframe' 偶尔吃字的问题。"
      (cl-destructuring-bind (content) args
        (let ((newresult (if (string-blank-p content)
                            content
                          (concat content " "))))
          (list newresult))))

    (if (fboundp 'rime--posframe-display-content)
        (advice-add 'rime--posframe-display-content
                    :filter-args
                    #'+rime--posframe-display-content-a)
      (error "Function `rime--posframe-display-content' is not available."))))
