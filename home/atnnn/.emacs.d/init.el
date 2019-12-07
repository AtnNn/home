
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

