;; -*- no-byte-compile: t; -*-
;;; dwt/rime/packages.el


;; === rime ===
(package! rime :recipe (:host github :repo "DogLooksGood/emacs-rime" :files ("*.el" "Makefile" "lib.c")))
(package! posframe :recipe (:host github :repo "tumashu/posframe"))
