;; -*- no-byte-compile: t; -*-
;;; dwt/dwt-useful-func/packages.el

;; (package! speed-type :recipe (:host github :repo "parkouss/speed-type"))
(package! speed-type)
(when IS-MAC
  (package! netease-cloud-music.el :recipe (:host github :repo "SpringHan/netease-cloud-music.el")))
(package! fanyi.el :recipe (:host github :repo "condy0919/fanyi.el"))
