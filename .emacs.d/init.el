
;;; Load saved settings
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;;; Emacs look
(set-face-attribute 'default nil :font "DejaVu Sans-10")

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
(setq-default whitespace-style '(trailing lines-tail tabs space-before-tab face))
(setq-default whitespace-action '(report-on-bogus))
(setq-default whitespace-line-column 89)
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
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/")
             '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)
