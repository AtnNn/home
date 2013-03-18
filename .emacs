(global-set-key "\M-[1;5C" 'forward-word) ; Ctrl+right->forward word
(global-set-key "\M-[1;5D" 'backward-word); Ctrl+left-> backward word

(setq scroll-preserve-screen-position t)

(setq-default indent-tabs-mode nil)

(menu-bar-mode);hide menu

(ido-mode)

(require 'uniquify)

(setq uniquify-buffer-name-style 'reverse)

(require 'flymake)

(require 'haskell-mode)

(setq flymake-allowed-file-name-masks
      (cons '(".+\\.hs$"
              flymake-simple-make-init
              flymake-simple-cleanup
              flymake-get-real-file-name)
            flymake-allowed-file-name-masks))

(setq default-input-method "rfc1345")

(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-hook 'haskell-mode-hook 'flymake-mode)
(add-hook 'haskell-mode-hook 'toggle-input-method)

(quietly-read-abbrev-file)
(setq save-abbrevs t)
(setq default-abbrev-mode t)
(abbrev-table-put haskell-mode-abbrev-table :regexp "\\(\\(?:\\<\\|\\_<\\)\\(?:\\sw+\\|\\s_+\\)\\(?:\\>\\|\\_>\\)\\)")

(savehist-mode 1)
