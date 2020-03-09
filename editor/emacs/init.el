;; Prep for use-package, errr, usage.
(setq package-archives
	     '(("org"       . "http://orgmode.org/elpa/")
	       ("gnu"       . "http://elpa.gnu.org/packages/")
	       ("melpa"     . "https://melpa.org/packages/")
	       ("melpa-stable" . "https://stable.melpa.org/packages/")
	       ("emacs-pe" . "https://emacs-pe.github.io/packages/")
	       ;("marmalade" . "http://marmalade-repo.org/packages/")
	       ))

(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Prepare the package-en-ing
(require 'use-package)

(org-babel-load-file "~/repos/dootfeelz/editor/emacs/config.org")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("4b918218201f43b06aee6367eda594e500d3afc4f790a238a6f8a2987287334b" "a2cde79e4cc8dc9a03e7d9a42fabf8928720d420034b66aecc5b665bbf05d4e9" "84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" default)))
 '(helm-ag-insert-at-point (quote symbol))
 '(lsp-prefer-flymake nil)
 '(org-drill-done-count-color "#663311")
 '(org-drill-failed-count-color "#880000")
 '(org-drill-mature-count-color "#005500")
 '(org-drill-new-count-color "#004488")
 '(package-selected-packages
   (quote
    (geiser yasnippet-snippets xah-fly-keys writeroom-mode which-key w3 use-package smartparens smart-mode-line-powerline-theme rainbow-delimiters powerline-evil paredit org-plus-contrib nix-sandbox nix-mode monokai-theme markdown-mode magit json-mode iedit helm-projectile helm-ls-git helm-ag glsl-mode evil-surround evil-nerd-commenter evil-leader evil-escape emmet-mode direnv diminish delight deft dante avy attrap aggressive-indent ag)))
 '(safe-local-variable-values
   (quote
    ((dante-target . "level06")
     (dante-repl-command-line "nix-shell" "--run"
                              (concat "cabal new-repl " dante-target " --builddir=dist/dante")))))
 '(sml/mode-width
   (if
       (eq
        (powerline-current-separator)
        (quote arrow))
       (quote right)
     (quote full)))
 '(sml/pos-id-separator
   (quote
    (""
     (:propertize " " face powerline-active1)
     (:eval
      (propertize " "
                  (quote display)
                  (funcall
                   (intern
                    (format "powerline-%s-%s"
                            (powerline-current-separator)
                            (car powerline-default-separator-dir)))
                   (quote powerline-active1)
                   (quote powerline-active2))))
     (:propertize " " face powerline-active2))))
 '(sml/pos-minor-modes-separator
   (quote
    (""
     (:propertize " " face powerline-active1)
     (:eval
      (propertize " "
                  (quote display)
                  (funcall
                   (intern
                    (format "powerline-%s-%s"
                            (powerline-current-separator)
                            (cdr powerline-default-separator-dir)))
                   (quote powerline-active1)
                   (quote sml/global))))
     (:propertize " " face sml/global))))
 '(sml/pre-id-separator
   (quote
    (""
     (:propertize " " face sml/global)
     (:eval
      (propertize " "
                  (quote display)
                  (funcall
                   (intern
                    (format "powerline-%s-%s"
                            (powerline-current-separator)
                            (car powerline-default-separator-dir)))
                   (quote sml/global)
                   (quote powerline-active1))))
     (:propertize " " face powerline-active1))))
 '(sml/pre-minor-modes-separator
   (quote
    (""
     (:propertize " " face powerline-active2)
     (:eval
      (propertize " "
                  (quote display)
                  (funcall
                   (intern
                    (format "powerline-%s-%s"
                            (powerline-current-separator)
                            (cdr powerline-default-separator-dir)))
                   (quote powerline-active2)
                   (quote powerline-active1))))
     (:propertize " " face powerline-active1))))
 '(sml/pre-modes-separator (propertize " " (quote face) (quote sml/modes))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
