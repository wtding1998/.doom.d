;;; dwt/company/config.el -*- lexical-binding: t; -*-

(use-package! company
  :diminish
  :defines (company-dabbrev-ignore-case company-dabbrev-downcase)
  :commands company-cancel
  :bind (("M-/" . company-complete)
         ("C-M-i" . company-complete))
        ;; :map company-active-map
        ;; ("C-p" . nil)
        ;; ("C-n" . nil)
        ;; ("C-<RET>" . nil)
        ;; ("<backtab>" . my-company-yasnippet)
        ;; :map company-search-map
        ;; ("C-p" . company-select-previous)
        ;; ("C-n" . company-select-next))
  :hook (after-init . global-company-mode)
  :init
  (add-hook 'sh-mode-hook (lambda () (interactive) (company-mode -1)))
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
                                   gud-mode eshell-mode shell-mode))
  ;; company-frontends '(company-pseudo-tooltip-frontend
  ;;                     company-echo-metadata-frontend)
  ;; company-backends '((company-capf :with company-yasnippet)
  ;;                    (company-dabbrev-code company-keywords company-files)
  ;;                    company-dabbrev))
  (defun my-company-yasnippet ()
    "Hide the current completeions and show snippets."
    (interactive)
    (company-cancel)
    (call-interactively 'company-yasnippet)))
  ;; :config
  ;; ;; `yasnippet' integration
  ;; (with-no-warnings
  ;;   (with-eval-after-load 'yasnippet
  ;;     (defun company-backend-with-yas (backend)
  ;;       "Add `yasnippet' to company backend."
  ;;       (if (and (listp backend) (member 'company-yasnippet backend))
  ;;           backend
  ;;         (append (if (consp backend) backend (list backend))
  ;;                 '(:with company-yasnippet))))

  ;;     (defun my-company-enbale-yas (&rest _)
  ;;       "Enable `yasnippet' in `company'."
  ;;       (setq company-backends (mapcar #'company-backend-with-yas company-backends)))

  ;;     (defun my-lsp-fix-company-capf ()
  ;;       "Remove redundant `comapny-capf'."
  ;;       (setq company-backends
  ;;             (remove 'company-backends (remq 'company-capf company-backends))))
  ;;     (advice-add #'lsp-completion--enable :after #'my-lsp-fix-company-capf)

  ;;     (defun my-company-yasnippet-disable-inline (fun command &optional arg &rest _ignore)
  ;;       "Enable yasnippet but disable it inline."
  ;;       (if (eq command 'prefix)
  ;;           (when-let ((prefix (funcall fun 'prefix)))
  ;;             (unless (memq (char-before (- (point) (length prefix)))
  ;;                           '(?. ?< ?> ?\( ?\) ?\[ ?{ ?} ?\" ?' ?`))
  ;;               prefix))
  ;;         (progn
  ;;           (when (and (bound-and-true-p lsp-mode)
  ;;                      arg (not (get-text-property 0 'yas-annotation-patch arg)))
  ;;             (let* ((name (get-text-property 0 'yas-annotation arg))
  ;;                    (snip (format "%s (Snippet)" name))
  ;;                    (len (length arg)))
  ;;               (put-text-property 0 len 'yas-annotation snip arg)
  ;;               (put-text-property 0 len 'yas-annotation-patch t arg)))
  ;;           (funcall fun command arg))))
  ;;     (advice-add #'company-yasnippet :around #'my-company-yasnippet-disable-inline))))

;; ;; enable company-yasnippet
;;   (defvar company-mode/enable-yas t
;;     "Enable yasnippet for all backends.")

;;   (defun company-mode/backend-with-yas (backend)
;;     (if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)))
;;         backend
;;       (append (if (consp backend) backend (list backend))
;;               '(:with company-yasnippet))))

;;   (setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))

  ;; ;; `yasnippet' integration
  ;; (with-no-warnings
  ;;   (with-eval-after-load 'yasnippet
  ;;     (defun company-backend-with-yas (backend)
  ;;       "Add `yasnippet' to company backend."
  ;;       (if (and (listp backend) (member 'company-yasnippet backend))
  ;;           backend
  ;;         (append (if (consp backend) backend (list backend))
  ;;                 '(:with company-yasnippet))))

  ;;     (defun my-company-enbale-yas (&rest _)
  ;;       "Enable `yasnippet' in `company'."
  ;;       (setq company-backends (mapcar #'company-backend-with-yas company-backends)))
  ;;     ;; Enable in current backends
  ;;     (my-company-enbale-yas)
  ;;     ;; Enable in `lsp-mode'
  ;;     (advice-add #'lsp--auto-configure :after #'my-company-enbale-yas)

  ;;     (defun my-company-yasnippet-disable-inline (fun command &optional arg &rest _ignore)
  ;;       "Enable yasnippet but disable it inline."
  ;;       (if (eq command 'prefix)
  ;;           (when-let ((prefix (funcall fun 'prefix)))
  ;;             (unless (memq (char-before (- (point) (length prefix)))
  ;;                           '(?. ?< ?> ?\( ?\) ?\[ ?{ ?} ?\" ?' ?`))
  ;;               prefix))
  ;;         (progn
  ;;           (when (and (bound-and-true-p lsp-mode)
  ;;                      arg (not (get-text-property 0 'yas-annotation-patch arg)))
  ;;             (let* ((name (get-text-property 0 'yas-annotation arg))
  ;;                    (snip (format "%s (Snippet)" name))
  ;;                    (len (length arg)))
  ;;               (put-text-property 0 len 'yas-annotation snip arg)
  ;;               (put-text-property 0 len 'yas-annotation-patch t arg)))
  ;;           (funcall fun command arg))))
  ;;     (advice-add #'company-yasnippet :around #'my-company-yasnippet-disable-inline))))
;;; disabel tab in completion
(after! company
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
