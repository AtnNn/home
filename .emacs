(global-font-lock-mode 3)
;(setq inferior-lisp-program "/usr/bin/lisp")
;(toggle-highlight-paren-mode)
;(add-hook 'lisp-mode-hook (lambda () (slime-mode t) (paredit-mode t)))
;(add-hook 'inferior-lisp-mode-hook (lambda () (inferior-slime-mode t)))
;(setq lisp-indent-function 'common-lisp-indent-function
;      slime-complete-symbol-function 'slime-fuzzy-complete-symbol
;      common-lisp-hyperspec-root "/usr/share/doc/hyperspec/"
;      browse-url-browser-function 'w3m-goto-url)

;(require 'w3m)

;(setq w3m-symbol 'w3m-default-symbol
;      w3m-key-binding 'info)

;(require 'paredit)

'(require 'haskell-ghci)
'(setq haskell-ghci-mode-map nil)
'(add-hook 'haskell-mode-hook 'turn-on-haskell-ghci)
'(setq haskell-ghci-program-name "/usr/bin/ghci")

;(setq tramp-syntax 'url)
;(require 'tramp)
;(setq tramp-default-method "scp")

'(setq semantic-load-useful-things-on t)
'(setq semanticdb-project-roots
      (list "/home/atnnn/code/"))

'(require 'semantic-load)

(partial-completion-mode)

;(load-file "/home/atnnn/src/repos/Factor/contrib/factor.el")
;(setq factor-binary "/home/atnnn/src/repos/Factor/f")
;(setq factor-image "/home/atnnn/src/repos/Factor/factor.image")

(setq-default indent-tabs-mode nil)

'(autoload 'gambit-inferior-mode "gambit" "Hook Gambit mode into cmuscheme.")
'(autoload 'gambit-mode "gambit" "Hook Gambit mode into scheme.")
'(add-hook 'inferior-scheme-mode-hook (function gambit-inferior-mode))
'(add-hook 'scheme-mode-hook (function gambit-mode))
'(setq scheme-program-name "gsi -:d-")

'(defconst use-backup-dir t)

'(setq backup-directory-alist '(("." . "~/.backup-emacs/"))
      version-control t ; Use version numbers for backups
      kept-new-versions 16 ; Number of newest versions to keep
      kept-old-versions 2 ; Number of oldest versions to keep
      delete-old-versions t ; Ask to delete excess backup versions?
      backup-by-copying-when-linked t) ; Copy linked files, don't rename.

;(global-set-key [insertchar] 'hippie-expand)
(global-set-key "\e\\" 'hippie-expand)

(require 'hippie-exp)


(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-complete-file-name-partially
        try-complete-file-name
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol
        try-expand-whole-kill))


(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(column-number-mode t)
 '(compilation-auto-jump-to-first-error t)
 '(ecb-options-version "2.32")
 '(fringe-mode 0 nil (fringe))
 '(haskell-doc-show-global-types t)
 '(haskell-program-name "ghci")
 '(inhibit-startup-screen t)
 '(inverse-video t)
 '(menu-bar-mode t)
 '(mouse-autoselect-window t)
 '(save-place t nil (saveplace))
 '(savehist-autosave-interval 30)
 '(savehist-mode t nil (savehist))
 '(scroll-conservatively 20)
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(tool-bar-mode nil)
 '(use-file-dialog nil)
 '(w3m-key-binding (quote info)))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(mode-line ((((class color) (min-colors 88)) (:background "grey75" :foreground "black" :inverse-video t :height 0.7))))
 '(mode-line-inactive ((default (:inherit mode-line)) (((class color) (min-colors 88) (background light)) (:background "white" :foreground "grey20" :inverse-video nil :overline t :underline t)))))
;; Local Variables:
;; pbook-use-toc:  nil
;; pbook-commentary-regexp: "^////\\($\\|[^#]\\)"
;; pbook-heading-regexp: "^////\\(#+\\)"
;; pbook-face-override: ((font-lock-keyword-face :bold t :index :no)
                      
;;                       (font-lock-builtin-face :bold t :index :no)
                      
;; III (font-lock-function-name-face
;; III                         :sc :no :tt :no
;; III  II         :index function)

;;   II         (font-lock-variable-name-face
;; III                         :sc :no :tt :no
;; III                         :index variable)
  
;; III (font-lock-warning-face :bold t :index :no)

;; III (font-lock-comment-face :italic t :tt :no :index :no)

;; III (font-lock-doc-face     :italic t :tt :no :index :no)

;; III (font-lock-constant-face :italic :no :index :no)

;; III (font-lock-string-face  :index :no)

;; III (default                :italic :no))
;;


(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

'(add-to-list 'load-path "~/elisp/")
'(add-to-list 'load-path "/usr/share/maxima/5.13.0/emacs/")

;(autoload 'babel "babel"
;  "Use a web translation service to translate the message MSG." t)
;(autoload 'babel-region "babel"
;  "Use a web translation service to translate the current region." t)
;(autoload 'babel-as-string "babel"
;  "Use a web translation service to translate MSG, returning a string." t)
;(autoload 'babel-buffer "babel"
;  "Use a web translation service to translate the current buffer." t)


(server-start)

(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)

(global-set-key [(mouse-3)] 'menu-bar-mode)

(set-default-font "6x13" t)

(fset 'yes-or-no-p 'y-or-n-p)

(add-hook 'after-make-frame-functions
          '(lambda (frame)
             (modify-frame-parameters frame '((font . "6x13")))))

'(setq prolog-program-name "pl")

;(require 'ess)

;(setq inferior-ess-program "R")

;(load-library "darcsum")

;(add-to-list 'load-path "~/src/slime/")  ; your SLIME directory
;(setq inferior-lisp-program "/usr/bin/sbcl") ; your Lisp system
;(require 'slime)
;(slime-setup)

(setq gdb-many-windows t)



;; flymake for Haskell
(defun flymake-Haskell-init ()
  (flymake-simple-make-init-impl
   'flymake-create-temp-with-folder-structure nil nil
   buffer-file-name
   'flymake-get-Haskell-cmdline))
(defun flymake-get-Haskell-cmdline (source base-dir)
  (list (concat base-dir "/Setup.lhs") (list "build")))
'(push '(".+\\.hs$" flymake-Haskell-init)
      flymake-allowed-file-name-masks)
'(push '(".+\\.lhs$" flymake-Haskell-init)
      flymake-allowed-file-name-masks)
'(push '("^\\(.*\\):\\([0-9]+\\):\\([0-9]+\\): \\(.*\\)$" 1 2 3 4)
      flymake-err-line-patterns)
