(defalias 'yes-or-no-p 'y-or-n-p)

(menu-bar-mode nil)

(setq c-basic-offset 4)

(setq-default indent-tabs-mode nil)

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

(server-start)

