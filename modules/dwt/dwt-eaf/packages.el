;; -*- no-byte-compile: t; -*-
;;; dwt/dwt-eaf/packages.el

(package! eaf :recipe (:host github :repo "manateelazycat/emacs-application-framework" :build (:not compile)))
;; eaf is not available using stright. Just clone it and use load-path in use-package is enough
