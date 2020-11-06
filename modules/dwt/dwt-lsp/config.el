;;; dwt/dwt-lsp/config.el -*- lexical-binding: t; -*-


;;; nox
(use-package! nox
  :defer t
  :config
  (setq nox-python-path (executable-find "python3")
        nox-python-server-dir "~/.emacs.d/nox/mspyls/")
  (dolist (hook (list
               'js-mode-hook
               'rust-mode-hook
               'python-mode-hook
               'ruby-mode-hook
               'java-mode-hook
               'sh-mode-hook
               'php-mode-hook
               'c-mode-common-hook
               'c-mode-hook
               'c++-mode-hook
               'haskell-mode-hook
               ))
    (add-hook hook '(lambda () (nox-ensure))))
  (add-hook 'python-mode-hook '(lambda () (remove-hook 'completion-at-point-functions 'python-completion-at-point t)))
  ;; (eldoc-box-hover-at-point-mode)
)

(use-package! eldoc-box
  :defer t)

(use-package! lsp-mode
  :defer t
  :config
  (setq lsp-auto-guess-root t)
  (setq lsp-signature-auto-activate t)
  (setq lsp-signature-doc-lines 1)
  (setq lsp-enable-symbol-highlighting t)
  (setq lsp-keymap-prefix "C-c l"
        lsp-keep-workspace-alive nil
        lsp-modeline-code-actions-enable nil
        lsp-modeline-diagnostics-enable nil
        lsp-modeline-workspace-status-enable nil

        lsp-enable-file-watchers nil
        lsp-enable-folding nil
        lsp-enable-semantic-highlighting nil
        lsp-enable-symbol-highlighting nil
        lsp-enable-text-document-color nil

        lsp-enable-indentation nil
        lsp-enable-on-type-formatting nil))



;; (use-package! eglot
;;   :config
;;   (setq eglot-ignored-server-capabilites '(:documentHighlightProvider)))
