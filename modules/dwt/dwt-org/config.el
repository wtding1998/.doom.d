;;; dwt/org/config.el -*- lexical-binding: t; -*-


;; === org-mode ===
;; org-function
(after! org
  (setq org-use-fast-todo-selection t)
  (setq org-todo-keywords '((sequence "TODO(t)" "Wait(w)" "|" "DONE(d)" "DONELOG(l@/!)" "ABORT(a@/!)")))
  (setq org-log-done t)
  (setq org-log-into-drawer t)
  (setq org-enforce-todo-dependencies t)
  (setq org-enforce-todo-checkbox-dependencies t)
  (add-hook (quote org-mode-hook)
            (lambda ()
              (org-shifttab 2)))
  ;; highlight latex related part
  ;; (setq org-highlight-latex-and-related '(latex scripe entities))
  (setq org-highlight-latex-and-related '(native script entities))

  (defun dwt/org-clear-cache ()
    (interactive)
    (delete-directory "~/.emacs.d/.local/cache/org-latex"))

  ;; (setq org-preview-latex-default-process 'dvipng)
  ;; make background of fragments transparent
  ;; (let ((dvipng--plist (alist-get 'dvipng org-preview-latex-process-alist)))
  ;;   (plist-put dvipng--plist :use-xcolor t)
  ;;   (plist-put dvipng--plist :image-converter '("dvipng -D %D -bg 'transparent' -T tight -o %O %f")))

  (let ((dvipng--plist (alist-get 'dvipng org-preview-latex-process-alist)))
    (plist-put dvipng--plist :use-xcolor t)
    (plist-put dvipng--plist :image-converter '("dvipng -D %D -T tight -o %O %f")))
  ;; (add-hook! 'doom-load-theme-hook
  ;;   (defun +org-refresh-latex-background ()
  ;;     (plist-put! org-format-latex-options
  ;;                 :background
  ;;                 (face-attribute (or (cadr (assq 'default face-remapping-alist))
  ;;                                     'default)
  ;;                                 :background nil t))))
  ;; (add-to-list 'org-latex-regexps '("\\ce" "^\\\\ce{\\(?:[^\000{}]\\|{[^\000}]+?}\\)}" 0 nil))
  ;; (use-package! org-fragtog
  ;;   :hook (org-mode . org-fragtog-mode))
  ;; === templates ===
  (setq org-capture-templates nil)
  (add-to-list 'org-capture-templates
               '("a" "Agenda"
                 entry (file+olp "/mnt/d/OneDrive/Documents/diary/org/agenda.org" "Agenda")
                 "* %t - %^{title} %^g\n%?\n"))

  ;; (add-to-list 'org-capture-templates
  ;;              '("p" "Entertainment"
  ;;                entry (file+olp "/mnt/d/OneDrive/Documents/diary/org/agenda.org" "Entertainment")
  ;;                "* %t - %^{title} %^g\n %?"
  ;;                ))
  (add-to-list 'org-capture-templates
               '("d" "Diary"
                 entry (file+datetree "/mnt/d/OneDrive/Documents/diary/org/diary.org")
                 "* %<%H-%M> - %^{heading} \n %?\n"))

  (add-to-list 'org-capture-templates '("e" "English"))
  (add-to-list 'org-capture-templates
               '("ew" "Words"
                 entry (file+olp "/mnt/d/OneDrive/Documents/study note/org/English_note.org" "Words")
                 "* %^{title} \n %?"))

  ;; interesting
  (add-to-list 'org-capture-templates '("i" "Interesting"))
  (add-to-list 'org-capture-templates
               '("it" "Interesting Things"
                 entry (file+datetree "/mnt/d/OneDrive/Documents/study note/org/interesting_things.org")
                 "* %<%H-%M> - %^{heading} \n %?\n"))

  (add-to-list 'org-capture-templates
               '("is" "Interesting Sentences"
                 entry (file "/mnt/d/OneDrive/Documents/study note/org/interesting_sentencse.org")
                 "* %^{Sentence} \n"))

  ;; notes
  (add-to-list 'org-capture-templates '("n" "Notes"))
  (add-to-list 'org-capture-templates
               '("nm" "Math"
                 entry (file+datetree "/mnt/d/OneDrive/Documents/study note/org/math_note.org")
                 "* %^{heading} \n %?\n"))

  (add-to-list 'org-capture-templates
               '("no" "Other Notes"
                 entry (file "/mnt/d/OneDrive/Documents/study note/org/other_note.org")
                 "* %^{heading} \n %?\n"))

  ;; readings
  (add-to-list 'org-capture-templates '("r" "Reading"))
  (add-to-list 'org-capture-templates
               '("rm" "Mathematical Books " entry
                 (file+olp "/mnt/d/OneDrive/Documents/study note/org/reading.org" "Mathematical Books")
                 "* TODO %t %^{title}\n"))
  (add-to-list 'org-capture-templates
               '("rl" "Machine Learning" entry
                 (file+olp "/mnt/d/OneDrive/Documents/study note/org/reading.org" "Machine Learning")
                 "* TODO %t %^{title}\n"))
  (add-to-list 'org-capture-templates
               '("ro" "Other Books" entry
                 (file+olp "/mnt/d/OneDrive/Documents/study note/org/reading.org" "Other Books")
                 "* TODO %t %^{title}\n"))
  (add-to-list 'org-capture-templates
               '("re" "Emacs" entry
                 (file+olp "/mnt/d/OneDrive/Documents/study note/org/reading.org" "Emacs Materials")
                 "* TODO %t %^{title}\n"))
  ;; === cancel bold font in header ===
  (dolist (face '(org-level-1
                  org-level-2 org-level-3
                  org-level-4 org-level-5
                  org-level-6 org-level-7
                  org-level-8))
    (set-face-attribute face nil :weight 'normal))
  ;; set scale for latex-preview
  (plist-put org-format-latex-options :scale 2.7)
  ;; set app
  (setq org-file-apps
        '((auto-mode . emacs)
          ("\\.pdf::\\([0-9]+\\)?\\'" . "zathura %s -P %1")
          ("\\.pdf\\'" . "zathura %s")
          (directory . emacs)))

  (add-hook 'org-mode-hook 'cdlatex-mode)
  (add-hook 'org-mode-hook 'evil-tex-mode)

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
                (left-char 2)
                )
            (insert "\\(\\)")
            (left-char 2)))
      (progn
        (call-interactively #'cdlatex-math-modify))))

  (map! :map org-mode-map
        :i ";" #'dwt/insert-subscript
        :i "\";" #'(lambda () (interactive) (insert ";"))
        :i ":" #'dwt/insert-superscript
        :i "\":" #'(lambda () (interactive) (insert ":"))
        ;; :i "\"" #'dwt/insert-dollar)
        :i "'" #'dwt/insert-inline-math
        :i "\"'" #'(lambda () (interactive) (insert "'"))
        :i "<tab>" #'dwt/tab-in-org
        ;; :i (kbd "<m-n>") #'cdlatex-tab
        )

  (defun dwt/tab-in-org ()
    "If cannot expand snippet, then use cdlatex-tab."
    (interactive)
    (unless (call-interactively 'yas-expand)
      (call-interactively 'cdlatex-tab)))

  (set-company-backend! 'org-mode +latex--company-backends)
  (add-hook 'org-mode-hook '(lambda () (plist-put org-format-latex-options :scale 2.3)))
  (add-hook 'org-roam-mode-hook 'dwt/preview-all-latex)
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
  )

(after! org-roam
  (setq org-roam-capture-templates
        '(
          ("d" "default" plain (function org-roam-capture--get-point)
           "%?"
           :file-name "%${slug}"
           :head "#+title: ${title}\n#+roam_alias:\n\n")))
  (add-to-list 'org-roam-capture-templates
               '("p" "Paper Note" plain (function org-roam-capture--get-point)
                 "* Paper \n\n* TODO \n\n* Problem\n\n%?\n* Idea\n\n* Method\n\n* Result\n\n* My Idea\n"
                 :file-name "%${slug}"
                 :head "#+title: ${title}\n#+roam_alias:\n#+roam_tags: \n\n"
                 :unnarrowed t
                 ))
  (add-to-list 'org-roam-capture-templates
               '("u" "Useful Facts" plain (function org-roam-capture--get-point)
                 "* Problem\n\n%?\n* * Result\n\n* My Idea\n"
                 :file-name "%${slug}"
                 :head "#+title: ${title}\n#+roam_alias:\n#+roam_tags: \n\n"
                 :unnarrowed t
                 ))
  )


;; roam
(setq org-roam-directory "~/OneDrive/Documents/roam")
(map! :leader
      :desc "roam-find-file" "of" #'org-roam-find-file
      :desc "roam-find-ref" "or" #'org-roam-find-ref
      :desc "roam-find-ref" "oc" #'org-roam-capture
      :desc "roam-insert-link" "oi" #'org-roam-insert)

;; (let ((org-id-files (org-roam--list-files org-roam-directory))
;;       org-agenda-files)
;;   (org-id-update-id-locations))


(setq system-time-locale "C")
