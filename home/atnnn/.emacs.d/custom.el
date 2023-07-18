(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Info-additional-directory-list nil)
 '(Info-default-directory-list
   '("/nix/store/bqvfhil4b775r16hf7bp2pzb4wzhy4bi-emacs-26.3/share/info/" "/home/atnnn/code/ciao/build/doc"))
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["black" "red3" "ForestGreen" "yellow3" "blue" "magenta3" "DeepSkyBlue" "gray50"])
 '(auth-source-save-behavior nil)
 '(compilation-auto-jump-to-first-error t)
 '(compilation-error-regexp-alist
   '(nix-build absoft ada aix ant bash borland python-tracebacks-and-caml cmake cmake-info comma msft edg-1 edg-2 epc ftnchek gradle-kotlin iar ibm irix java javac jikes-file maven jikes-line clang-include gcc-include ruby-Test::Unit gmake gnu cucumber lcc makepp mips-1 mips-2 omake oracle perl php rxp shellcheck sparc-pascal-file sparc-pascal-line sparc-pascal-example sun sun-ada watcom 4bsd gcov-file gcov-header gcov-nomark gcov-called-line gcov-never-called perl--Pod::Checker perl--Test perl--Test2 perl--Test::Harness weblint guile-file guile-line))
 '(compilation-scroll-output 'first-error)
 '(compilation-skip-visited t)
 '(custom-enabled-themes '(manoj-dark))
 '(custom-safe-themes
   '("021321ae56a45794f43b41de09fb2bfca184e196666b7d7ff59ea97ec2114559" default))
 '(debug-ignored-errors
   '(beginning-of-line beginning-of-buffer end-of-line end-of-buffer end-of-file buffer-read-only file-supersession mark-inactive))
 '(global-auto-revert-mode t)
 '(global-prettify-symbols-mode t)
 '(helm-mode t)
 '(indent-tabs-mode nil)
 '(lean-extra-arguments '(""))
 '(lean-input-user-translations '(("bV" "𝕍") ("bI" "𝕀")))
 '(lean-memory-limit 1024)
 '(lean-timeout-limit 10000)
 '(lean4-autodetect-lean3 t)
 '(lean4-executable-name "/home/atnnn/.nix-profile/bin/lean")
 '(lean4-rootdir
   "/home/atnnn/.elan/toolchains/leanprover--lean4---nightly-2022-01-06/lib/lean")
 '(lsp-keymap-prefix "C-c l")
 '(lsp-rust-analyzer-server-display-inlay-hints t)
 '(magit-refresh-status-buffer nil)
 '(magit-status-sections-hook
   '(magit-insert-status-headers magit-insert-merge-log magit-insert-rebase-sequence magit-insert-am-sequence magit-insert-sequencer-sequence magit-insert-bisect-output magit-insert-bisect-rest magit-insert-bisect-log magit-insert-untracked-files magit-insert-unstaged-changes magit-insert-stashes magit-insert-unpushed-to-pushremote magit-insert-unpushed-to-upstream-or-recent magit-insert-unpulled-from-pushremote magit-insert-unpulled-from-upstream))
 '(menu-bar-mode nil)
 '(package-archives
   '(("gnu" . "https://elpa.gnu.org/packages/")
     ("melpa" . "http://melpa.org/packages/")))
 '(package-selected-packages
   '(rust-mode helm-projectile lsp-mode eink-theme wgrep projectile scala-mode cl-libify helm-xref helm json-mode magit nix-mode darkroom))
 '(projectile-completion-system 'helm)
 '(projectile-current-project-on-switch 'move-to-end)
 '(projectile-mode t nil (projectile))
 '(projectile-use-git-grep t)
 '(safe-local-variable-values
   '((eval c-set-offset 'inlambda 0)
     (eval c-set-offset 'access-label '-)
     (eval c-set-offset 'substatement-open 0)
     (eval c-set-offset 'arglist-cont-nonempty '+)
     (eval c-set-offset 'arglist-cont 0)
     (eval c-set-offset 'arglist-intro '+)
     (eval c-set-offset 'inline-open 0)
     (eval c-set-offset 'defun-open 0)
     (eval c-set-offset 'innamespace 0)
     (indicate-empty-lines . t)
     (c-block-comment-prefix . "  ")))
 '(scroll-bar-mode nil)
 '(split-height-threshold 120)
 '(split-width-threshold 80)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "black" :foreground "WhiteSmoke" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 150 :width normal :foundry "PfEd" :family "DejaVu Sans Mono"))))
 '(variable-pitch ((t (:family "DejaVu Sans")))))
