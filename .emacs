;; .emacs
; tell me if there's something wrong
(setq debug-on-error t)

(server-start)


(add-to-list 'load-path (expand-file-name "~/elisp"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/icicles"))

; Disable non-emacs stuff:
;(menu-bar-mode -1)       ;hide menu-bar
(scroll-bar-mode -1)     ;hide scroll-bar
(tool-bar-mode -1)       ;hide tool-bar

; do not wrap long lines
(setq-default truncate-lines t)

(ido-mode 1)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(require 'isearchb)

(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)

;You should add any customization code to your ~/.emacs. If you're doing any C customization at all, add:
(require 'cc-mode)
;If you'd like syntax colorization, add a
(global-font-lock-mode 1)


;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
(setq diff-switches "-u")

; just answer y/n
(defalias 'yes-or-no-p 'y-or-n-p)

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



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(make-backup-files nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
