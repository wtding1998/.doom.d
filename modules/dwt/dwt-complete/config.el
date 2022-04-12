;;; dwt/company/config.el -*- lexical-binding: t; -*-

(use-package! company
  :diminish
  :defines (company-dabbrev-ignore-case company-dabbrev-downcase)
  :commands company-cancel
  :bind (("M-/" . dwt/company-complete)
         ("C-M-i" . company-complete))
  :hook (after-init . global-company-mode)
  :init
  (setq company-icon-size '(auto-scale . 25))
  (setq
        ;; company-tooltip-align-annotations t
        ;; company-tooltip-limit 12
        company-idle-delay 0
        company-echo-delay (if (display-graphic-p) nil 0)
        company-minimum-prefix-length 1
        company-require-match nil
        company-dabbrev-ignore-case nil
        ;; Number the candidates (use M-1, M-2 etc to select completions).
        company-show-quick-access t
        company-dabbrev-downcase nil
        company-global-modes '(not erc-mode message-mode help-mode
                                   gud-mode eshell-mode shell-mode)))
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
  ;;(set-default company-backends '((company-capf :with company-yasnippet)
   ;;                               (company-dabbrev-code company-keywords company-files company-dabbrev)))
;; (after! anaconda-mode
;;   (set-company-backend! 'anaconda-mode '(company-anaconda)))

;; (after! lsp
;;   ;; (set-company-backend! 'anaconda-mode '(company-anaconda company-yasnippet))
;;   (setq +lsp-company-backends nil))

;; (use-package! company-prescient
;;   :defer t
;;   :init (company-prescient-mode 1))

(use-package! ivy
  :config
  (setq ivy-count-format "%d/%d ")
  (map! :map ivy-minibuffer-map
        "<backtab>" #'ivy-partial
        "C-<return>" #'ivy-immediate-done))

(use-package! ivy-posframe
  :defer t
  :commands (ivy-posframe-mode)
  ;; :hook (ivy-mode . ivy-posframe-mode)
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
