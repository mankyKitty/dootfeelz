(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; We want to use the power of the use-package macro so install it.
(straight-use-package 'use-package)

;; Set some defaults
(setq inhibit-startup-screen t)        ; Disable the startup splash screen
(tool-bar-mode -1)                     ; Hide the toolbar
(menu-bar-mode -1)                     ; Hide the menu bar
(scroll-bar-mode -1)                   ; Hide the scroll bar
(setq use-dialog-box nil)              ; Disable graphical dialog boxes for prompts
(delete-selection-mode 1)              ; Overwrite selected text when you type
(global-auto-revert-mode 1)            ; Auto-refresh buffers if the file changes on disk
(setq electric-pair-mode 1)            ; Auto-close parentheses and quotes
(setq-default indent-tabs-mode nil)    ; Use spaces for indentation instead of tabs
;; Activate the saving of buffer history and location in files.
(savehist-mode 1)
(save-place-mode 1)
;; Keep backup files in a single location
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups/" user-emacs-directory)))) 
;; Save for auto-save files
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "backups/" user-emacs-directory) t)))
;; Disable the audible bell
(setq ring-bell-function 'ignore)
;; Turn on the line highlighting
(global-hl-line-mode 1)
;; Show parens and don't delay when doing so
(show-paren-mode 1)
(setq show-paren-delay 0)

;; Set the Theme !
(load-theme 'tsdh-dark)

;; Vertico for finding and rummaging around for things
(use-package vertico
  :straight t
  :init
  (vertico-mode))

(use-package consult
  :straight t
  :bind (("C-x C-b" . consult-buffer)
         ("C-x b" . consult-buffer)
         ("C-c M-x" . consult-mode-command)
         )
  :init
  ;; Adjusts the register preview
  (advice-add #'register-preview :override #'consult-register-window)
  ;; Ops to use consult for xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  :config
  ;; Configures the narrowing key bind to something odd :)
  (setq consult-narrow-key "<")
)

(use-package orderless
  :straight t
  :custom
  (completion-styles '(basic partial-completion orderless))
  (completion-category-override '((file (styles partial-completion)))))

;; Discoverability is very nice, so bring on the which-key
(use-package which-key
  :straight t
  :config
  (which-key-mode)
  (which-key-enable-god-mode-support)
  (setq which-key-popup-type 'side-window
        which-key-side-window-location 'bottom))

;; Lets use god-mode !
(use-package god-mode
  :straight t
  :hook (after-init . god-mode)
  :bind (("<escape>" . god-mode)
         ("C-x C-1" . delete-other-windows)
         ("C-x C-2" . split-window-below)
         ("C-x C-3" . split-window-right)
         ("C-x C-0" . delete-window)
         )
  :config
  (defun my/god-mode-update-cursor ()
    (if god-local-mode
        (setq cursor-type 'box)
      (setq cursor-type 'bar)))
  (add-hook 'god-mode-enabled-hook #'my/god-mode-update-cursor)
  (add-hook 'god-mode-disabled-hook #'my/god-mode-update-cursor)
  :custom
  (setq god-exempt-predicates nil)
  (setq god-exempt-major-modes nil))

;; Magit ! (for great justice)
(use-package magit
  :straight t
  :config
  (setq magit-define-global-key-bindings 'recommended))

(use-package paredit
  :straight t
  :config
  (autoload 'enable-paredt-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
  (add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
  (add-hook 'scheme-mode-hook #'enabled-paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
  (add-hook 'ielm-mode-hook             #'enable-paredit-mode)
  (add-hook 'lisp-mode-hook             #'enable-paredit-mode)
  (add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode))

(use-package geiser
  :straight t)

(use-package geiser-guile
  :straight t
  :requires geiser)

(use-package company
  :straight t
  :hook (after-init-hook . global-company-mode))

;; TODO: Test if I really need this...
(use-package exec-path-from-shell
  :straight t
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(use-package jai-mode
  :straight (:host github :repo "elp-revive/jai-mode")
  :mode "\\.jai\\'")

