;; -*- no-byte-compile: t; -*-
;;; dwt/dwt-org/packages.el
;;;
(package! org-fragtog :recipe (:host github :repo "io12/org-fragtog"))
;; (package! org-appear :recipe (:host github :repo "awth13/org-appear"))
(package! zotxt-emacs :recipe (:host github :repo "egh/zotxt-emacs"))
(package! ox-hugo)
(package! org-pomodoro :recipe (:host github :repo "marcinkoziej/org-pomodoro"))
(when IS-MAC
  (package! osx-dictionary :recipe (:host github :repo "xuchunyang/osx-dictionary.el")))
;; (package! org-roam :recipe (:host github :repo "org-roam/org-roam"))
;; (package! org-clock-watch :recipe (:host github :repo "wztdream/org-clock-watch"))
