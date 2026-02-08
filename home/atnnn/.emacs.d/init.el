
;;; Load saved settings
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; Emacs look
(setq-default scroll-bar-mode 0)
(setq-default tool-bar-mode 0)
(setq-default scroll-bar-mode 0)

;;; Change input defaults
(global-set-key "\M-/" 'hippie-expand)
(defalias 'yes-or-no-p 'y-or-n-p)

;;; Encodings
(setq-default locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;;; Indentation
(setq c-basic-offset 4)

;;; Whitespace
(require 'whitespace)
(setq-default whitespace-style '(trailing tabs space-before-tab face))
;;(setq-default whitespace-line-column 89)
(global-whitespace-mode t)

;;; Buffer names
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward)
(setq uniquify-seperator "\\")

;;; Haskell
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

;;; Packages
(require 'package)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

;; Paredit
;;(add-to-list 'paredit-space-for-delimiter-predicates
;;             (lambda (_ _) nil))

;;; highlight-sexp highlight-symbol rainbow-delimiters highlight-tail

;(require 'helm-config)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x C-g") 'helm-ls-git-ls)
(global-set-key (kbd "C-x b") 'helm-mini)

(require 'helm-xref)
(setq xref-show-xrefs-function 'helm-xref-show-xrefs)

(global-set-key (kbd "C-x k") 'bury-buffer)
(global-set-key (kbd "C-x K") 'kill-buffer)

;(add-to-list 'load-path "~/code/lean-mode/")
;(require 'lean-mode)
;(require 'helm-lean)

; @begin(65173798)@ - Do not edit these lines - added automatically!
;(if (file-exists-p "/home/atnnn/code/ciao/ciao_emacs/elisp/ciao-site-file.el")
;  (load-file "/home/atnnn/code/ciao/ciao_emacs/elisp/ciao-site-file.el"))
; @end(65173798)@ - End of automatically added lines.

(dir-locals-set-class-variables
 'non-editable
 '((nil . ((buffer-read-only . t)
           (show-trailing-whitespace . nil)))))

(dir-locals-set-class-variables
 'editable
 '((nil . ((buffer-read-only . nil)
           (show-trailing-whitespace . t)))))

(dir-locals-set-directory-class "/" 'non-editable)
(dir-locals-set-directory-class "/home/atnnn" 'editable)

(setq lsp-keymap-prefix "C-c l")
(require 'lsp-mode)

;(let ((quail-current-package (assoc "Lean" quail-package-alist)))
;  (quail-defrule "\\=" ["＝"]))

;; (defun lean-insert-suggestion ()
;;   (interactive)
;;   (let ((contents (with-current-buffer "*Lean Next Error*" (buffer-string))))
;;     (save-match-data
;;       (if (string-match "Try this: \\(.*\\)" contents)
;;           (save-excursion
;;             (insert (match-string 1 contents)))
;;         (message "No suggestions available")))))

;(define-key lean-mode-map (kbd "C-c a") 'lean-insert-suggestion)


;; Doesn't work with emacs 29?
;;(setq load-path (cons "~/code/lean4-mode" load-path))
;;(load "lean4-mode")
;;(define-key lean4-mode-map (kbd "C-c l") lsp-command-map)


(defun pretty-symbol-delimit-p (left right)
  (or (not (eq left right))
      (memq left '(?. ?( ?)))))
(defun custom-psdcp (start end _match)
  "Return true iff the symbol MATCH should be composed.
The symbol starts at position START and ends at position END.
This is the default for `prettify-symbols-compose-predicate'
which is suitable for most programming languages such as C or Lisp."
  ;; Check that the chars should really be composed into a symbol.
    (and
     (pretty-symbol-delimit-p
      (char-syntax (or (char-before start) ?\s))
      (char-syntax (char-after start)))
     (pretty-symbol-delimit-p
      (char-syntax (char-before end))
      (char-syntax (or (char-after start) ?\s)))
     (not (nth 8 (syntax-ppss)))))
(setq c-mode-common-hook nil)
(add-hook 'c-mode-common-hook-disabled
          (lambda ()
            (setq prettify-symbols-compose-predicate #'custom-psdcp)
            (setq prettify-symbols-alist '(
                                           ("->" . ?→)
                                           ("exists" . ?∃)
                                           ("<=" . ?≤)
                                           (">=" . ?≥)
                                           ("==" . ?≡)
                                           ("!" . ?¬)
                                           ("!=" . ?≢)
                                           ("&&" . ?⋀)
                                           ("||" . ?⋁)
                                           ("true" . ?⊤)
                                           ("false" . ?⊥)
                                           ("bool" . ?𝔹)
                                           ("nullptr" . ?∅)
                                           (">>" . ?≫)
                                           ("<<" . ?≪)
                                           ("<<<" . ?⋘)
                                           (">>>" . ?⋙)
                                           ("[0]" . ?₀)
                                           ("[1]" . ?₁)
                                           ("[2]" . ?₂)
                                           ("[3]" . ?₃)
                                           ("[4]" . ?₄)
                                           ("[n]" . ?ₙ)
                                           ("[i]" . ?ᵢ)
                                           ("[j]" . ?ⱼ)
                                           ("[k]" . ?ₖ)
                                           ("[&]" . ?λ)
                                           ("..." . ?…)
                                           (" * " . ?∙) ; or · ⨯ ⨱ ✕
                                           ("*" . ?∗) ; or ⁎
                                           ("**" . ?⁑)
                                           ("()" . ?≬)
                                           ("(;;)" . ?∞)
                                           ("=" . ?⇇) ; or  ＝
                                           ("auto" . ?∵)
                                           ("return" . ?∎)
                                           ("&" . ?§)
                                           (" & " . ?⨃)
                                           (" | " . ?⩀)
                                           (" ^ " . ?⊕)
                                           ;(";" . ?⸳)
                                           ("{" . ?⸢)
                                           ("}" . ?⸥)
                                           ("goto" . ?⎌)
                                           ("i" . ?ꙇ)
                                           ("if" . ?⎇)
                                           ("else" . ?⌥)
                                           ("#include" . ?⭅)
                                           ))))

(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

(setq completion-styles '(flex))

(add-hook 'c-mode-common-hook 'variable-pitch-mode)
(add-hook 'nix-mode-hook 'variable-pitch-mode)
(add-hook 'rustic-mode-hook 'variable-pitch-mode)

(setq rust-prettify-symbols-alist '())
(push '("*" . ?∗) rust-prettify-symbols-alist)
(push '("[0]" . ?₀) rust-prettify-symbols-alist)
(push '("[1]" . ?₁) rust-prettify-symbols-alist)
(push '("[2]" . ?₂) rust-prettify-symbols-alist)
(push '("[3]" . ?₃) rust-prettify-symbols-alist)
(push '("[4]" . ?₄) rust-prettify-symbols-alist)
(push '("[n]" . ?ₙ) rust-prettify-symbols-alist)
(push '("[i]" . ?ᵢ) rust-prettify-symbols-alist)
(push '("[j]" . ?ⱼ) rust-prettify-symbols-alist)
(push '("[k]" . ?ₖ) rust-prettify-symbols-alist)
(push '("==" . ?≡) rust-prettify-symbols-alist)
(push '("&&" . ?⋀) rust-prettify-symbols-alist)
(push '("||" . ?⋁) rust-prettify-symbols-alist)
(push '("()" . ?≬) rust-prettify-symbols-alist)
(push '("i" . ?ꙇ) rust-prettify-symbols-alist)
(push '("->" . ?→) rust-prettify-symbols-alist)
(push '("=>" . ?⇒) rust-prettify-symbols-alist)
(push '(".unwrap()" . ?‽) rust-prettify-symbols-alist)
(push '(".await" . ?⟳) rust-prettify-symbols-alist)
(push '("." . ?￫) rust-prettify-symbols-alist)
(push '(".." . ?⋯) rust-prettify-symbols-alist)
(push '("_" . ?𛲖) rust-prettify-symbols-alist)

(push '("true" . ?⊤) rust-prettify-symbols-alist)
(push '("false" . ?⊥) rust-prettify-symbols-alist)
(push '(" * " . ?∙) rust-prettify-symbols-alist)
(push '("=" . ?⇇) rust-prettify-symbols-alist)
(push '("return" . ?∎) rust-prettify-symbols-alist)
(push '("&" . ?§) rust-prettify-symbols-alist)
(push '(";" . ?⸳) rust-prettify-symbols-alist)
(push '("if" . ?⎇) rust-prettify-symbols-alist)
(push '("else" . ?⌥) rust-prettify-symbols-alist)
(push '("#" . ?♯) rust-prettify-symbols-alist)
(push '("&mut" . ?※) rust-prettify-symbols-alist)
(push '("String" . ?𝕊) rust-prettify-symbols-alist)
(push '("&str" . ?𝕤) rust-prettify-symbols-alist)
(push '("bool" . ?𝔹) rust-prettify-symbols-alist)
(push '("," . ?,) rust-prettify-symbols-alist)
(push '("{" . ?｢) rust-prettify-symbols-alist)
(push '("}" . ?｣) rust-prettify-symbols-alist)
(push '("pub" . ?👁) rust-prettify-symbols-alist)
(push '("let" . ?∵) rust-prettify-symbols-alist)
(push '("Ok" . ?🗹) rust-prettify-symbols-alist)
(push '("Err" . ?🗷) rust-prettify-symbols-alist)
(push '("Result" . ?⛋) rust-prettify-symbols-alist)
(push '("<" . ?⟨) rust-prettify-symbols-alist)
(push '(">" . ?⟩) rust-prettify-symbols-alist)
(push '("<<" . ?⟪) rust-prettify-symbols-alist)
(push '(">>" . ?⟫) rust-prettify-symbols-alist)
(push '("async" . ?𝦘) rust-prettify-symbols-alist)

(defun rust-pretty-symbol-delimit-p (left right)
  (or
   (not left)
   (not right)
   (not (eq (car left) (car right)))
   (memq (car left)
         '(
           1 ; punctuation
           3 ; symbol
           4 5 ; parens
           8 ; delimiter
           ))))
(defun rust-custom-psdcp (start end match)
  (let ((break-chars '(?_)))
    (and
     (or
      (eq match ?_)
      (eq match ?#)
      (not (memq (get-text-property start 'face)
                 '(font-lock-string-face
                   rust-string-interpolation))))
     (or
      (and
       (memq match '("<" ">"))
       (not (and
             (eq (char-before start) ?\ )
             (eq (char-after end) ?\ ))))
      (and
       (rust-pretty-symbol-delimit-p
        (syntax-after (- start 1))
        (syntax-after start))
       (rust-pretty-symbol-delimit-p
        (syntax-after (- end 1))
        (syntax-after end)))))))

(defun my-enter-rust-mode ()
  (setq prettify-symbols-compose-predicate 'rust-custom-psdcp)
  (setq prettify-symbols-alist rust-prettify-symbols-alist))

(add-hook 'rustic-mode-hook #'my-enter-rust-mode)

(setf
 (alist-get 'nix-build compilation-error-regexp-alist-alist)
 '("^ *at \\([^:]+\\):\\([0-9]+\\):\\([0-9]+\\):$" 1 2 3))

(setq ediff-window-setup-function #'ediff-setup-windows-plain)

(defalias 'eshell/v 'eshell-exec-visual)

;;;

(require 'prettier)
;;(global-set-key (kbd "C-c e f") 'prettier-prettify)
(global-set-key (kbd "C-c e f") 'lsp-format-buffer)

;; ANSI colors in compilation output
(require 'ansi-color)
(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)

;; Treesit
(require 'treesit-auto)
(treesit-auto-add-to-auto-mode-alist 'all)
(global-treesit-auto-mode t)

;;;; Typescript

;; Language server
(require 'eglot)
(setq eglot-events-buffer-size 10000)
(add-hook 'typescript-ts-mode-hook 'eglot-ensure)
(add-hook 'tsx-ts-mode-hook 'eglot-ensure)
(setq-default eglot-inlay-hints-mode nil)
(setq typescript-language-server-config
      '("/home/atnnn/code/whatthepuck/node_modules/.bin/typescript-language-server" "--stdio"
        ;; :initializationOptions
    ;; (:preferences
    ;;  ( ;; https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md
    ;;   :disableSuggestions                                    :json-false     ;; boolean
    ;;   :quotePreference                                       "double"        ;; "auto" | "double" | "single"
    ;;   :includeCompletionsForModuleExports                    t               ;; boolean
    ;;   :includeCompletionsForImportStatements                 t               ;; boolean
    ;;   :includeCompletionsWithSnippetText                     t               ;; boolean
    ;;   :includeCompletionsWithInsertText                      t               ;; boolean
    ;;   :includeAutomaticOptionalChainCompletions              t               ;; boolean
    ;;   :includeCompletionsWithClassMemberSnippets             t               ;; boolean
    ;;   :includeCompletionsWithObjectLiteralMethodSnippets     t               ;; boolean
    ;;   :useLabelDetailsInCompletionEntries                    t               ;; boolean
    ;;   :allowIncompleteCompletions                            t               ;; boolean
    ;;   :importModuleSpecifierPreference                       "shortest"      ;; "shortest" | "project-relative" | "relative" | "non-relative"
    ;;   :importModuleSpecifierEnding                           "minimal"       ;; "auto" | "minimal" | "index" | "js"
    ;;   :allowTextChangesInNewFiles                            t               ;; boolean
    ;;   :providePrefixAndSuffixTextForRename                   t               ;; boolean
    ;;   :provideRefactorNotApplicableReason                    :json-false     ;; boolean
    ;;   :allowRenameOfImportPath                               t               ;; boolean
    ;;   :jsxAttributeCompletionStyle                           "auto"          ;; "auto" | "braces" | "none"
    ;;   :displayPartsForJSDoc                                  t               ;; boolean
    ;;   :generateReturnInDocTemplate                           t               ;; boolean
    ;;   :includeInlayParameterNameHints                        "all"           ;; "none" | "literals" | "all"
    ;;   :includeInlayParameterNameHintsWhenArgumentMatchesName t               ;; boolean
    ;;   :includeInlayFunctionParameterTypeHints                t               ;; boolean,
    ;;   :includeInlayVariableTypeHints                         t               ;; boolean
    ;;   :includeInlayVariableTypeHintsWhenTypeMatchesName      t               ;; boolean
    ;;   :includeInlayPropertyDeclarationTypeHints              t               ;; boolean
    ;;   :includeInlayFunctionLikeReturnTypeHints               t               ;; boolean
    ;;   :includeInlayEnumMemberValueHints                      t               ;; boolean
    ;;   :disableLineTextInReferences                           :json-false
    ;;   )
    ;;  ;:plugins [(:name "typescript-eslint-language-service")]
    ;;  )
    )
  )

(add-to-list 'eglot-server-programs
   `((typescript-ts-mode
      (tsx-ts-mode :language-id "tyspescriptreact"))
     . ,typescript-language-server-config))

(setq eglot-confirm-server-initiated-edits nil)

(add-to-list 'compilation-error-regexp-alist-alist
             '(typescript-error " *\\([^:\n]*\\):\\([0-9]+\\):\\([0-9]+\\) - error TS" 1 2 3 2))
(add-to-list 'compilation-error-regexp-alist 'typescript-error)
(add-to-list 'compilation-error-regexp-alist-alist
             '(node-stacktrace " at .* (\\([^:\n]+\\):\\([0-9]+\\):\\([0-9]+\\))" 1 2 3 2))
(add-to-list 'compilation-error-regexp-alist 'node-stacktrace)

(global-set-key (kbd "C-c e a") 'eglot-code-actions)
(global-set-key (kbd "C-c e n") 'flycheck-next-error)
(global-set-key (kbd "C-c e N") 'flycheck-previous-error)
(global-set-key (kbd "C-c e e") 'flycheck-list-errors)
(global-set-key (kbd "C-c e s") 'eglot)
(global-set-key (kbd "C-c e S") 'eglot-shutdown)
(global-set-key (kbd "C-c e F") 'eglot-format)
(global-set-key (kbd "C-c e h") 'eglot-inlay-hints-mode)
(global-set-key (kbd "C-c e d") 'eldoc-print-current-symbol-info)
(global-set-key (kbd "C-c e /") 'completion-at-point)
(global-set-key (kbd "C-c e r") 'eglot-rename)
(global-set-key (kbd "C-c e t") 'eglot-find-typeDefinition)
(global-set-key (kbd "C-c e q") 'eglot-code-action-quickfix)
(global-set-key (kbd "C-c e i") 'imenu)

;;;;;;;;;;;;;;;


(setq load-path (cons "/home/atnnn/code/LEAN/lean4-mode" load-path))

(setq lean4-mode-required-packages '(dash flycheck lsp-mode magit-section))

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)
(let ((need-to-refresh t))
  (dolist (p lean4-mode-required-packages)
    (when (not (package-installed-p p))
      (when need-to-refresh
        (package-refresh-contents)
        (setq need-to-refresh nil))
      (package-install p))))

(require 'lean4-mode)

(add-to-list 'compilation-error-regexp-alist 'mlton)
(add-to-list 'compilation-error-regexp-alist-alist
             '(mlton
               "^[[:space:]]*\\(\\(?:\\(Error\\)\\|\\(Warning\\)\\|\\(\\(?:\\(?:defn\\|spec\\) at\\)\\|\\(?:escape \\(?:from\\|to\\)\\)\\|\\(?:scoped at\\)\\)\\): \\(.+\\) \\([0-9]+\\)\\.\\([0-9]+\\)\\(?:-\\([0-9]+\\)\\.\\([0-9]+\\)\\)?\\.?\\)$"
               5 (6 . 8) (7 . 9) (3 . 4) 1))
