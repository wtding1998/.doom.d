;; -*- no-byte-compile: t; -*-
;;; dwt/dwt-ui/packages.el

;;; theme
;; (package! spacemacs-theme :recipe (:host github :repo "nashamri/spacemacs-theme"))
(package! joker-theme :recipe (:host github :repo "DogLooksGood/joker-theme"))
(package! printed-theme :recipe (:host github :repo "DogLooksGood/printed-theme"))
(package! storybook-theme :recipe (:host github :repo "DogLooksGood/storybook-theme"))
(package! modus-themes :recipe (:host github :repo "protesilaos/modus-themes"))
(package! solaire-mode :disable t)
;; (package! tao-theme :recipe (:host github :repo "11111000000/tao-theme-emacs"))
;; (package! minimal-theme :recipe (:host github :repo "anler/minimal-theme"))
;; (package! berrys-theme :recipe (:host github :repo "vbuzin/berrys-theme"))
; (package! elegant-theme :recipe (:host github :repo "oracleyue/elegant-theme"))
; (package! nord-emacs :recipe (:host github :repo "arcticicestudio/nord-emacs"))
(package! notink-theme :recipe (:host github :repo "wtding1998/notink-theme"))
;; (package! gruvbox-theme :recipe (:host github :repo "wtding1998/emacs-gruvbox-material"))
; (package! everforest
;   :recipe (:repo "https://git.sr.ht/~theorytoe/everforest-theme"))

(when IS-MAC
  (package! transwin :recipe (:host github :repo "jcs-elpa/transwin")))

(package! awesome-tray :recipe (:host github :repo "manateelazycat/awesome-tray"))
(package! sort-tab :recipe (:host github :repo "manateelazycat/sort-tab"))
(package! awesome-tab :recipe (:host github :repo "manateelazycat/awesome-tab"))
;; (package! evil-terminal-cursor-changer :recipe (:host github :repo "7696122/evil-terminal-cursor-changer"))
(package! shrink-path)
