;; Prep for use-package, errr, usage.
(setq package-archives
	     '(("org"       . "http://orgmode.org/elpa/")
	       ("gnu"       . "http://elpa.gnu.org/packages/")
	       ("melpa"     . "https://melpa.org/packages/")
	       ("melpa-stable" . "https://stable.melpa.org/packages/")
	       ("emacs-pe" . "https://emacs-pe.github.io/packages/")
	       ;("marmalade" . "http://marmalade-repo.org/packages/")
	       ))

;; optional. use this if you install emacs packages to user profiles (with nix-env)
(add-to-list 'package-directory-list "~/.nix-profile/share/emacs/site-lisp/elpa")

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
   '("c5692610c00c749e3cbcea09d61f3ed5dac7a01e0a340f0ec07f35061a716436" "8b58ef2d23b6d164988a607ee153fd2fa35ee33efc394281b1028c2797ddeebb" "378d52c38b53af751b50c0eba301718a479d7feea5f5ba912d66d7fe9ed64c8f" "ae88c445c558b7632fc2d72b7d4b8dfb9427ac06aa82faab8d760fff8b8f243c" "f1c54aac3c29772b5c0c777d695e86315d58f06649edc7a54b5b3944b8f3d5e7" "68d8ceaedfb6bdd2909f34b8b51ceb96d7a43f25310a55c701811f427e9de3a3" "df01ad8d956b9ea15ca75adbb012f99d2470f33c7b383a8be65697239086672e" "0daf22a3438a9c0998c777a771f23435c12a1d8844969a28f75820dd71ff64e1" "0f5cebcafc8463d1abc52917c7060499ce0c037989ae635c493945db3e5c0dda" "b9e9ba5aeedcc5ba8be99f1cc9301f6679912910ff92fdf7980929c2fc83ab4d" "03cc0972581c0f4c8ba3c10452cb6d52a9f16123df414b917e06445c5fdbe255" "4b918218201f43b06aee6367eda594e500d3afc4f790a238a6f8a2987287334b" "a2cde79e4cc8dc9a03e7d9a42fabf8928720d420034b66aecc5b665bbf05d4e9" "84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" default))
 '(helm-ag-insert-at-point 'symbol)
 '(js-indent-level 2)
 '(lsp-prefer-flymake nil)
 '(org-drill-done-count-color "#663311")
 '(org-drill-failed-count-color "#880000")
 '(org-drill-mature-count-color "#005500")
 '(org-drill-new-count-color "#004488")
 '(package-selected-packages
   '(fuel crystal-mode emacs-scala-mode scala-mode scala-mode2 geiser yasnippet-snippets xah-fly-keys writeroom-mode which-key w3 use-package smartparens smart-mode-line-powerline-theme rainbow-delimiters powerline-evil paredit org-plus-contrib nix-sandbox nix-mode markdown-mode magit json-mode iedit helm-projectile helm-ls-git helm-ag glsl-mode evil-surround evil-nerd-commenter evil-leader evil-escape emmet-mode direnv diminish delight deft dante avy attrap aggressive-indent ag))
 '(safe-local-variable-values
   '((dante-target . "level06")
     (dante-repl-command-line "nix-shell" "--run"
                              (concat "cabal new-repl " dante-target " --builddir=dist/dante"))))
 '(sml/mode-width (if (eq (powerline-current-separator) 'arrow) 'right 'full))
 '(sml/pos-id-separator
   '(""
     (:propertize " " face powerline-active1)
     (:eval
      (propertize " " 'display
                  (funcall
                   (intern
                    (format "powerline-%s-%s"
                            (powerline-current-separator)
                            (car powerline-default-separator-dir)))
                   'powerline-active1 'powerline-active2)))
     (:propertize " " face powerline-active2)))
 '(sml/pos-minor-modes-separator
   '(""
     (:propertize " " face powerline-active1)
     (:eval
      (propertize " " 'display
                  (funcall
                   (intern
                    (format "powerline-%s-%s"
                            (powerline-current-separator)
                            (cdr powerline-default-separator-dir)))
                   'powerline-active1 'sml/global)))
     (:propertize " " face sml/global)))
 '(sml/pre-id-separator
   '(""
     (:propertize " " face sml/global)
     (:eval
      (propertize " " 'display
                  (funcall
                   (intern
                    (format "powerline-%s-%s"
                            (powerline-current-separator)
                            (car powerline-default-separator-dir)))
                   'sml/global 'powerline-active1)))
     (:propertize " " face powerline-active1)))
 '(sml/pre-minor-modes-separator
   '(""
     (:propertize " " face powerline-active2)
     (:eval
      (propertize " " 'display
                  (funcall
                   (intern
                    (format "powerline-%s-%s"
                            (powerline-current-separator)
                            (cdr powerline-default-separator-dir)))
                   'powerline-active2 'powerline-active1)))
     (:propertize " " face powerline-active1)))
 '(sml/pre-modes-separator (propertize " " 'face 'sml/modes)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
