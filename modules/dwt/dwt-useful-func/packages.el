;; -*- no-byte-compile: t; -*-
;;; dwt/dwt-useful-func/packages.el

;; (package! speed-type :recipe (:host github :repo "parkouss/speed-type"))
(package! speed-type)
(when IS-MAC
  (package! netease-cloud-music.el :recipe (:host github :repo "SpringHan/netease-cloud-music.el")))
(package! fanyi.el :recipe (:host github :repo "condy0919/fanyi.el"))
(package! jieba.el :recipe (:host github :repo "cireu/jieba.el"))
;; (package! chatgpt
;;   :recipe (:host github :repo "joshcho/ChatGPT.el" :files ("dist" "*.el")))
(package! cliphist :recipe (:host github :repo "redguardtoo/cliphist"))
(package! titlecase :recipe (:host github :repo "duckwork/titlecase.el"))
(package! atomic-chrome :recipe (:host github :repo "alpha22jp/atomic-chrome"))
(package! magit-todos :recipe (:host github :repo "alphapapa/magit-todos"))
;; (package! outli :recipe (:host github :repo "jdtsmith/outli"))
;; (package! blink-search :recipe (:host github :repo "manateelazycat/blink-search"))
;; (package! mind-wave :recipe (:host github :repo "manateelazycat/mind-wave" :build nil))
;; (package! Bard.el :recipe (:host github :repo "AllTheLife/Bard.el" :build nil))
