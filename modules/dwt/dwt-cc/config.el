;;; dwt/dwt-cc/config.el -*- lexical-binding: t; -*-

(add-hook 'c-mode-hook #'(lambda () (setq tab-width 4
                                          evil-shift-width 4)))

;;set file template for c
(set-file-template! "\\.c$" :trigger "__dwtc")

(after! cc-mode
  ;; quick compile function
  (defun dwt/gcc-compile-and-run ()
    (interactive)
    (basic-save-buffer)
    (compile (format "gcc %s && ./a.out" (buffer-file-name))))

  (defun dwt/gcc-compile-and-run-vterm ()
    (interactive)
    (basic-save-buffer)
    (let ((fname (buffer-file-name))
          (dname (file-name-directory (buffer-file-name))))
      (unless (buffer-live-p (get-buffer "*doom:vterm-popup:main*"))
        (vterm "*doom:vterm-popup:main*"))
      (+popup-buffer (get-buffer "*doom:vterm-popup:main*"))
      (+popup/other)
      (vterm-send-string (format "gcc %s && %sa.out" fname dname))
      (vterm-send-return)))

  (map! :map c-mode-map
        :localleader
        :desc "vterm compile run" "m" #'dwt/gcc-compile-and-run-vterm
        :desc "compile run" "M" #'dwt/gcc-compile-and-run)

  (defun dwt/cpp-compile-and-run ()
    (interactive)
    (basic-save-buffer)
    (compile (format "g++ %s && ./a.out" (buffer-file-name))))

  (defun dwt/cpp-compile-and-run-vterm ()
    (interactive)
    (basic-save-buffer)
    (let ((fname (buffer-file-name))
          (dname (file-name-directory (buffer-file-name))))
      (unless (buffer-live-p (get-buffer "*doom:vterm-popup:main*"))
        (vterm "*doom:vterm-popup:main*"))
      (+popup-buffer (get-buffer "*doom:vterm-popup:main*"))
      (+popup/other)
      (vterm-send-string (format "g++ %s && %sa.out" fname dname))
      (vterm-send-return)))

  (map! :map c++-mode-map
        :localleader
        :desc "vterm compile run" "m" #'dwt/cpp-compile-and-run-vterm
        :desc "compile run" "M" #'dwt/cpp-compile-and-run))
