;;; dwt/dwt-matlab/config.el -*- lexical-binding: t; -*-
(use-package! matlab
  :load-path "~/mycode/matlab-emacs"
  :defer t
  :hook ((matlab-mode . display-line-numbers-mode)
         (matlab-mode . hl-todo-mode))
  :init
  (add-to-list 'auto-mode-alist '("\\.m\\'" . matlab-mode))
  :commands (matlab-mode)
  :config
  (load-library "matlab-load")
  (map! :map matlab-mode-map "C-<return>" nil)
  (map! :map matlab-mode-map :localleader "l" :desc "mlint" #'mlint-minor-mode
                                          "s" :desc "shell" #'matlab-shell))

(use-package! mlint
  :defer t
  :commands (mlint-minor-mode))

(use-package matlab-shell
  :defer t
  :commands (matlab-shell)
  :config
  (set-popup-rules!
    ;; '(("^\\*Python*" :side right :size 15 :select t)))
    '(("^\\*MATLAB*" :size 15 :select t))))
