
;;; Load saved settings
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; Emacs look
(setq default-frame-alist
      '((font . "DejaVu Sans-10")))

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
;(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
;(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
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

(add-to-list 'load-path "~/code/lean4/lean4-mode/")
(require 'lean4-mode)

;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(lean-executable-name "/home/atnnn/.elan/toolchains/nightly/bin/lean")
;;  '(lean-extra-arguments (quote ("-j" "11" "--profile")))
;;  '(lean-memory-limit 12000)
;;  '(lean-message-boxes-enabled-captions
;;    (quote
;;     ("check result" "eval result" "print result" "reduce result" "trace output")))
;;  '(lean-message-boxes-enabledp t)
;;  '(lean-rootdir "/home/atnnn/.elan/toolchains/nightly/")
;;  '(lean-server-show-pending-tasks t)
;;  '(lean-show-type-add-to-kill-ring t)
;;  '(lean-timeout-limit 1000000)
;;  '(menu-bar-mode nil)
;;  '(package-archives
;;    (quote
;;     (("gnu" . "https://elpa.gnu.org/packages/")
;;      ("melpa" . "http://melpa.org/packages/"))))
;;  '(package-selected-packages
;;    (quote
;;     (cl-libify helm-xref helm json-mode magit nix-mode darkroom))))
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(lean-server-task-face ((t (:slant italic))) t))

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

(add-hook
 'c-mode-common-hook
 (lambda ()
   (setq prettify-symbols-compose-predicate #'custom-psdcp)
   (setq
    prettify-symbols-alist
    '(
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
      ;(" & " . ?⨃)
      ;(" | " . ?⩀)
      (" ^ " . ?⊕)
      (";" . ?⸳)
      ("{" . ?⸢)
      ("}" . ?⸥)
      ("goto" . ?⎌)
      ("i" . ?ꙇ)
      ("if" . ?⎇)
      ("else" . ?⌥)
      ;("#include" . ?⭅)
      ))))

;(setq lsp-keymap-prefix "C-c l")
(define-key lsp-mode-map (kbd "C-c l") lsp-command-map)

(let ((quail-current-package (assoc "Lean" quail-package-alist)))
  (quail-defrule "\\=" ["＝"]))

(defun lean-insert-suggestion ()
  (interactive)
  (let ((contents (with-current-buffer "*Lean Next Error*" (buffer-string))))
    (save-match-data
      (if (string-match "Try this: \\(.*\\)" contents)
          (save-excursion
            (insert (match-string 1 contents)))
        (message "No suggestions available")))))

(define-key lean-mode-map (kbd "C-c a") 'lean-insert-suggestion)
