;;; dwt/dwt-lsp/config.el -*- lexical-binding: t; -*-


(use-package! lsp-mode
  ;; :defer t
  ;; :config
  ;; (setq lsp-auto-guess-root t)
  ;; (setq lsp-ui-sideline-enable nil)
  ;; (setq lsp-ui-sideline-show-code-actions nil)
  ;; (setq lsp-ui-sideline-show-diagnostics nil)
  ;; (setq lsp-ui-sideline-enable nil)
  ;; (setq lsp-ui-sideline-show-hover nil)
  ;; (setq lsp-signature-auto-activate t)
  ;; (setq lsp-signature-doc-lines 1)
  ;; (setq lsp-enable-symbol-highlighting t)
  ;; (setq lsp-keymap-prefix "C-c l"
  ;;       lsp-keep-workspace-alive nil
  ;;       lsp-modeline-code-actions-enable nil
  ;;       lsp-modeline-diagnostics-enable nil
  ;;       lsp-modeline-workspace-status-enable nil


  ;;       lsp-enable-file-watchers nil
  ;;       lsp-enable-folding nil
  ;;       lsp-enable-semantic-highlighting nil
  ;;       lsp-enable-symbol-highlighting nil
  ;;       lsp-enable-text-document-color nil

  ;;       lsp-enable-indentation nil
  ;;       lsp-enable-on-type-formatting nil)
  :custom
  (lsp-enable-links nil)                 ;; no clickable links
  (lsp-enable-folding nil)               ;; use `hideshow' instead
  (lsp-enable-snippet t)               ;; no snippets, it requires `yasnippet'
  (lsp-enable-file-watchers nil)         ;; performance matters
  (lsp-enable-text-document-color nil)   ;; as above
  (lsp-enable-symbol-highlighting nil)   ;; as above
  (lsp-enable-on-type-formatting nil)    ;; as above
  (lsp-enable-indentation nil)           ;; don't change my code without my permission
  (lsp-headerline-breadcrumb-enable nil) ;; keep headline clean
  (lsp-modeline-code-actions-enable nil) ;; keep modeline clean
  (lsp-modeline-diagnostics-enable nil)  ;; as above
  (lsp-log-io nil)                       ;; debug only
  (lsp-auto-guess-root t)                ;; auto guess root
  (lsp-keep-workspace-alive nil)         ;; auto kill lsp server
  (lsp-eldoc-enable-hover nil))          ;; disable eldoc hover

(map! :map lsp-mode-map :leader :desc "lsp-imenu" "sI" #'lsp-ui-imenu)

;; (use-package! eglot
;;   :config
;;   (setq eglot-ignored-server-capabilites '(:documentHighlightProvider)))
