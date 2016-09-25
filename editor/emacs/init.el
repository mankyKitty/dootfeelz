;; General Config and Preparation
; delete excess backup versions silently
(setq delete-old-versions -1)
; use version control
(setq version-control t)
; make backups file even when in version controlled dir
(setq vc-make-backup-files t)
; which directory to put backups file
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")))
; don't ask for confirmation when opening symlinked file
(setq vc-follow-symlinks t)
;transform backups file name
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)) )
; inhibit useless and old-school startup screen
(setq inhibit-startup-screen t )
; silent bell when you make a mistake
(setq ring-bell-function 'ignore )
; use utf-8 by default
(setq coding-system-for-read 'utf-8 )
(setq coding-system-for-write 'utf-8 )
; sentence SHOULD end with only a point.
(setq sentence-end-double-space nil)
; toggle wrapping text at the 80th character
(setq default-fill-column 80)
; print a default message in the empty scratch buffer opened at startup
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

;; Show us yer keys
(use-package which-key :ensure t)

;; Eeeeeeeevil
(use-package evil
  :ensure t
  :config
  (evil-mode))

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
(use-package paredit :ensure t)
(use-package rainbow-delimiters
  :ensure t
  :config
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
(use-package general
  :ensure t
  :config
  (general-define-key
   ;; Replace some defaults
   :states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "C-SPC"

   ;; Simple commands

   ;; File
   "f"   '(:ignore t :which-key "files")
   "ff"  'counsel-find-file
   "fr"	 'counsel-recentf
  
   ;; Project
   "p"   '(:ignore t :which-key "project")
   "pf"  '(counsel-git :which-key "find file in git dir")

   ;; Movement / Buffer
   "'" '(iterm-focus :which-key "iterm")
   "?" '(iterm-goto-filedir-or-home :which-key "iterm - goto dir")
   "/" 'counsel-ag
   "TAB" '(switch-to-other-buffer :which-key "prev buffer")
   "SPC" '(avy-goto-word-or-subword-1 :which-key "go to char")

   ;; Applications
   "a" '(:ignore t :which-key "Applications")
   "ar" 'ranger
   "ad" 'dired
   ;; Magit
   "g" '(:ignore t :which-key "Git")
   "gs" 'magit-status
   ))

(use-package avy
  :ensure t
  :commands (avy-goto-word-1))

;; Lazy load the nix mode for awesomez
(autoload 'nix-mode "nix-mode" "Major mode for editing Nix expressions" t)
(push '("\\.nix\\'" . nix-mode) auto-mode-alist)
(push '("\\.nix\\.in\\'" . nix-mode) auto-mode-alist)
