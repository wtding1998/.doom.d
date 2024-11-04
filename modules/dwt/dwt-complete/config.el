;;; dwt/company/config.el -*- lexical-binding: t; -*-

(use-package! company
  :diminish
  :defines (company-dabbrev-ignore-case company-dabbrev-downcase)
  :commands company-cancel
  :bind (("M-/" . company-complete)
         ("C-M-i" . dwt/company-complete))
  :hook (after-init . global-company-mode)
  :init
  (setq company-icon-size '(auto-scale . 25))
  (setq
        company-idle-delay 0
        company-echo-delay (if (display-graphic-p) nil 0)
        company-require-match nil
        company-dabbrev-ignore-case nil
        ;; Number the candidates (use M-1, M-2 etc to select completions).
        company-show-quick-access t
        company-dabbrev-downcase nil)
  :config
  (setq company-idle-delay 0.1
        company-minimum-prefix-length 2)
  (map! :i "C-x C-x" #'dwt/company-existing-commands))
  ;; (defun my-company-yasnippet ()
  ;;   "Hide the current completeions and show snippets."
  ;;   (interactive)
  ;;   (company-cancel)
  ;;   (call-interactively 'company-yasnippet)))
;;; disabel tab in completion
(after! company
  (defun dwt/company-complete ()
    (interactive)
    (if (looking-at "\\S-")
        (save-excursion (insert " ")))
    (company-complete)
    (and company-candidates
          (company-call-frontends 'post-command)))
  (set-company-backend! 'prog-mode
    '(company-capf company-yasnippet company-dabbrev-code) '(company-keywords company-files) '(company-dabbrev))
  (setq +lsp-company-backends '(company-capf :with company-yasnippet))
  ;; (defun dwt/set-company ()
  ;;   (setq company-backends'(company-capf :with company-yasnippet) '(company-dabbrev-code company-keywords company-files) '(company-dabbrev)))
  ;; (add-hook 'python-mode-hook #'dwt/set-company)
  ;; disable tab in company-mode
  (define-key company-active-map (kbd "C-n") nil)
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "C-<RET>") nil)
  (define-key company-mode-map (kbd "C-n") nil)
  (define-key company-mode-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "C-p") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-mode-map (kbd "C-p") nil)
  (define-key company-mode-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "<tab>") nil)
  (define-key company-mode-map (kbd "<tab>") nil)
  (define-key company-search-map (kbd "<tab>") nil)
  (define-key company-active-map (kbd "TAB") nil)
  (define-key company-mode-map (kbd "TAB") nil)
  (define-key company-search-map (kbd "TAB") nil))

(use-package! ivy
  :when (featurep 'ivy)
  :config
  (setq ivy-count-format "%d/%d ")
  (defun dwt/ivy-backward-delete-char ()
    (interactive)
    (let ((dir ivy--directory)
          (p (and ivy--directory (= (minibuffer-prompt-end) (point)))))
      (ivy-backward-delete-char)
      (when p (insert (file-name-nondirectory (directory-file-name dir))))))
  (setq dwt/ivy-ignore-tex-aux-suffix '(".aux" ".bbl" ".fls" ".blg" ".nav" ".snm" ".fdb_latexmk" ".run.xml" "-blx.bib" ".toc" ".synctex.gz" ".out"))
  (dolist (tex-aux-suffix dwt/ivy-ignore-tex-aux-suffix)
    (add-to-list 'ivy-ignore-buffers (concat "\\" tex-aux-suffix))
    (setq counsel-find-file-ignore-regexp (concat "\\(" tex-aux-suffix "$\\)\\|" counsel-find-file-ignore-regexp)))
  (map! :map counsel-find-file-map "C-<backspace>" #'dwt/ivy-backward-delete-char)
  (map! :map ivy-mode-map :leader
        :desc "M-x" "<SPC>" #'counsel-M-x
        :desc "ivy-resume" "`" #'ivy-resume
        :desc "counsel-buffer-or-recentf" ";" #'counsel-buffer-or-recentf
        :desc "fzf" "fz" #'counsel-fzf
        :desc "rg" "fg" #'counsel-rg
        :desc "open by extern program" "fo" #'counsel-find-file-extern
        :desc "kill ring" "sa" #'counsel-yank-pop
      :desc "recent dir" "od" #'dwt/goto-recent-directory
      :desc "project dir" "pd" #'dwt/dired-projectile)
  (map! :map ivy-minibuffer-map
        "C-d" #'ivy-scroll-up-command
        "C-u" #'ivy-scroll-down-command
        "s-<backspace>" #'evil-delete-backward-word
        "<backtab>" #'ivy-partial
        "C-<return>" #'ivy-immediate-done
        "C-<backspace>" #'dwt/ivy-backward-delete-char))

(use-package! ivy-posframe
  :defer t
  :when (featurep 'ivy)
  :commands (ivy-posframe-mode)
  :hook (ivy-mode . ivy-posframe-mode)
  :config
  ;; posframe doesn't work well with async sources (the posframe will
  ;; occasionally stop responding/redrawing), and causes violent resizing of the
  ;; posframe.
  (dolist (fn '(org-roam-node-insert  org-roam-node-find
                counsel-rg counsel-grep counsel-git-grep))
    (setf (alist-get fn ivy-posframe-display-functions-alist)
          #'ivy-display-function-fallback))
  ;; Prettify the buffer
  (defun my-ivy-posframe--prettify-buffer (&rest _)
    "Add top and bottom margin to the prompt."
    (with-current-buffer ivy-posframe-buffer
      (goto-char (point-min))
      (insert (propertize "\n" 'face '(:height 0.3)))
      (goto-char (point-max))
      (insert (propertize "\n" 'face '(:height 0.3)))))
  (advice-add #'ivy-posframe--display :after #'my-ivy-posframe--prettify-buffer)

  (defun posframe-poshandler-frame-center-near-bottom (info)
    (cons (/ (- (plist-get info :parent-frame-width)
                (plist-get info :posframe-width))
            2)
          (/ (plist-get info :parent-frame-height)
            2)))
  ;; Adjust the postion
  (defun ivy-posframe-display-at-frame-center-near-bottom (str)
    (ivy-posframe--display str #'posframe-poshandler-frame-center-near-bottom))
  (setf (alist-get t ivy-posframe-display-functions-alist)
        #'ivy-posframe-display-at-frame-center-near-bottom)

  (setq ivy-posframe-width 150
        ivy-posframe-border-width 3
        ivy-posframe-parameters '((left-fringe . 8)
                                  (right-fringe . 8))))

(use-package! company-english-helper
  :after (org latex)
  :config
  (map! :i "C-x C-d" #'company-english-helper-search))

(use-package corfu
  :commands (corfu-mode)
  ;; TAB-and-Go customizations
  :config
  (setq corfu-auto t
        corfu-auto-delay 0.0
        corfu-auto-prefix 1)
  (map! :map corfu-map
        "C-j" #'corfu-next
        "C-k" #'corfu-previous)
  ;; Use TAB for cycling, default is `corfu-complete'.
  :bind
  (:map corfu-map
        ("TAB" . corfu-next)
        ([tab] . corfu-next)
        ("S-TAB" . corfu-previous)
        ([backtab] . corfu-previous)
        ("<escape>" . corfu-quit)))
  ;; (global-corfu-mode)

  ;;
;; Add extensions
;; (use-package! cape
;;   :after corfu
;;   ;; Bind dedicated completion commands
;;   ;; Alternative prefix keys: C-c p, M-p, M-+, ...
;;   :bind (("C-c p p" . completion-at-point) ;; capf
;;          ("C-c p t" . complete-tag)        ;; etags
;;          ("C-c p d" . cape-dabbrev)        ;; or dabbrev-completion
;;          ("C-c p h" . cape-history)
;;          ("C-c p f" . cape-file)
;;          ("C-c p k" . cape-keyword)
;;          ("C-c p s" . cape-elisp-symbol)
;;          ("C-c p a" . cape-abbrev)
;;          ("C-c p i" . cape-ispell)
;;          ("C-c p l" . cape-line)
;;          ("C-c p w" . cape-dict)
;;          ("C-c p \\" . cape-tex)
;;          ("C-c p _" . cape-tex)
;;          ("C-c p ^" . cape-tex)
;;          ("C-c p &" . cape-sgml)
;;          ("C-c p r" . cape-rfc1345))
;;   :init
;;   ;; Add `completion-at-point-functions', used by `completion-at-point'.
;;   (add-to-list 'completion-at-point-functions #'cape-file)
;;   (add-to-list 'completion-at-point-functions #'cape-ispell)
;;   (add-to-list 'completion-at-point-functions #'cape-dabbrev)
;;   ;;(add-to-list 'completion-at-point-functions #'cape-history)
;;   (add-to-list 'completion-at-point-functions #'cape-keyword)
;;   (add-to-list 'completion-at-point-functions #'cape-tex))
  ;;(add-to-list 'completion-at-point-functions #'cape-sgml)
  ;;(add-to-list 'completion-at-point-functions #'cape-rfc1345)
  ;;(add-to-list 'completion-at-point-functions #'cape-abbrev)
  ;;(add-to-list 'completion-at-point-functions #'cape-dict)
  ;;(add-to-list 'completion-at-point-functions #'cape-line)

;; (use-package! counsel
;;   :config
;;   (map! :leader "im" #'counsel-evil-marks))

(use-package! vertico
  :config

  ;; https://emacs-china.org/t/package-buffer-name/28111/8?u=ldiwlty
  (defun my-project-root ()
    (when-let ((project (project-current nil)))
      (if (fboundp #'project-root)
          (project-root project)
        (car (project-root project)))))

  (define-advice consult--buffer-pair (:around (_ buffer) show-path)
    "Also show path for file buffers so the user can filter them by path."
    (let ((dir (or (my-project-root) default-directory)))
      (if-let ((path (buffer-file-name buffer)))
          (progn (when (file-in-directory-p path dir)
                  (setq path (file-relative-name path dir)))
                (cons path buffer))
        (cons (buffer-name buffer) buffer))))

  (map! :mode vertico-mode :leader
        :desc "M-x" "<SPC>" #'execute-extended-command
        :desc "recentf" ";" #'recentf-open-files
        :desc "repeat" "`" #'vertico-repeat
        :desc "kill ring" "sa" #'consult-yank-pop
        :desc "recent tex" "ft" #'dwt/consult-recent-tex-file
        :desc "consult-dir" "fd" #'consult-dir)

  (map! :map vertico-map
        ;; "C-d" #'vertico-scroll-up
        "C-d" #'vertico-scroll-up
        "C-u" #'vertico-scroll-down
        "C-'" #'vertico-quick-jump
        "C-h" nil
        "C-<backspace>" (lambda () (interactive) (delete-char -1))))

(use-package! embark
  :config
  (map! :n "g[" #'embark-dwim)
  (map! :map embark-file-map ">" #'dwt/embark-insert-file-name)

  (defun dwt/embark-copy-grep-results (strings)
    "Extract content from consult-ripgrep STRINGS by removing the file path and line number."
    (let ((matched-string strings))
      (when (string-match "^[^:]+:[0-9]+:\\(.*\\)" strings)
            (setq matched-string (match-string 1 strings)))
      (message "Copied: %s" matched-string)
      (kill-new matched-string)))

  (map! :map embark-general-map "W" #'dwt/embark-copy-grep-results))

(use-package! consult-todo
  :defer t
  :commands (consult-todo consult-todo-project)
  :init
  (map! :leader
        :desc "todo" "st" #'consult-todo
        :desc "todo-project" "sT" #'consult-todo-project))
