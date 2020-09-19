
;;; Load saved settings
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; Emacs look
(setq default-frame-alist
      '((font . "DejaVu Sans-10")))

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
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
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

(add-to-list 'load-path "~/code/lean-mode/")
(require 'lean-mode)
(require 'helm-lean)

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
