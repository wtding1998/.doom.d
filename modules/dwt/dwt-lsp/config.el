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
  (eldoc-box-hover-at-point-mode)
)

(use-package! eldoc-box
  :defer t)
