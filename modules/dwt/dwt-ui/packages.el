;; -*- no-byte-compile: t; -*-
;;; dwt/dwt-ui/packages.el
(package! awesome-tab :recipe (:host github :repo "manateelazycat/awesome-tab"))
(package! evil-terminal-cursor-changer :recipe (:host github :repo "7696122/evil-terminal-cursor-changer"))
;; (package! spacemacs-theme :recipe (:host github :repo "nashamri/spacemacs-theme"))
(package! emacs-kaolin-themes :recipe (:host github :repo "ogdenwebb/emacs-kaolin-themes"))
(package! autothemer)
(package! joker-theme :recipe (:host github :repo "DogLooksGood/joker-theme"))
(package! printed-theme :recipe (:host github :repo "DogLooksGood/printed-theme"))
(package! storybook-theme :recipe (:host github :repo "DogLooksGood/storybook-theme"))
(package! solaire-mode :disable t)
(package! tao-theme :recipe (:host github :repo "11111000000/tao-theme-emacs"))
(package! minimal-theme :recipe (:host github :repo "anler/minimal-theme"))
;; (package! berrys-theme :recipe (:host github :repo "vbuzin/berrys-theme"))
; (package! elegant-theme :recipe (:host github :repo "oracleyue/elegant-theme"))
; (package! nord-emacs :recipe (:host github :repo "arcticicestudio/nord-emacs"))
(package! notink-theme :recipe (:host github :repo "MetroWind/notink-theme"))

(when IS-MAC
  (package! transwin :recipe (:host github :repo "jcs-elpa/transwin")))
