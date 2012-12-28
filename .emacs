;; .emacs

; tell me if there's something wrong
(setq debug-on-error t)

(server-start)


(add-to-list 'load-path (expand-file-name "~/elisp"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d"))

; Disable non-emacs stuff:
;(menu-bar-mode -1)       ;hide menu-bar
(scroll-bar-mode -1)     ;hide scroll-bar
(tool-bar-mode -1)       ;hide tool-bar

; do not wrap long lines
(setq-default truncate-lines t)
; show column number in status line
(column-number-mode 1)


; Multi-term support
(require 'multi-term)
(setq multi-term-program "/bin/bash")

; buffer switching: isearchb+ido
(ido-mode 1)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(require 'isearchb)

; key bindings
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)
(global-set-key (kbd "C-x C-b") 'ibuffer)
;; Use regex searches by default.
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "\C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

;You should add any customization code to your ~/.emacs. If you're doing any C customization at all, add:
(require 'cc-mode)
;If you'd like syntax colorization, add a
(global-font-lock-mode 1)

(defun iswitchb-local-keys ()
    (mapc (lambda (K) 
	      (let* ((key (car K)) (fun (cdr K)))
    	        (define-key iswitchb-mode-map (edmacro-parse-keys key) fun)))
	    '(("<right>" . iswitchb-next-match)
	      ("<left>"  . iswitchb-prev-match)
	      ("<up>"    . ignore             )
	      ("<down>"  . ignore             ))))
(add-hook 'iswitchb-define-mode-map-hook 'iswitchb-local-keys)

;; vertical line at 80chars
(require 'column-marker)
(add-hook 'c-mode-hook (lambda () (interactive) (column-marker-1 80)))

;;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

;; turn on font-lock mode
(when (fboundp 'global-font-lock-mode)
  (global-font-lock-mode t))

;; enable visual feedback on selections
;(setq transient-mark-mode t)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
(setq diff-switches "-u")

; just answer y/n
(defalias 'yes-or-no-p 'y-or-n-p)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun cygwin-shell ()
  "Run cygwin bash in shell mode."
  (interactive)
  (let ((explicit-shell-file-name "C:/cygwin/bin/bash"))
    (setq explicit-bash-args '("--login" "-i"))
    (call-interactively 'shell)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ibuffer config

(setq ibuffer-saved-filter-groups
      '(("home"
	 ("emacs-config" (or (filename . ".emacs.d")
			     (filename . "emacs-config")))
         ("martinowen.net" (filename . "martinowen.net"))
	 ("Org" (or (mode . org-mode)
		    (filename . "OrgMode")))
         ("code" (filename . "code"))
	 ("Web Dev" (or (mode . html-mode)
			(mode . css-mode)))
	 ("Subversion" (name . "\*svn"))
	 ("Magit" (name . "\*magit"))
	 ("ERC" (mode . erc-mode))
	 ("Shell" (mode . Shell))
	 ("Help" (or (name . "\*Help\*")
		     (name . "\*Apropos\*")
		     (name . "\*info\*")))
	 ("Emacs-stuff" (name . "\*.*\*"))
          )))
; activate the 'home' filter
(add-hook 'ibuffer-mode-hook 
	  '(lambda ()
	     (ibuffer-switch-to-saved-filter-groups "home")))
(setq ibuffer-expert t) ; don't confirm killing of buffers
(setq ibuffer-show-empty-filter-groups nil) ; don't show empty groups
; automatically keep buffer-list window up to date
(add-hook 'ibuffer-mode-hook 
	  '(lambda ()
	     (ibuffer-auto-mode 1)
	     (ibuffer-switch-to-saved-filter-groups "home")))

; hide some of the files
;(require 'ibuf-ext)
;    (add-to-list 'ibuffer-never-show-predicates "^\\*")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; always end a file with a newline
;(setq require-final-newline 'query)

; instead use .Xdefualt config:
;  .Xresources "Emacs.menuBar:          off"
;; .Xresources "Emacs.verticalScrollBars:       off"
;; .Xresources "Emacs.toolBar:          off"
;(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(setq inhibit-startup-echo-area-message t)                                      
(setq initial-scratch-message nil)                                              
(setq inhibit-splash-screen t)                                                  
(setq inhibit-startup-message t)
(global-set-key (kbd "<escape>")      'keyboard-escape-quit) ; make 'esc' x 3 => 'esc' x 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;MACROS

(fset 'load-file-\.emacs
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([24 13 108 111 97 100 45 99 111 110 102 105 103 backspace backspace backspace backspace backspace backspace 102 105 108 101 return 46 101 109 97 99 115 return] 0 "%d")) arg)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(make-backup-files nil)
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#242424" :foreground "#ffff00" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 98 :width normal :foundry "outline" :family "Courier New")))))
