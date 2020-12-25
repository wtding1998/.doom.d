;;; dwt/dwt-nox/config.el -*- lexical-binding: t; -*-

(use-package! nox
  :defer 2
  :init
  (set-company-backend! 'python-mode
    '(company-capf :with company-yasnippet) '(company-dabbrev-code company-keywords company-files :with company-yasnippet) '(company-dabbrev))
  :config
    ;; '(company-capf) '(company-dabbrev-code company-keywords company-files :with company-yasnippet) '(company-dabbrev))
  (setq nox-python-path (executable-find "python3"))
  (setq nox-python-server "pyright")
  ;; (setq nox-python-server "mspyls")
        ;; nox-python-server-dir "~/.emacs.d/nox/mspyls/")
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
                 'haskell-mode-hook))

    (add-hook hook '(lambda () (nox-ensure))))
  (add-hook 'python-mode-hook '(lambda () (remove-hook 'completion-at-point-functions 'python-completion-at-point t))))
  ;; (eldoc-box-hover-at-point-mode)
