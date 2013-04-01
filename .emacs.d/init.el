;; .emacs

; tell me if there's something wrong
(setq debug-on-error t)

(server-start)


(add-to-list 'load-path (expand-file-name "~/elisp"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d"))

; evil minor mode (vim eumlation)
(add-to-list 'load-path "~/.emacs.d/evil") ; only without ELPA/el-get
  (require 'evil)
  (evil-mode 1)


; Disable non-emacs stuff:
;(menu-bar-mode -1)       ;hide menu-bar
(scroll-bar-mode -1)     ;hide scroll-bar
(tool-bar-mode -1)       ;hide tool-bar

; do not wrap long lines
(setq-default truncate-lines t)
; show column number in status line
(column-number-mode 1)

(setq inhibit-startup-echo-area-message t)                                      
(setq initial-scratch-message nil)                                              
(setq inhibit-splash-screen t)                                                  
(setq inhibit-startup-message t)
