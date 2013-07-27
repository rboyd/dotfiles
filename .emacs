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
 '(default ((t (:height 240 :width normal :family "Inconsolata"))))
 '(rainbow-delimiters-depth-1-face ((t (:foreground "color-22"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "color-23"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "color-24"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "color-25"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "color-26"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "color-27")))))

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


(defun turn-on-paredit () (paredit-mode 1))
(add-hook 'clojure-mode-hook 'turn-on-paredit)

(require 'ac-nrepl)
(add-hook 'nrepl-mode-hook 'ac-nrepl-setup)
(add-hook 'nrepl-interaction-mode-hook 'ac-nrepl-setup)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'nrepl-mode))
(defun set-auto-complete-as-completion-at-point-function ()
  (setq completion-at-point-functions '(auto-complete)))
(add-hook 'auto-complete-mode-hook 'set-auto-complete-as-completion-at-point-function)
(add-hook 'nrepl-mode-hook 'set-auto-complete-as-completion-at-point-function)
(add-hook 'nrepl-interaction-mode-hook 'set-auto-complete-as-completion-at-point-function)
(define-key nrepl-interaction-mode-map (kbd "C-c C-d") 'ac-nrepl-popup-doc)
(add-hook 'clojure-mode-hook 'auto-complete-mode)

(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)
(setq clojure-mode-use-backtracking-indent t)
(add-hook 'clojure-mode-hook '(lambda ()
				(local-set-key (kbd "RET") 'newline-and-indent)))

;;; http://blog.jayfields.com/2013_05_01_archive.html
(dolist (x '((true        т)
             (false       ғ)
             (:keys       ӄ)
             (nil         Ø)
             (partial     ∂)
             (with-redefs я)
             (comp        º)
             (interaction ι)
             (a-fn1       α)
             (a-fn2       β)
             (a-fn3       γ)
             (no-op       ε)
	     (fn          ƒ)))
  (eval-after-load 'clojure-mode
    '(font-lock-add-keywords
      'clojure-mode `((,(concat "[\[({[:space:]]"
                                "\\(" (symbol-name (first x)) "\\)"
                                "[\])}[:space:]]")
                       (0 (progn (compose-region (match-beginning 1)
                                                 (match-end 1) ,(symbol-name (second x)))
                                 nil))))))
  (eval-after-load 'clojure-mode
    '(font-lock-add-keywords
      'clojure-mode `((,(concat "^"
                                "\\(" (symbol-name (first x)) "\\)"
                                "[\])}[:space:]]")
                       (0 (progn (compose-region (match-beginning 1)
                                                 (match-end 1) ,(symbol-name (second x)))
                                 nil))))))
  (eval-after-load 'clojure-mode
    '(font-lock-add-keywords
      'clojure-mode `((,(concat "[\[({[:space:]]"
                                "\\(" (symbol-name (first x)) "\\)"
                                "$")
                       (0 (progn (compose-region (match-beginning 1)
                                                 (match-end 1) ,(symbol-name (second x)))
                                 nil)))))))

(setq org-src-fontify-natively t)
(setq org-src-window-setup 'current-window)
(custom-set-variables '(scheme-program-name "petite"))

(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t) ; fuzzy matching is a must have
(global-set-key (kbd "C-x C-M-f") 'find-file-in-project)
(setq ffip-patterns
  '("*.html" "*.org" "*.txt" "*.md" "*.el" "*.clj" "*.cljs" "*.py" "*.rb" "*.js" "*.pl"
    "*.sh" "*.erl" "*.hs" "*.ml"))

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-default-notes-file (concat org-directory "/notes.org"))

;; Org Capture
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline (concat org-directory "/gtd.org") "Tasks")
         "* TODO %?\n %i\n")
	("u" "uri" entry
	 (file+headline (concat org-directory "/links.org") "Bookmarks")
	 "*** %^{Title}\n\n    Source: %u, %c\n    %i")))


;; http://www.emacswiki.org/emacs/CopyAndPaste
(defun copy-from-osx ()
  (shell-command-to-string "pbpaste"))

(defun paste-to-osx (text &optional push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))

(setq interprogram-cut-function 'paste-to-osx)
(setq interprogram-paste-function 'copy-from-osx)

(setq inhibit-splash-screen t
      initial-scratch-message nil)

(setq x-select-enable-clipboard t)
(defalias 'yes-or-no-p 'y-or-n-p)

(setq tab-width 2
      indent-tabs-mode nil)

(setq vc-follow-symlinks t)

;; Add org-babel support
;; (from https://github.com/lambdatronic/org-babel-example)
(when (locate-file "ob" load-path load-suffixes)
  (require 'ob)
  (require 'ob-tangle)
  (require 'ob-clojure)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (clojure    . t))))

;; Pull in the htmlize library for pretty source code in HTML output
(require 'htmlize)

;; Fontify source code in org-latex export to PDF
(require 'org-latex)
(setq org-export-latex-listings 'minted)
(add-to-list 'org-export-latex-packages-alist '("" "minted"))
(setq org-export-latex-custom-lang-environments
      '(
        (emacs-lisp "common-lispcode")
        ))
(setq org-export-latex-minted-options
      '(("fontsize" "\\scriptsize")
        ("linenos" "false")))
(setq org-latex-to-pdf-process '("pdflatex -interaction nonstopmode -shell-escape -output-directory %o %f"
                                 "bibtex %b"
                                 "pdflatex -interaction nonstopmode -shell-escape -output-directory %o %f"
                                 "pdflatex -interaction nonstopmode -shell-escape -output-directory %o %f"))

;; Patch ob-clojure to work with nrepl
(declare-function nrepl-send-string-sync "ext:nrepl" (code &optional ns))

(defun org-babel-execute:clojure (body params)
  "Execute a block of Clojure code with Babel."
  (require 'nrepl)
  (with-temp-buffer
    (insert (org-babel-expand-body:clojure body params))
    ((lambda (result)
       (let ((result-params (cdr (assoc :result-params params))))
         (if (or (member "scalar" result-params)
                 (member "verbatim" result-params))
             result
           (condition-case nil (org-babel-script-escape result)
             (error result)))))
     (plist-get (nrepl-send-string-sync
                 (buffer-substring-no-properties (point-min) (point-max))
                 (cdr (assoc :package params)))
                :value))))
