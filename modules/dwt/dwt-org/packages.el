;; -*- no-byte-compile: t; -*-
;;; dwt/dwt-org/packages.el
;;;
(package! org-fragtog :recipe (:host github :repo "io12/org-fragtog"))
;; (package! org-appear :recipe (:host github :repo "awth13/org-appear"))
;; (package! zotxt-emacs :recipe (:host github :repo "egh/zotxt-emacs"))
(package! ox-hugo)
(package! org-pomodoro :recipe (:host github :repo "marcinkoziej/org-pomodoro"))
(when IS-MAC
  (package! osx-dictionary :recipe (:host github :repo "xuchunyang/osx-dictionary.el")))
;; (package! org-roam :recipe (:host github :repo "org-roam/org-roam"))
;; (package! org-clock-watch :recipe (:host github :repo "wztdream/org-clock-watch"))
;; (package! alert :recipe (:host github :repo "jwiegley/alert"))
(package! org-modern :recipe (:host github :repo "minad/org-modern"))
(package! org-download :recipe (:host github :repo "abo-abo/org-download"))
(package! org-roam-bibtex
  :recipe (:host github :repo "org-roam/org-roam-bibtex"))
(package! grip-mode)
(package! ox-gfm)
