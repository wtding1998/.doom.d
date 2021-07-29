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
  (setq dwt/rime-modeline '(:eval current-input-method-title " "))
  (setq-default +modeline-format-right (push dwt/rime-modeline +modeline-format-right))
  ;; set rime configuration dir
  (setq rime-user-data-dir "~/.config/fcitx/rime")
  ;; set dir for mac especially
  (when IS-MAC
    (setq rime-librime-root "~/.emacs.d/librime/dist")
    (setq rime-emacs-module-header-root "/opt/homebrew/Cellar/emacs-plus@28/28.0.50/include")
    (setq rime-user-data-dir "~/Library/Rime"))
  ;; set UI
  (unless IS-MAC
    (setq rime-posframe-properties
          (list :font "Source Han Serif CN"))
    ;; remove background https://github.com/DogLooksGood/emacs-rime/issues/149
    (set-face-attribute 'rime-default-face       nil  :background nil)
    (set-face-attribute 'rime-code-face          nil  :background nil)
    (set-face-attribute 'rime-candidate-num-face nil  :background nil)
    (set-face-attribute 'rime-comment-face       nil  :background nil)
    (set-face-attribute 'rime-highlight-candidate-face nil  :background nil))

  ;; use English automatically after English words
  (setq rime-disable-predicates
        '(rime-predicate-evil-mode-p
          rime-predicate-tex-math-or-command-p
          rime-predicate-evil-mode-p
          rime-predicate-prog-in-code-p
          rime-predicate-in-code-string-p
          rime-predicate-punctuation-after-space-cc-p
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
                          (concat content "　"))))
          (list newresult))))

    (if (fboundp 'rime--posframe-display-content)
        (advice-add 'rime--posframe-display-content
                    :filter-args
                    #'+rime--posframe-display-content-a)
      (error "Function `rime--posframe-display-content' is not available."))))
