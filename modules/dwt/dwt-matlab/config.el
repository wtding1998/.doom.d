;;; dwt/dwt-matlab/config.el -*- lexical-binding: t; -*-
(use-package! matlab
  :defer t
  :hook ((matlab-mode . hl-todo-mode))
  :init
  (add-to-list 'auto-mode-alist '("\\.m\\'" . matlab-mode))
  (setq matlab-shell-command-switches (list "-nodesktop"))
  (setq matlab-shell-command "/Applications/MATLAB_R2021a.app/bin/matlab")
  :commands (matlab-mode)
  :config
  (matlab-cedet-setup)
  (load-library "matlab-load")
  (map! :map matlab-mode-map "C-<return>" nil)
  (map! :map matlab-mode-map :localleader "l" :desc "mlint" #'mlint-minor-mode
                                          "c" :desc "run cell" #'matlab-shell-run-cell
                                          "r" :desc "run cell" #'matlab-shell-run-region
                                          "s" :desc "shell" #'matlab-shell))

(use-package! mlint
  :defer t
  :commands (mlint-minor-mode)
  :config
  (add-to-list 'mlint-programs "/Applications/MATLAB_R2021a.app/bin/maci64/mlint") ;; add mlint program for macOS
  (setq matlab-shell-command "/Applications/MATLAB_R2021a.app/bin/matlab"))

(use-package matlab-shell
  :defer t
  :commands (matlab-shell)
  :config
  (set-popup-rules!
    ;; '(("^\\*Python*" :side right :size 15 :select t)))
    '(("^\\*MATLAB*" :size 15 :select t))))
