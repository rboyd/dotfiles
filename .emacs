(setq path "/usr/local/heroku/bin:/Users/rboyd/.rvm/gems/ruby-1.9.3-p194/bin:/Users/rboyd/.rvm/gems/ruby-1.9.3-p194@global/bin:/Users/rboyd/.rvm/rubies/ruby-1.9.3-p194/bin:/Users/rboyd/.rvm/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/Users/rboyd/bin:/Users/rboyd/.rvm/bin")
(setenv "PATH" path)

(add-to-list 'load-path "~/.emacs.d")  ; Add this directory to Emacs' load path

(require 'package)
(add-to-list 'package-archives 
                 '("marmalade" .
                         "http://marmalade-repo.org/packages/"))

(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-file-name-transforms (quote ((".*" "~/.emacs.d/autosaves/\\1" t))))
 '(backup-directory-alist (quote ((".*" . "~/.emacs.d/backups/"))))
 '(custom-enabled-themes (quote (forest-monk)))
 '(custom-safe-themes (quote ("605646c27f4e7592dd7f90594c984316995342062c2fbbd25caf48e80636ef19" "26a372a59d30dfedea863c51687c816c84f54a44e9e0e790289e27bb033a9f4f" "71b172ea4aad108801421cc5251edb6c792f3adbaecfa1c52e94e3d99634dee7" "501caa208affa1145ccbb4b74b6cd66c3091e41c5bb66c677feda9def5eab19c" default)))
 '(weblogger-config-alist (quote (("default" ("user" . "user") ("server-url" . "http://bravenewbits.com/xmlrpc/") ("weblog" . "1"))))))

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

(require 'org)

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
