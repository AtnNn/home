(defalias 'yes-or-no-p 'y-or-n-p)

(menu-bar-mode 0)

(setq c-basic-offset 4)

(setq-default indent-tabs-mode nil)

(require 'paredit)
(define-key paredit-mode-map (kbd "M-)") 'paredit-forward-slurp-sexp)
(define-key paredit-mode-map (kbd "M-(") 'paredit-backward-slurp-sexp)
(add-hook 'haskell-mode-hook (lambda () (paredit-mode 1)))

(require 'whitespace)
(setq whitespace-style '(trailing lines-tail tabs space-before-tab face))
(setq whitespace-action '(report-on-bogus))
(setq whitespace-line-column 89)
(global-whitespace-mode t)

(setq require-final-newline 'visit)

(desktop-save-mode 1)

(savehist-mode 1)

(require 'ido)
(ido-mode t)

(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward)
(setq uniquify-seperator "\\")

(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)

(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/")
             '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)

(require 'autopair)
(autopair-global-mode)

(server-start)
