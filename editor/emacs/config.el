(setq-default indent-tabs-mode nil)

(setq-default tab-width 2)

(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

(setq gc-cons-threshold 50000000)

;; Enable line highlight mode, because I find it useful.
(global-hl-line-mode t)
;; Column numbers too
(column-number-mode t)
;; Default fill-width
(setq-default fill-column 90)

(use-package diminish
  :ensure t
  :config
  (diminish 'undo-tree-mode "UT")
)

(use-package delight
  :ensure t
)

(setq which-key-enable-extended-define-key t)
(use-package which-key
  :ensure t
  :diminish which-key-mode
  :init
  (setq which-key-separator " ")
  (setq which-key-prefix-prefix "+")
  :config
  (which-key-mode 1)

)

(defun manky/add-leader-prefix-name (k n)
  "Using the current evil-leader key, define a name for which-key to display"
  (which-key-add-key-based-replacements (concat (symbol-value 'evil-leader/leader) " " k) n))

(use-package evil
  :ensure t
  :config

  (use-package evil-leader
    :ensure t
    :config
    (global-evil-leader-mode 1)
    (evil-leader/set-leader "<SPC>"))

  (use-package evil-surround
    :ensure t
    :config (global-evil-surround-mode))

  (use-package evil-escape
    :ensure t
    :diminish evil-escape-mode
    :init (setq-default evil-escape-key-sequence "jk")
    :config (evil-escape-mode 1))

  (use-package evil-nerd-commenter
    :ensure t
    :config
    (manky/add-leader-prefix-name "c" "comments")
    (evil-leader/set-key
      "cl" 'evilnc-comment-or-uncomment-lines
      "cc" 'evilnc-copy-and-comment-lines
      "cp" 'evilnc-comment-or-uncomment-paragraphs
      "cr" 'comment-or-uncomment-region
      "cv" 'evilnc-toggle-invert-comment-line-by-line
      "."  'evilnc-copy-and-comment-operator
      "\\" 'evilnc-comment-operator ; if you prefer backslash key
      )
  )
  ;; (use-package powerline-evil
  ;;   :ensure t
  ;;   :config
  ;;   (powerline-evil-vim-color-theme))
  (evil-mode 1)
)

(use-package avy
  :ensure t
  :config
  (manky/add-leader-prefix-name "j" "avy")
  (evil-leader/set-key
    "j c" 'avy-goto-char
    "j C" 'avy-goto-char-2
    "j t" 'avy-goto-char-timer
    "j l" 'avy-goto-line
    "j w" 'avy-goto-word-1
    "j W" 'avy-goto-word-0
    "j o" 'avy-org-goto-heading-timer
    "j R" 'avy-org-refile-as-child
  )
)

(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(menu-bar-mode   -1)
(setq-default inhibit-startup-screen t)
;; (setq default-frame-alist '((font . "-ADBO-Source Code Pro-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")))
;; (setq default-frame-alist '((font . "-POOP-Fixedsys Excelsior 3.01-normal-normal-normal-*-16-*-*-*-*-0-iso10646-1")))
(setq default-frame-alist '((font . "-V.R.-PxPlus IBM VGA9-normal-normal-normal-*-15-*-*-*-m-0-iso10646-1")))

(use-package async
  :ensure t
  :config
  (dired-async-mode 1)
)

(use-package popup
  :ensure t
)

(use-package helm
  :ensure t
  :diminish ""
  :bind (
  ("M-x" . helm-M-x)
  ("C-x C-f" . helm-find-files))
  :config
  (helm-mode 1)
)

(use-package helm-ls-git
  :ensure t
  :bind (("C-x C-d" . helm-browse-project))
)

(use-package projectile
  :ensure t
  :after (helm)
  :delight '(:eval (concat " " (projectile-project-name)))
  :init
  (setq projectile-require-project-root nil)
  :config
  (projectile-mode 1)
  ;; (evil-leader/set-key
  ;;   "p" 'projectile-command-map
  ;;   )
)

(use-package helm-projectile
  :ensure t
  :config
  (helm-projectile-on)

  (manky/add-leader-prefix-name "p" "projects")
  (evil-leader/set-key
    "p p" 'helm-projectile-switch-project
    "p f" 'helm-projectile-find-file
    "p b" 'helm-projectile-switch-to-buffer

    ;; helm-projectile-find-file-in-known-projects
    ;; helm-projectile-find-file-dwim
    ;; helm-projectile-find-dir
    ;; helm-projectile-recentf
  )
)

(use-package aggressive-indent
  :ensure t
  :config
  (evil-leader/set-key
    "t a" 'aggressive-indent-mode
  )
)

(use-package rainbow-delimiters
  :ensure t
  ;; There is no global mode, so...
  :hook (prog-mode-hook . rainbow-delimiters-mode)
)

(use-package smartparens
  :ensure t
  :diminish (smartparens-mode . "()")
  :config
  (require 'smartparens-config)
  (smartparens-global-mode t)
  (show-paren-mode t)
)

(use-package magit
  :ensure t
  :diminish magit-auto-revert-mode
  :init
  (manky/add-leader-prefix-name "g" "git")
  (evil-leader/set-key
    "g s" 'magit-status)
)

(use-package direnv
  :ensure t
  :config
  (direnv-mode))

(use-package emmet-mode
  :ensure t
  :init
  (add-hook 'sgml-mode-hook 'emmet-mode) ;; Autostart on markup modes
  (add-hook 'css-mode-hook 'emmet-mode) ;; Emmet has CSS prefix helpers
  (setq emmet-move-cursor-between-quotes t) ;; Move to between the inserted tags

  ;; Not sure if I need this one yet, but I'll know it when I hit it
  ;; (setq emmet-self-closing-tag-style " /") ;; default "/"
  ;; only " /", "/" and "" are valid.
  ;; eg. <meta />, <meta/>, <meta>
)

(use-package nix-mode
  :ensure t
  :mode ("\\.nix\\'" . 'nix-mode)
  :init
  (defun manky/nix-indent ()
    (make-local-variable 'indent-line-function)
    (setq indent-line-function 'nix-indent-line)
    (setq nix-indent-function 'nix-indent-line)
    )

  (add-hook 'nix-mode-hook 'manky/nix-indent)
  )

(use-package nix-sandbox
  :ensure t
  :after nix-mode
  )

(use-package haskell-mode
  :ensure t
  :after flycheck
  :config
  ;; Configure haskell-mode to use cabal new-style builds
  (setq haskell-process-type 'cabal-new-repl)
  ;; Make sure we try to use the current nix env if we have one
  (setq haskell-process-wrapper-function
    (lambda (args) (apply 'nix-shell-command (nix-current-sandbox) args)))

  ;; Disable the haskell-stack-ghc checker
  (add-to-list 'flycheck-disabled-checkers 'haskell-stack-ghc)
  (add-hook 'hack-local-variables-hook #'manky/set-dante-locals nil 'local)

  (add-hook 'haskell-mode-hook
    (lambda ()
            (set (make-local-variable 'company-backends)
                 (append '((company-capf company-dabbrev-code))
                         company-backends))))

)

;; (use-package shm
;;   :load-path "~/repos/structured-haskell-mode/elisp/"
;;   :hook (haskell-mode . structured-haskell-mode)
;;   :init
;;   (setq shm-program-name "/home/manky/repos/structured-haskell-mode/result/bin/structured-haskell-mode")
;;   :config
;;   (haskell-indentation-mode -1)
;; )

(use-package json-mode :ensure t)

(use-package css-mode :ensure t)

(use-package markdown-mode
  :ensure t
)

(use-package glsl-mode
  :ensure t
)

(defun manky/set-dante-locals ()
  (make-local-variable 'dante-project-root)
  (make-local-variable 'dante-repl-command-line)
  (setq dante-project-root (locate-dominating-file buffer-file-name "default..nix"))
  (if dante-target
      (let ((cabal-cmd
             (concat "cabal new-repl " dante-target " --builddir=dist/dante")))
        (setq dante-repl-command-line (list "nix-shell" "--run" cabal-cmd)))
    nil))

(use-package flycheck
  :ensure t
  :init
  (manky/add-leader-prefix-name "t" "toggle")
  (manky/add-leader-prefix-name "e" "fc-errors")
  (evil-leader/set-key
    "t s" 'flycheck-mode
    "e n" 'flycheck-next-error
    "e p" 'flycheck-previous-error
  )
  (setq flycheck-command-wrapper-function
        (lambda (command) (apply 'nix-shell-command (nix-current-sandbox) command))
        flycheck-executable-find
        (lambda (cmd) (nix-executable-find (nix-current-sandbox) cmd)))
)

(use-package dante
  :hook haskell-mode
  :ensure t
  :after haskell-mode
  :commands 'dante-mode
  :init
  (add-hook 'dante-mode-hook
    '(lambda () (flycheck-add-next-checker 'haskell-dante '(warning . haskell-hlint))))

  :config
  (defun manky/dante-insert-type ()
    (interactive)
    (dante-type-at t))

  (evil-leader/set-key-for-mode 'haskell-mode
    "r t" 'manky/dante-insert-type
  )
  (which-key-add-key-based-replacements (concat (symbol-value 'evil-leader/leader) " r t") "insert type")
)

(use-package attrap
  :ensure t
  :init
  (manky/add-leader-prefix-name "r" "refactor")
  (evil-leader/set-key-for-mode 'haskell-mode
    "r f" 'attrap-attrap)
  )

(use-package company
  :ensure t
  :diminish " C"
  :config
  (add-hook 'after-init-hook 'global-company-mode)
)

(use-package smart-mode-line
  :ensure t
  :config
  (add-hook 'after-init-hook 'sml/setup)
)

(manky/add-leader-prefix-name "x" "text") ;; spacemacs muscle memory
(manky/add-leader-prefix-name "f" "file")
(manky/add-leader-prefix-name "b" "buffer")
(which-key-add-key-based-replacements "SPC TAB" "Prev buffer")

;; This is just the beginning
(evil-leader/set-key

"x a r" 'align-regexp

"f s" 'save-buffer

"b d" 'kill-this-buffer
"b b" 'switch-to-buffer
"TAB" 'mode-line-other-buffer

)
;; This is just the end

(use-package org-plus-contrib
  :mode ("\\.org\\'" . org-mode)
  :ensure t
  :pin org
  :config
)
(use-package ox-reveal
  ;; Cloned from github https://github.com/yjwen/org-reveal.git
  :load-path "cloned/org-reveal"
  :config
  (require 'ox-reveal)
)
