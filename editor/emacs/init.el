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
