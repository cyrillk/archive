(require 'package)

(setq package-archieves '()) ;; empty list of packages
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

(package-initialize)

;; revert buffers automatically when underlying files are changed externally
(global-auto-revert-mode t)

(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq inhibit-startup-screen t)

;;(require 'window-number)
;;(window-number-mode 1)

;; midnight - buffers clean up
;; (require 'midnight)

;; ==================================================
;; exec-path-from-shell
;; ==================================================
(unless (package-installed-p 'exec-path-from-shell)
  (package-refresh-contents) (package-install 'exec-path-from-shell))
(require 'exec-path-from-shell)
(when (memq window-system '(mac ns))
      (exec-path-from-shell-initialize))

;; ==================================================
;; monokai-theme
;; ==================================================
(unless (package-installed-p 'monokai-theme)
  (package-refresh-contents) (package-install 'monokai-theme))
(require 'monokai-theme)

;; ==================================================
;; undo-tree
;; ==================================================
(unless (package-installed-p 'undo-tree)
  (package-refresh-contents) (package-install 'undo-tree))
(require 'undo-tree)
(global-undo-tree-mode t)

;; ==================================================
;; smartparens
;; ==================================================
(unless (package-installed-p 'smartparens)
  (package-refresh-contents) (package-install 'smartparens))
(require 'smartparens)
(smartparens-global-mode t)

;; ==================================================
;; magit
;; ==================================================
(unless (package-installed-p 'magit)
  (package-refresh-contents) (package-install 'magit))
(require 'magit)
(global-set-key (kbd "<f9> <f9>") 'magit-status)

;; ==================================================
;; dirtree
;; ==================================================
(unless (package-installed-p 'dirtree)
  (package-refresh-contents) (package-install 'dirtree))
(require 'dirtree)

;; ==================================================
;; scala
;; ==================================================
(unless (package-installed-p 'scala-mode2)
  (package-refresh-contents) (package-install 'scala-mode2))
(require 'scala-mode2)

(unless (package-installed-p 'sbt-mode)
  (package-refresh-contents) (package-install 'sbt-mode))
(require 'sbt-mode)

(unless (package-installed-p 'ensime)
  (package-refresh-contents) (package-install 'ensime))
(require 'ensime)
(ensime-mode t)
