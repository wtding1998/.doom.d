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
  (setq org-highlight-latex-and-related '(latex scripe entities))
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
  (plist-put org-format-latex-options :scale 2.7))
;; roam
(setq org-roam-directory "~/OneDrive/Documents/roam")
(map! :leader
      :desc "roam-find-file" "of" #'org-roam-find-file
      :desc "roam-find-ref" "or" #'org-roam-find-ref
      :desc "roam-insert-link" "oi" #'org-roam-insert)

;; (let ((org-id-files (org-roam--list-files org-roam-directory))
;;       org-agenda-files)
;;   (org-id-update-id-locations))


(setq system-time-locale "C")
