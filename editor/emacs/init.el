(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default)))
 '(package-selected-packages
   (quote
    (ranger counsel avy general haskell-mode company flycheck rainbow-delimiters paredit magit multiple-cursors evil which-key use-package)))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; General Config and Preparation
;; delete excess backup versions silently
(setq delete-old-versions -1)
;; use version control
(setq version-control t)
;; make backups file even when in version controlled dir
(setq vc-make-backup-files t)
;; which directory to put backups file
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")))
;; don't ask for confirmation when opening symlinked file
(setq vc-follow-symlinks t)
;;transform backups file name
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)) )
;; inhibit useless and old-school startup screen
(setq inhibit-startup-screen t )
;; No more scroll bars
(setq scroll-bar-mode nil)
;; silent bell when you make a mistake
(setq ring-bell-function 'ignore )
;; use utf-8 by default
(setq coding-system-for-read 'utf-8 )
(setq coding-system-for-write 'utf-8 )
;; sentence SHOULD end with only a point.
(setq sentence-end-double-space nil)
;; toggle wrapping text at the 80th character
(setq default-fill-column 80)
;; print a default message in the empty scratch buffer opened at startup
(setq initial-scratch-message ";; Modes loaded, buffers made. Welcome home...")
;; No tabs, ever, go away.... except for you Makefile, you're okay
(setq-default indent-tabs-mode nil)

;; Prep for use-package, errr, usage.
(setq package-enable-at-startup nil)
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
                         ("gnu"       . "http://elpa.gnu.org/packages/")
			 ("melpa"     . "https://melpa.org/packages/")
			 ("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))
(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Prepare the package-en-ing
(require 'use-package)

(use-package eldoc
  :ensure t
  :config 
  (eldoc-add-command
   'paredit-backward-delete
   'paredit-close-round))

(use-package material-theme
  :ensure t
  :config
  (load-theme 'material t))

(use-package smart-mode-line
  :ensure t
  :config
  (sml/setup))

;; Show us yer keys
(use-package which-key :ensure t
  :config
  'which-key-popup-type 'minibuffer
  (which-key-mode))

;; Projectsssssss
(use-package projectile
  :ensure t
  :config
  (projectile-mode))

;; Counsel for Awesomez
(use-package counsel :ensure t)
(use-package counsel-projectile :ensure t
  :config (counsel-projectile-on))

;; Eeeeeeeevil
(use-package evil
  :ensure t
  :config
  (evil-mode))

;; Yay surroundasaurus
(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

;; General Purpose
(use-package multiple-cursors
  :ensure t
  :defer 2
  :config
  (progn
    (global-set-key (kbd "C->") 'mc/mark-next-like-this)
    (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
    (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)))

(use-package magit  :ensure t)
(use-package evil-magit  :ensure t)

(use-package paredit :ensure t
  :config
  (add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
  (add-hook 'ielm-mode-hook             #'enable-paredit-mode)
  (add-hook 'lisp-mode-hook             #'enable-paredit-mode)
  (add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
  (add-hook 'scheme-mode-hook           #'enable-paredit-mode))

(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

;; Checky checky checky!
(use-package flycheck
  :ensure t)

(use-package company
  :ensure t
  :config
  (global-company-mode))

(use-package haskell-mode
  :ensure t
  :config
  (add-hook 'haskell-mode-hook 'haskell-indentation-mode)
  (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
  (add-hook 'haskell-mode-hook 'flycheck-mode))

;; Keybinding hotness
(use-package general :ensure t)
(use-package key-chord
  :ensure t
  :config
  (key-chord-mode 1))

;; State shift keybindings
;; (key-chord-define evil-insert-state-map "jj" 'evil-normal-state)
(general-define-key
 :states '(visual insert emacs)
 (general-chord "jk") 'evil-normal-state)

(general-define-key
 ;; Replace some defaults
 :states '(normal visual insert emacs)
 :prefix "SPC"
 :non-normal-prefix "C-SPC"

 ;; Simple commands
 "c" '(:ignore t :which-key "Comment")
 "cl" '(comment-or-uncomment-region-or-line :which-key "comment line")

 ;; File
 "f" '(:ignore t :which-key "files")
 "ff" 'counsel-find-file
 "fr" 'counsel-recentf
 "fs" 'save-buffer
 
 ;; Project
 "p" '(:ignore t :which-key "project")
 "pf" '(counsel-git :which-key "find file in git dir")
 "pp" 'counsel-projectile-switch-project
 "pb" 'counsel-projectile-switch-to-buffer
 "ps" 'counsel-projectile-ag

 ;; Buffer
 "b" '(:ignore t :which-key "Buffers")
 "bb" 'ivy-switch-buffer

 ;; Movement
 "'" '(iterm-focus :which-key "iterm")
 "?" '(iterm-goto-filedir-or-home :which-key "iterm - goto dir")
 "/" 'counsel-ag
 "TAB" '(lambda () (interactive) (switch-to-buffer (other-buffer)))
 "SPC" '(avy-goto-word-or-subword-1 :which-key "go to char")

 ;; Applications
 "a" '(:ignore t :which-key "Applications")
 "ar" 'ranger
 "ad" 'dired

 ;; Magit
 "g" '(:ignore t :which-key "Git")
 "gs" 'magit-status
 )

(use-package ivy
  :ensure t
  :config
  (ivy-mode 1)
  'ivy-use-virtual-buffers t
  'ivy-count-format " (%d/%d) ")

(use-package avy
  :ensure t
  :commands (avy-goto-word-1))

(use-package ranger :ensure t)

;; Lazy load the nix mode for awesomez
(autoload 'nix-mode "nix-mode" "Major mode for editing Nix expressions" t)
(push '("\\.nix\\'" . nix-mode) auto-mode-alist)
(push '("\\.nix\\.in\\'" . nix-mode) auto-mode-alist)
