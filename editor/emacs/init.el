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
    ("a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" default)))
 '(package-selected-packages
   (quote
    (org-plus-contrib attrap dante glsl-mode markdown-mode json-mode nix-sandbox nix-mode direnv smartparens aggressive-indent helm-projectile helm-ls-git helm evil-nerd-commenter evil-escape evil-leader delight diminish which-key web-mode use-package smart-mode-line ranger rainbow-delimiters purescript-mode psci psc-ide paredit multiple-cursors material-theme key-chord haskell-mode general evil-surround evil-magit ensime emmet-mode counsel-projectile coffee-mode avy))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
