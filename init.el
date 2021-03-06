;; packages
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)
(when (not package-archive-contents) (package-refresh-contents))

(defvar my-packages
  '(auto-complete
    expand-region
    flycheck
    google-translate
    helm
    helm-projectile
    julia-mode
    julia-shell
    magit
    markdown-mode
    multiple-cursors
    org
    org-page
    org-pdfview
    org-pomodoro
    projectile
    smartparens
    solarized-theme
    undo-tree
    yasnippet)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p)) (package-install p)))

;; prevent custom.el modifications to init.el
(setq custom-file "~/.emacs.d/custom.el")
(load-file custom-file)

;; set default directory
(setq default-directory "/Users/omer/Documents/Developer")

;; customize interface
(setq inhibit-splash-screen t)
(transient-mark-mode 1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(column-number-mode t)
(add-hook 'prog-mode-hook 'linum-mode)
(load-theme 'afternoon t)
;;(set-frame-font "DejaVu Sans Mono-12" nil t) ;; TODO: fix that returns font not found

;; helm configuration
(require 'helm)
(require 'helm-config)

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
  (defvar helm-google-suggest-use-curl-p t))

; open helm buffer inside current window, not occupy whole other window
(defvar helm-split-window-in-side-p t)

; move to end or beginning of source when reaching top or bottom of source.
(defvar helm-move-to-line-cycle-in-source t)

; search for library in `require' and `declare-function' sexp.
(defvar helm-ff-search-library-in-sexp t)

; scroll 8 lines other window using M-<next>/M-<prior>
(defvar helm-scroll-amount 8)
(defvar helm-ff-file-name-history-use-recentf t)


;; magit-tramp setup
(require 'tramp)
(add-to-list 'tramp-remote-path "/share/apps/git/git-2.7.2/bin/git")
(add-to-list 'tramp-remote-path 'tramp-own-remote-path)

(helm-mode 1)

(global-set-key (kbd "M-x") 'helm-M-x)
;;(projectile-global-mode)
(defvar helm-M-x-fuzzy-match t)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
(defvar helm-buffers-fuzzy-matching t)
(defvar helm-recentf-fuzzy-match    t)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(when (executable-find "ack-grep")
  (defvar helm-grep-default-command "ack-grep -Hn --no-group --no-color %e %p %f")
  (defvar helm-grep-default-recurse-command "ack-grep -H --no-group --no-color %e %p %f"))

;; smartparens
(require 'smartparens-config)

;; magit
(global-set-key (kbd "C-x g") 'magit-status)

;; yasnippet
(require 'yasnippet)
(yas-reload-all)
(add-hook 'prog-mode-hook #'yas-minor-mode)
(global-set-key (kbd "C-c C-y i") 'yas-insert-snippet)
(global-set-key (kbd "C-c C-y n") 'yas-new-snippet)
(global-set-key (kbd "C-c C-y v") 'yas-visit-snippet)

;; Julia
(load "~/.emacs.d/ESS/lisp/ess-site")
(load "/Users/omer/.emacs.d/elpa/julia-mode-20170916.628/julia-mode.el")
(defvar inferior-julia-program-name "/Applications/Julia-0.6.app/Contents/Resources/julia/bin/julia")
(add-hook 'julia-mode-hook #'smartparens-mode)

;; orgmode
(require 'org)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)


;; Moving around windows
(windmove-default-keybindings)

;; Octave
(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))
(add-hook 'octave-mode-hook
          (lambda ()
            (abbrev-mode 1)
            (auto-fill-mode 1)
            (if (eq window-system 'x)
                (font-lock-mode 1))))


;; flycheck
(global-flycheck-mode)
(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))


;;;;;;;;;;;;;; Key Binding Shortcuts ;;;;;;;;;;;;;;
;; multiple-cursors
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; hippie-expand
(global-set-key (kbd "M-/") 'hippie-expand)

;; expand-region
(global-set-key (kbd "C-=") 'er/expand-region)

;; comment single line
(global-set-key
 (kbd "C-x C-i")
 (lambda ()
   (interactive)
   (comment-or-uncomment-region (line-beginning-position) (line-end-position))))


;; Comment chosen region
(global-set-key 
 (kbd "C-x C-k")
 (lambda ()
   (interactive)
   (comment-or-uncomment-region (region-beginning) (region-end))))


;; Copy line
(global-set-key (kbd "C-c C-k") 'copy-line)
