
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
(package-initialize)

;; Paredit
;;(add-to-list 'paredit-space-for-delimiter-predicates
;;             (lambda (_ _) nil))

;;; highlight-sexp highlight-symbol rainbow-delimiters highlight-tail

(require 'helm-config)
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
(if (file-exists-p "/home/atnnn/code/ciao/ciao_emacs/elisp/ciao-site-file.el")
  (load-file "/home/atnnn/code/ciao/ciao_emacs/elisp/ciao-site-file.el"))
; @end(65173798)@ - End of automatically added lines.

(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

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

(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

(setq load-path (cons "~/code/lean4-mode" load-path))
(load "lean4-mode")

(define-key lean4-mode-map (kbd "C-c l") lsp-command-map)


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
(add-hook 'c-mode-common-hook
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

(setf
 (alist-get 'nix-build compilation-error-regexp-alist-alist)
 '("^ *at \\([^:]+\\):\\([0-9]+\\):\\([0-9]+\\):$" 1 2 3))
