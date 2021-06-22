;;; dwt/dwt-cc/config.el -*- lexical-binding: t; -*-

(after! cc-mode
  ;; quick compile function
  (defun dwt/gcc-compile-and-run ()
    (interactive)
    (compile (format "gcc %s && ./a.out" (buffer-file-name))))

  (map! :map c-mode-map
        :localleader
        :desc "gcc compile run" "m" #'dwt/gcc-compile-and-run))
