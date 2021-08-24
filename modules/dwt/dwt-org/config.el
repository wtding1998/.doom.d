;;; dwt/org/config.el -*- lexical-binding: t; -*-


;; === org-mode ===
;; org-function
(after! org
  ;;; remove hl-line
  (add-hook 'org-mode-hook (lambda () (hl-line-mode -1)))
  ;;; clock
  (map! :map org-mode-map :localleader
        "cu" #'org-dblock-update)
  (map! :map org-mode-map "<tab>" nil)
  ;; (add-hook 'org-mode-hook #'cdlatex-mode)
  (add-hook 'org-mode-hook #'evil-tex-mode)
  (add-hook 'org-mode-hook (lambda () (setq word-wrap nil)))
  ;; (add-hook 'org-mode-hook #'org-latex-auto-toggle)
  (map! :map org-mode-map
        :localleader
        "C" #'cdlatex-mode)
  (setq org-use-fast-todo-selection t)
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
  ;; (use-package! org-fragtog
  ;;   :hook (org-roam-mode . org-fragtog-mode))
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
  (add-to-list 'org-capture-templates '("i" "Interesting"))
  (add-to-list 'org-capture-templates
               '("it" "Interesting Things"
                 entry (file+datetree "~/OneDrive/Documents/study note/org/interesting_things.org")
                 "* %<%H-%M> - %^{heading} \n %?\n"))

  (add-to-list 'org-capture-templates
               '("is" "Interesting Sentences"
                 entry (file "~/OneDrive/Documents/study note/org/interesting_sentencse.org")
                 "* %^{Sentence} \n"))

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
  (dolist (face '(org-level-1
                  org-level-2 org-level-3
                  org-level-4 org-level-5
                  org-level-6 org-level-7
                  org-level-8))
    (set-face-attribute face nil :weight 'normal))
  ;; set scale for latex-preview
  (when IS-MAC
    (when dwt/lenovo
      (plist-put org-format-latex-options :scale 2.3)))
  ;; set app
  (setq org-file-apps
        '((auto-mode . emacs)
          ("\\.pdf::\\([0-9]+\\)?\\'" . "zathura %s -P %1")
          ("\\.pdf\\'" . "zathura %s")
          (directory . emacs)))


  (defun dwt/toggle-all-fragments ()
    (interactive)
    (call-interactively 'or))

  (defun dwt/insert-inline-math ()
    "insert inline math when texmathp returns false. if there is a word at point, also wrap it."
    (interactive)
    (if (not (texmathp))
        (progn
          (if (thing-at-point 'word)
              (progn
                (call-interactively #'backward-word)
                (insert "\\(")
                (call-interactively #'forward-word)
                (insert "\\)")
                (left-char 2))

            (insert "\\(\\)")
            (left-char 2)))
      (progn
        (call-interactively #'cdlatex-math-modify))))

  ;; (defun dwt/latex-quote ()
  ;;   (interactive)
  ;;   (let ((enter-char
  ;;          (read-string "Enter Char: ")))
  ;;     (if (string-equal enter-char "\"")
  ;;         (call-interactively 'cdlatex-math-modify-prefix)
  ;;       (insert enter-char))))

  (defun dwt/tab-in-org ()
    "If cannot expand snippet, then use cdlatex-tab."
    (interactive)
    (unless (call-interactively 'yas-expand)
      (call-interactively 'cdlatex-tab)))

  (set-company-backend! 'org-mode +latex--company-backends)
  (defun dwt/preview-all-latex ()
    (interactive)
    (let ((current-prefix-arg '(16)))
      (call-interactively #'org-latex-preview)))
  ;; (require 'dash)

  (defvar-local +org-last-in-latex nil)

  (defun +org-post-command-hook ()
    (ignore-errors
      (let ((in-latex (and (derived-mode-p  'org-mode)
                           (or (org-inside-LaTeX-fragment-p)
                               (org-inside-latex-macro-p)))))
        (if (and +org-last-in-latex (not in-latex))
            (progn (org-latex-preview)
                   (setq +org-last-in-latex nil)))

        (when-let ((ovs (overlays-at (point))))
          (when (->> ovs
                  (--map (overlay-get it 'org-overlay-type))
                  (--filter (equal it 'org-latex-overlay)))
            (org-latex-preview)
            (setq +org-last-in-latex t)))

        (when in-latex
          (setq +org-last-in-latex t)))))

  (define-minor-mode org-latex-auto-toggle
    "Auto toggle latex overlay when cursor enter/leave."
    nil
    nil
    nil
    (if org-latex-auto-toggle
        (add-hook 'post-command-hook '+org-post-command-hook nil t)
      (remove-hook 'post-command-hook '+org-post-command-hook t)))
  (map! :leader "ta" #'org-latex-auto-toggle))

(after! org-agenda
  (setq org-agenda-files '("~/OneDrive/Documents/diary/org/agenda.org"
                           "~/OneDrive/Documents/study note/org/cuhksz.org"
                           "~/OneDrive/Documents/roam/20210114-tensor_diagonalization.org")))

(use-package! org-clock
  :config
  (setq org-clock-mode-line-total 'today))

(use-package! org-roam
  :init
  (if IS-MAC
      (setq org-roam-directory "~/OneDrive/Documents/roam")
      (setq org-roam-directory "~/org/roam"))
  (setq org-roam-v2-ack t)
  ;; (map! :leader :prefix ("nr" . "roam")
  ;;       "f" #'org-roam-node-find
  ;;       "i" #'org-roam-node-insert
  ;;       "t" #'org-roam-buffer-toggle
  ;;       "a" #'org-roam-tag-add
  ;;       "A" #'org-roam-tag-remove
  ;;       "d" #'org-roam-dailies-goto-today
  ;;       "e" #'org-roam-dailies-goto-date)
  (map! :leader "of" #'org-roam-node-find
                "oi" #'org-roam-node-insert
                "oc" #'org-roam-capture
                "oC" #'org-roam-dailies-goto-today)
  :config
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
                              "#+title: %<%Y-%m-%d>")))))
;;; noter
(use-package! org-noter
  ;; :init
  ;; (add-hook 'org-noter-notes-mode-hook #'cdlatex-mode)
  ;; (add-hook 'org-noter-notes-mode-hook #'org-latex-impatient-mode)
  :config
  (setq org-noter-auto-save-last-location t)
  (map! :map org-noter-doc-mode-map
        :localleader
        "q" #'org-noter-kill-session
        "i" #'org-noter-insert-note
        "I" #'org-noter-insert-precise-note)
  (map! :map org-noter-doc-mode-map
        :nvi "ni" #'org-noter-insert-note
        :nvi "nI" #'org-noter-insert-precise-note
        :nvi "i" #'org-noter-insert-note
        :nvi "I" #'org-noter-insert-precise-note
        :nvi "nq" #'org-noter-kill-session)
  (map! :map org-noter-notes-mode-map
        :nv "ni" #'org-noter-sync-current-note
        :nv "nq" #'org-noter-kill-session))

(use-package! org-zotxt
  :after org
  :init
  (defun dwt/open-zotero ()
    (interactive)
    (shell-command "zotero &"))

  (map! :map org-mode-map
        :n "zE" #'org-zotxt-mode
        :n "ze" #'org-zotxt-noter
        :localleader
        "zE" #'org-zotxt-mode
        "ze" #'org-zotxt-noter
        "za" #'org-zotxt-open-attachment
        :desc "zotero" "zt" #'dwt/open-zotero
        "zi" #'org-zotxt-insert-reference-link)
  :config
  (add-to-list 'org-link-parameters '("zotero" :follow org-zotxt-open-attachment))
  ;;TODO bibtex-completion-find-pdf-in-field
  (defun org-zotxt-noter (arg)
    "Like `org-noter', but use Zotero.

If no document path propery is found, will prompt for a Zotero
search to choose an attachment to annotate, then calls `org-noter'.

If a document path property is found, simply call `org-noter'.

See `org-noter' for details and ARG usage."
    (interactive "P")
    (require 'org-noter nil t)
    (unless (eq major-mode 'org-mode)
      (error "Org mode not running"))
    (unless (fboundp 'org-noter)
      (error "`org-noter' not installed"))
    (if (org-before-first-heading-p)
        (error "`org-zotxt-noter' must be issued inside a heading"))
    (let* ((document-property (org-entry-get nil org-noter-property-doc-file (not (equal arg '(4)))))
           (document-path (when (stringp document-property) (expand-file-name document-property))))
      (if (and document-path (not (file-directory-p document-path)) (file-readable-p document-path))
          (call-interactively #'org-noter)
        (let ((arg arg))
          (deferred:$
            (zotxt-choose-deferred)
            (deferred:nextc it
              (lambda (item-ids)
                (zotxt-get-item-deferred (car item-ids) :paths)))
            (deferred:nextc it
              (lambda (item)
                (org-zotxt-get-item-link-text-deferred item)))
            (deferred:nextc it
              (lambda (resp)
                (let ((path (org-zotxt-choose-path (cdr (assq 'paths (plist-get resp :paths))))))
                  ;; (org-entry-put nil org-zotxt-noter-zotero-link (org-zotxt-make-item-link resp))
                  (insert (org-zotxt-make-item-link resp))
                  (org-entry-put nil org-noter-property-doc-file path))
                (call-interactively #'org-noter)))
            (deferred:error it #'zotxt--deferred-handle-error)))))))


;; (let ((org-id-files (org-roam--list-files org-roam-directory))
;;       org-agenda-files)
;;   (org-id-update-id-locations))

(use-package! ox-hugo
  :after ox)

(when IS-MAC
  (use-package! osx-dictionary
    :defer t
    :commands (osx-dictionary-search-input)
    :init
    (map! :g "M-e" #'osx-dictionary-search-input)))

(use-package! ivy-bibtex
  :init
  (setq bibtex-completion-notes-template-multiple-files "Notes on: ${author-or-editor} (${year}): ${title}\n\n* Paper\n")
  (setq bibtex-completion-bibliography '("~/org/tensor.bib"))
  (setq bibtex-completion-notes-path "~/org/roam")
  (setq ivy-bibtex-default-action 'ivy-bibtex-edit-notes)
  :config
  (ivy-set-actions
    'ivy-bibtex
    '(("a" ivy-bibtex-open-any "Open PDF, URL, or DOI")
      ("p" ivy-bibtex-open-pdf "Open PDF")
      ("e" ivy-bibtex-edit-notes "Edit notes")
      ("u" ivy-bibtex-open-url-or-doi "Open URL, or DOI")))
  (setq bibtex-completion-edit-notes-function 'dwt/bibtex-completion-edit-notes)
  (map! :leader :desc "open pdf" "nB" #'dwt/ivy-bibtex-open-pdf)

  (defun dwt/ivy-bibtex-open-pdf ()
    "Open pdf of the choosen bibliography"
    (interactive)
    (let ((ivy-bibtex-default-action 'ivy-bibtex-open-pdf))
      (call-interactively #'ivy-bibtex))))

  ;; (defun dwt/new-note (CANDIDATE)
  ;;   (ivy-bibtex-edit-notes CANDIDATE)
  ;;   (call-interactively #'dwt/insert-org-noter-heading))
  ;; (defun dwt/insert-org-noter-heading ()
  ;;   (interactive)
  ;;   (let* ((cite-key (file-name-base (buffer-name))))
  ;;         (path (car (bibtex-completion-find-pdf-in-field cite-key)))
  ;;     (org-entry-put nil org-noter-property-doc-file path))))

;; (use-package! org-clock-watch
;;   :load-path "~/.emacs.d/.local/straight/repos/org-clock-watch"
;;   :init
;;   ;; (setq org-clock-x11idle-program-name "xprintidle")
;;   (setq org-clock-watch-work-plan-file-path "~/D/OneDrive/Documents/diary/org/agenda.org"))

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
              (insert (bibtex-completion-fill-template
                       entry
                       bibtex-completion-notes-template-multiple-files))
              (let ((path (car (bibtex-completion-find-pdf-in-field key))))
                  (org-entry-put nil org-noter-property-doc-file path))))
                                        ; One file for all notes:
        (unless (and buffer-file-name
                     (f-same? bibtex-completion-notes-path buffer-file-name))
          (find-file-other-window bibtex-completion-notes-path))
        (widen)
        (outline-show-all)
        (goto-char (point-min))
        (if (re-search-forward (format bibtex-completion-notes-key-pattern (regexp-quote key)) nil t)
                                        ; Existing entry found:
            (when (eq major-mode 'org-mode)
              (org-narrow-to-subtree)
              (re-search-backward "^\*+ " nil t)
              (org-cycle-hide-drawers nil)
              (bibtex-completion-notes-mode 1))
                                        ; Create a new entry:
          (goto-char (point-max))
          (save-excursion (insert (bibtex-completion-fill-template
                                   entry
                                   bibtex-completion-notes-template-one-file)))
          (re-search-forward "^*+ " nil t))
        (when (eq major-mode 'org-mode)
          (org-narrow-to-subtree)
          (re-search-backward "^\*+ " nil t)
          (org-cycle-hide-drawers nil)
          (goto-char (point-max))
          (bibtex-completion-notes-mode 1))
        ;; Move point to ‘%?’ if it’s included in the pattern
        (when (save-excursion
                (progn (goto-char (point-min))
                       (re-search-forward "%\\?" nil t)))
          (let ((beginning (match-beginning 0))
                (end (match-end 0)))
            (delete-region beginning end)
            (goto-char beginning)))))))

