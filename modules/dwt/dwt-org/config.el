;;; dwt/org/config.el -*- lexical-binding: t; -*-


;; === org-mode ===
;; org-function
(after! org
  ;;; restore windows after quiting agenda
  (setq org-agenda-restore-windows-after-quit t)
  ;;; remove hl-line
  (add-hook 'org-mode-hook (lambda () (hl-line-mode -1)))
  ;;; clock
  (map! :map org-mode-map :localleader
        "cu" #'org-dblock-update)
  (map! :map org-mode-map "<tab>" nil)
  ;; (add-hook 'org-mode-hook #'cdlatex-mode)
  (add-hook 'org-mode-hook #'evil-tex-mode)
  (add-hook 'org-mode-hook (lambda () (setq word-wrap nil)))
  (map! :map org-mode-map
        :localleader
        "C" #'cdlatex-mode)
  (setq org-use-fast-todo-selection t)
  (map! :map org-agenda-mode-map
        :n "ci" #'org-agenda-clock-in)
  (map! :map org-agenda-mode-map
        :m "go" #'evil-avy-goto-line)
  (setq org-todo-keywords '((sequence "TODO(t)" "Wait(w)" "|" "DONE(d)" "DONELOG(l@/!)" "ABORT(a@/!)")))
  (setq org-log-done t)
  (setq org-export-with-toc nil)
  (setq org-log-into-drawer t)
  (setq org-enforce-todo-dependencies t)
  (setq org-enforce-todo-checkbox-dependencies t)
  (setq org-fontify-done-headline t)
  (add-hook (quote org-mode-hook)
            (lambda ()
              (org-shifttab 2)))
  ;; highlight latex related part
  (setq org-highlight-latex-and-related '(latex script entities))
  ;; (setq org-highlight-latex-and-related '(native script entities))

  (defun dwt/org-clear-cache ()
    (interactive)
    (shell-command "rm -rf ~/.emacs.d/.local/cache/org-latex"))
  (evil-define-key 'normal org-mode-map (kbd "<SPC>mR") #'dwt/org-clear-cache)
  ;; (setq org-preview-latex-default-process 'dvipng)
  ;; make background of fragments transparent
  ;; (let ((dvipng--plist (alist-get 'dvipng org-preview-latex-process-alist)))
  ;;   (plist-put dvipng--plist :use-xcolor t)
  ;;   (plist-put dvipng--plist :image-converter '("dvipng -D %D -bg 'transparent' -T tight -o %O %f")))

  ;; (let ((dvipng--plist (alist-get 'dvipng org-preview-latex-process-alist)))
  ;;   (plist-put dvipng--plist :use-xcolor t)
  ;;   (plist-put dvipng--plist :image-converter '("dvipng -D %D -T tight -o %O %f")))
  ;;
  ;; (add-hook! 'doom-load-theme-hook
  ;;   (defun +org-refresh-latex-background ()
  ;;     (plist-put! org-format-latex-options
  ;;                 :background
  ;;                 (face-attribute (or (cadr (assq 'default face-remapping-alist))
  ;;                                     'default)
  ;;                                 :background nil t))))
  ;; (add-to-list 'org-latex-regexps '("\\ce" "^\\\\ce{\\(?:[^\000{}]\\|{[^\000}]+?}\\)}" 0 nil))
  ;; === templates ===
  (setq org-capture-templates nil)
  (add-to-list 'org-capture-templates
               '("a" "Agenda"
                 entry (file+olp "~/OneDrive/Documents/diary/org/agenda.org" "Agenda")
                 "* %t - %^{title} %^g\n%?\n"))

  ;; (add-to-list 'org-capture-templates
  ;;              '("p" "Entertainment"
  ;;                entry (file+olp "~/OneDrive/Documents/diary/org/agenda.org" "Entertainment")
  ;;                "* %t - %^{title} %^g\n %?"
  ;;                ))
  (add-to-list 'org-capture-templates
               '("d" "Diary"
                 entry (file+datetree "~/OneDrive/Documents/diary/org/diary.org")
                 "* %<%H-%M> - %?\n"))

  (add-to-list 'org-capture-templates '("e" "English"))
  (add-to-list 'org-capture-templates
               '("ew" "Words"
                 entry (file+olp "~/OneDrive/Documents/study note/org/English_note.org" "Words")
                 "* %^{title} \n %?"))

  ;; interesting
  ;; (add-to-list 'org-capture-templates '("i" "Interesting"))
  (add-to-list 'org-capture-templates
               '("i" "Interesting Things"
                 entry (file+datetree "~/OneDrive/Documents/study note/org/interesting_things.org")
                 "* %<%H-%M> - %^{heading} \n %?"))

  ;; (add-to-list 'org-capture-templates
  ;;              '("is" "Interesting Sentences"
  ;;                entry (file "~/OneDrive/Documents/study note/org/interesting_sentencse.org")
  ;;                "* %^{Sentence} \n"))

  ;; notes
  (add-to-list 'org-capture-templates '("n" "Notes"))
  (add-to-list 'org-capture-templates
               '("nm" "Math"
                 entry (file+datetree "~/OneDrive/Documents/study note/org/math_note.org")
                 "* %^{heading} \n %?\n"))

  (add-to-list 'org-capture-templates
               '("no" "Other Notes"
                 entry (file "~/OneDrive/Documents/study note/org/other_note.org")
                 "* %^{heading} \n %?\n"))

  ;; readings
  (add-to-list 'org-capture-templates '("r" "Reading"))
  (add-to-list 'org-capture-templates
               '("rm" "Mathematical Books " entry
                 (file+olp "~/OneDrive/Documents/study note/org/reading.org" "Mathematical Books")
                 "* TODO %t %^{title}\n"))
  (add-to-list 'org-capture-templates
               '("rl" "Machine Learning" entry
                 (file+olp "~/OneDrive/Documents/study note/org/reading.org" "Machine Learning")
                 "* TODO %t %^{title}\n"))
  (add-to-list 'org-capture-templates
               '("ro" "Other Books" entry
                 (file+olp "~/OneDrive/Documents/study note/org/reading.org" "Other Books")
                 "* TODO %t %^{title}\n"))
  (add-to-list 'org-capture-templates
               '("re" "Emacs" entry
                 (file+olp "~/OneDrive/Documents/study note/org/reading.org" "Emacs Materials")
                 "* TODO %t %^{title}\n"))
  ;; === cancel bold font in header ===
  ;; (dolist (face '(org-level-1
  ;;                 org-level-2 org-level-3
  ;;                 org-level-4 org-level-5
  ;;                 org-level-6 org-level-7
  ;;                 org-level-8))
  ;;   (set-face-attribute face nil :weight 'normal))
  ;; set scale for latex-preview
  (when dwt/lenovo
    (plist-put org-format-latex-options :scale 2.3)
    ;; set app
    (setq org-file-apps
          '((auto-mode . emacs)
            ("\\.pdf::\\([0-9]+\\)?\\'" . "zathura %s -P %1")
            ("\\.pdf\\'" . "zathura %s")
            (directory . emacs))))

  (set-company-backend! 'org-mode '(company-math-symbols-latex company-latex-commands company-yasnippet company-dabbrev))

  (defun dwt/preview-all-latex ()
    (interactive)
    (let ((current-prefix-arg '(16)))
      (call-interactively #'org-latex-preview)))
  ;; org-agenda
  (setq org-agenda-files '("~/OneDrive/Documents/diary/org/agenda.org"
                           "~/OneDrive/Documents/study note/org/cuhksz.org"))
  ;; org-clock
  (setq org-clock-mode-line-total 'today))

;; roam
(map! :leader "of" #'org-roam-node-find
              "oi" #'org-roam-node-insert
              "oc" #'org-roam-capture
              "oC" #'org-roam-dailies-goto-today)
(after! org-roam
  (defun dwt/org-roam-fix-hash ()
    "fix error: org-id-add-location: Wrong type argument: hash-table-p, nil"
    (interactive)
    (org-id-update-id-locations (directory-files-recursively org-roam-directory ".org$\\|.org.gpg$")))

  (setq +org-roam-open-buffer-on-find-file nil)
  (setq org-roam-capture-templates
        '(("d" "default" plain "%?"
            :if-new (file+head "${slug}.org" "#+title: ${title}\n")
            :unnarrowed t)))
  (add-to-list 'org-roam-capture-templates
               '("p" "Paper Note" plain "* TODO %<%Y-%m-%d-%H-%M> - %?"
                 :if-new (file+head "${slug}.org" "#+title: ${title}\n#+filetags:paper \n\n* Paper\n\n* Summary\n** Idea\n** Method\n** Result\n** My Idea\n")
                 :unnarrowed t))
  (add-to-list 'org-roam-capture-templates
               '("b" "Book Note" plain "* %<%Y-%m-%d-%H-%M> - %?"
                 :if-new (file+head "${slug}.org" "#+title: ${title}\n#+filetags:book \n\n* Book\n\n* Summary")
                 :unnarrowed t))
  (add-to-list 'org-roam-capture-templates
               '("r" "Research Note" plain "* TODO %<%Y-%m-%d-%H-%M> - %?"
                 :if-new (file+head "${slug}.org" "#+title: ${title}\n#+filetags:research\n\n* Problem\n\n* Result\n* My Idea\n")
                 :unnarrowed t))
  (setq org-roam-dailies-capture-templates
        '(("d" "default" plain ""
            :if-new (file+head "%<%Y-%m-%d>.org"
                              "#+title: %<%Y-%m-%d>"))))

  ;; from  https://github.com/d12frosted/vulpea/blob/fd2acf7b8e11dd9c38f9adf862b76db5545a9d51/vulpea-buffer.el
  (defun vulpea-project-update-tag ()
      "Update PROJECT tag in the current buffer."
      (when (and (not (active-minibuffer-window))
                (vulpea-buffer-p))
        (save-excursion
          (if (vulpea-project-p)
              (org-roam-tag-add '("project"))
              (if (vulpea-buffer-prop-get "filetags")
                (if (string-match "project" (vulpea-buffer-prop-get "filetags"))
                  (org-roam-tag-remove '("project"))))))))

  ;; from https://d12frosted.io/posts/2021-01-16-task-management-with-roam-vol5.html
  (defun vulpea-buffer-prop-get (name)
    "Get a buffer property called NAME as a string."
    (org-with-point-at 1
      (when (re-search-forward (concat "^#\\+" name ": \\(.*\\)")
                              (point-max) t)
        (let ((value (string-trim
                      (buffer-substring-no-properties
                        (match-beginning 1)
                        (match-end 1)))))
          (unless (string-empty-p value)
            value)))))

  (defun vulpea-buffer-p ()
    "Return non-nil if the currently visited buffer is a note."
    (if IS-LINUX
      (and buffer-file-name
          (string-prefix-p
            (expand-file-name (file-name-as-directory "/mnt/d/OneDrive/Documents/roam"))
            (file-name-directory buffer-file-name)))
      (and buffer-file-name
          (string-prefix-p
            (expand-file-name (file-name-as-directory "~/OneDrive/Documents/roam"))
            (file-name-directory buffer-file-name)))))

  (defun vulpea-project-files ()
      "Return a list of note files containing 'project' tag." ;
      (seq-uniq
        (seq-map
          #'car
          (org-roam-db-query
            [:select [nodes:file]
              :from tags
              :left-join nodes
              :on (= tags:node-id nodes:id)
              :where (like tag (quote "%\"project\"%"))]))))

  (defun vulpea-project-p ()
    (seq-find                                 ; (3)
      (lambda (type)
        (eq type 'todo))
      (org-element-map                         ; (2)
          (org-element-parse-buffer 'headline) ; (1)
          'headline
        (lambda (h)
          (org-element-property :todo-type h)))))

  (defun inject-vulpea-project-files (org-agenda-files--output)
    (append org-agenda-files--output (vulpea-project-files)))

  (advice-add 'org-agenda-files :filter-return #'inject-vulpea-project-files)

  (add-hook 'before-save-hook #'vulpea-project-update-tag))

;;; noter
(after! org-noter
  (setq org-noter-auto-save-last-location t)
  (map! :map org-noter-doc-mode-map
        :nvi "ni" #'org-noter-insert-note
        :nvi "nI" #'org-noter-insert-precise-note
        :nvi "i" #'org-noter-insert-note
        :nvi "I" #'org-noter-insert-precise-note
        :nvi "nq" #'org-noter-kill-session)
  (map! :map org-noter-notes-mode-map
        :nv "I" #'org-noter-sync-current-note
        :nv "J" #'other-window
        :nv "ni" #'org-noter-sync-current-note
        :nv "nq" #'org-noter-kill-session))

;; (use-package! org-zotxt
;;   :after org
;;   :init
;;   (defun dwt/open-zotero ()
;;     (interactive)
;;     (shell-command "zotero &"))

;;   (map! :map org-mode-map
;;         :n "zE" #'org-zotxt-mode
;;         :n "ze" #'org-zotxt-noter
;;         :localleader
;;         "zE" #'org-zotxt-mode
;;         "ze" #'org-zotxt-noter
;;         "za" #'org-zotxt-open-attachment
;;         :desc "zotero" "zt" #'dwt/open-zotero
;;         "zi" #'org-zotxt-insert-reference-link)
;;   :config
;;   (add-to-list 'org-link-parameters '("zotero" :follow org-zotxt-open-attachment))
;;   ;;TODO bibtex-completion-find-pdf-in-field
;;   (defun org-zotxt-noter (arg)
;;     "Like `org-noter', but use Zotero.

;; If no document path propery is found, will prompt for a Zotero
;; search to choose an attachment to annotate, then calls `org-noter'.

;; If a document path property is found, simply call `org-noter'.

;; See `org-noter' for details and ARG usage."
;;     (interactive "P")
;;     (require 'org-noter nil t)
;;     (unless (eq major-mode 'org-mode)
;;       (error "Org mode not running"))
;;     (unless (fboundp 'org-noter)
;;       (error "`org-noter' not installed"))
;;     (if (org-before-first-heading-p)
;;         (error "`org-zotxt-noter' must be issued inside a heading"))
;;     (let* ((document-property (org-entry-get nil org-noter-property-doc-file (not (equal arg '(4)))))
;;            (document-path (when (stringp document-property) (expand-file-name document-property))))
;;       (if (and document-path (not (file-directory-p document-path)) (file-readable-p document-path))
;;           (call-interactively #'org-noter)
;;         (let ((arg arg))
;;           (deferred:$
;;             (zotxt-choose-deferred)
;;             (deferred:nextc it
;;               (lambda (item-ids)
;;                 (zotxt-get-item-deferred (car item-ids) :paths)))
;;             (deferred:nextc it
;;               (lambda (item)
;;                 (org-zotxt-get-item-link-text-deferred item)))
;;             (deferred:nextc it
;;               (lambda (resp)
;;                 (let ((path (org-zotxt-choose-path (cdr (assq 'paths (plist-get resp :paths))))))
;;                   ;; (org-entry-put nil org-zotxt-noter-zotero-link (org-zotxt-make-item-link resp))
;;                   (insert (org-zotxt-make-item-link resp))
;;                   (org-entry-put nil org-noter-property-doc-file path))
;;                 (call-interactively #'org-noter)))
;;             (deferred:error it #'zotxt--deferred-handle-error)))))))


(use-package! ox-hugo
  :after ox)

(when IS-MAC
  (use-package! osx-dictionary
    :defer t
    :commands (osx-dictionary-search-input)
    :init
    (map! :g "M-e" #'osx-dictionary-search-input)))

(after! ivy-bibtex
  (setq bibtex-completion-notes-template-multiple-files "${=key=}\n#+filetags:paper \n${author-or-editor} (${year}): ${title}\n* ${author-or-editor} (${year}): ${title}\n")
  ;; (setq bibtex-completion-bibliography '("~/org/tensor.bib" "~/org/second-optim.bib" "~/org/matrix-SD.bib" "~/org/book.bib" "~/org/manifold.bib" "~/org/optimization.bib"))
  (setq bibtex-completion-bibliography '("~/OneDrive/Documents/Zotero/library.bib"))
  (setq bibtex-completion-notes-path "~/org/roam")
  (setq ivy-bibtex-default-action 'ivy-bibtex-edit-notes)
  (ivy-set-actions
    'ivy-bibtex
    '(("p" ivy-bibtex-open-pdf "Open PDF")
      ;; ("a" ivy-bibtex-open-any "Open PDF, URL, or DOI")
      ("i" ivy-bibtex-insert-bibtex "Insert Bibtex")
      ("e" ivy-bibtex-edit-notes "Edit notes")
      ("u" ivy-bibtex-open-url-or-doi "Open URL, or DOI")))
  (setq bibtex-completion-edit-notes-function 'dwt/bibtex-completion-edit-notes)
  (map! :leader :desc "open pdf" "nB" #'dwt/ivy-bibtex-open-pdf)

  (defun dwt/ivy-bibtex-open-pdf ()
    "Open pdf of the choosen bibliography"
    (interactive)
    (let ((ivy-bibtex-default-action 'ivy-bibtex-open-pdf))
      (call-interactively #'ivy-bibtex))))

;;;###autoload
(defun dwt/bibtex-completion-edit-notes(keys)
  "Open the notes associated with the entries in KEYS.
Creates new notes where none exist yet."
  (dolist (key keys)
    (let* ((entry (bibtex-completion-get-entry key))
           (year (or (bibtex-completion-get-value "year" entry)
                     (car (split-string (bibtex-completion-get-value "date" entry "") "-"))))
           (entry (push (cons "year" year) entry)))
      (if (and bibtex-completion-notes-path
               (f-directory? bibtex-completion-notes-path))
                                        ; One notes file per publication:
          (let* ((path (f-join bibtex-completion-notes-path
                               (s-concat key bibtex-completion-notes-extension))))
            (find-file path)
            (unless (f-exists? path)
              ;; First expand BibTeX variables, then org-capture template vars:
              (call-interactively #'org-id-get-create)
              (insert (bibtex-completion-fill-template
                       entry
                       bibtex-completion-notes-template-multiple-files))
              (let ((path (car (bibtex-completion-find-pdf-in-field key))))
                  (org-entry-put nil org-noter-property-doc-file path))
              (call-interactively #'evil-force-normal-state)))))))

(after! flyspell
  (map! :leader :desc "flyspell" "ts" #'flyspell-mode
                :desc "prog flyspell" "tS" #'flyspell-prog-mode))

(when IS-LINUX
  (use-package! ispell
    :config
    (setq ispell-dictionary "en_US"
          ispell-program-name "hunspell")))

(use-package! org-fragtog
  :after org
  :hook (org-roam-mode . org-fragtog-mode))
