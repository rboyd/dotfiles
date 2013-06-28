(setq path "/usr/local/heroku/bin:/Users/rboyd/.rvm/gems/ruby-1.9.3-p194/bin:/Users/rboyd/.rvm/gems/ruby-1.9.3-p194@global/bin:/Users/rboyd/.rvm/rubies/ruby-1.9.3-p194/bin:/Users/rboyd/.rvm/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/Users/rboyd/bin:/Users/rboyd/.rvm/bin")
(setenv "PATH" path)

(add-to-list 'load-path "~/.emacs.d")  ; Add this directory to Emacs' load path

(require 'package)
(add-to-list 'package-archives 
                 '("marmalade" .
                         "http://marmalade-repo.org/packages/"))

(package-initialize)
(evil-mode 1)        ;; enable evil-mode


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (forest-monk)))
 '(custom-safe-themes (quote ("26a372a59d30dfedea863c51687c816c84f54a44e9e0e790289e27bb033a9f4f" "71b172ea4aad108801421cc5251edb6c792f3adbaecfa1c52e94e3d99634dee7" "501caa208affa1145ccbb4b74b6cd66c3091e41c5bb66c677feda9def5eab19c" default)))
 '(weblogger-config-alist (quote (("default" ("user" . "user") ("server-url" . "http://bravenewbits.com/xmlrpc/") ("weblog" . "1")))))
 ;; Put autosave files (ie #foo#) and backup files (ie foo~) in ~/.emacs.d/.
 '(auto-save-file-name-transforms '((".*" "~/.emacs.d/autosaves/\\1" t)))
 '(backup-directory-alist '((".*" . "~/.emacs.d/backups/"))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:height 240 :width normal :family "Inconsolata")))))

(require 'magit)

(defun beautify-json ()
  (interactive)
  (let ((b (if mark-active (min (point) (mark)) (point-min)))
        (e (if mark-active (max (point) (mark)) (point-max))))
    (shell-command-on-region b e
     "python -mjson.tool" (current-buffer) t)))

(require 'evil)
(require 'evil-leader)
(require 'org)

(evil-leader/set-leader "\\")

(define-minor-mode evil-org-mode
  "Buffer local minor mode for evil-org"
  :init-value nil
  :lighter " EvilOrg"
  :keymap (make-sparse-keymap) ; defines evil-org-mode-map
  :group 'evil-org)

(add-hook 'org-mode-hook 'evil-org-mode) ;; only load with org-mode

;; regular normal state shortcuts.
(evil-define-key 'normal evil-org-mode-map
  "gh" 'outline-up-heading
  "gj" 'org-forward-same-level
  "gk" 'org-backward-same-level
  "gl" 'outline-next-visible-heading
  "H" 'org-beginning-of-line
  "L" 'org-end-of-line
  "t" 'org-todo
  "$" 'org-end-of-line
  "^" 'org-beginning-of-line
  "-" 'org-ctrl-c-minus
  "<" 'org-metaleft
  ">" 'org-metaright)

;; leader shortcuts in normal state. (disabled for now)
(evil-leader/set-key
  "c" 'org-cycle
  "e" 'org-export-dispatch
  "n" 'outline-next-visible-heading
  "p" 'outline-previous-visible-heading
  "t" 'org-set-tags-command
  "u" 'outline-up-heading)

(global-linum-mode t)
(setq linum-format "%d ")

(add-to-list 'auto-mode-alist '("\.cljs$" . clojure-mode))

; Recursively generate tags for all *.clj files,
; creating tags for def* and namespaces
(setq path-to-ctags "/usr/local/bin/ctags")
(defun create-clj-tags (dir-name)
  "Create tags file."
  (interactive "Directory: ")
  (shell-command
    (format "%s  --langdef=Clojure --langmap=Clojure:.clj.cljs --regex-Clojure='/[ \t\(]*def[a-z]* \([a-z!-]+\)/\1/' --exclude=.js --regex-Clojure='/[ \t\(]*ns \([a-z.]+\)/\1/' -f %s/TAGS -e -R %s" path-to-ctags dir-name (directory-file-name dir-name)))
  )
