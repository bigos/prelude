;;; code:

;;; WARNING! this *.el file has been generated automatically from
;;; a corresponding *.org file. Do not edit this *.el file, but edit
;;; the *.org file which will generate the *.el file upon executing
;;; Mx org-babel-tangle.

;;; fix graph drawing ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; https://emacs.stackexchange.com/questions/81211/how-do-i-write-an-advice-to-override-an-org-roam-function
(defun org-roam-graph--format-node-fix (node type)
  "Return a graphviz NODE with TYPE.
Handles both Org-roam nodes, and string nodes (e.g. urls)."
  (let (node-id node-properties)
    (if (org-roam-node-p node)
        (let* ((title (org-roam-quote-string (org-roam-node-title node)))
               (shortened-title
                (org-roam-quote-string
                 (pcase org-roam-graph-shorten-titles
                   (`truncate (truncate-string-to-width title org-roam-graph-max-title-length nil nil "..."))
                   (`wrap (org-roam-word-wrap org-roam-graph-max-title-length title))
                   (_ title)))))
          (setq node-id (org-roam-node-id node)
                node-properties `(("label"   . ,shortened-title)
                                  ("URL"     . ,(funcall org-roam-graph-link-builder node))
                                  ("tooltip" . ,(xml-escape-string title)))))
      (setq node-id node
            node-properties (append `(("label" . ,(concat type ":" ;node
                                                          (truncate-string-to-width node 15)
                                                          )))
                                    (when (member type (list "http" "https"))
                                      `(("URL" . ,(xml-escape-string (concat type ":" node))))))))
    (format "\"%s\" [%s];\n"
            node-id
            (mapconcat (lambda (n)
                         (org-roam-graph--dot-option n nil "\""))
                       (append (cdr (assoc type org-roam-graph-node-extra-config))
                               node-properties) ","))))
(advice-add 'org-roam-graph--format-node :override #'org-roam-graph--format-node-fix)

;;; *** graph arrow ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun insert-graph-arrow ()
  (interactive)
  (insert " -> "))

;;; *** ACL 2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun load-acl2 ()
    (interactive)
    (load "~/Documents/acl2-8.4/emacs/emacs-acl2.el")
    (setq inferior-acl2-program "~/Documents/acl2-8.4/saved_acl2"))

(defun acl2-goodies ()
    (interactive)
    (rainbow-delimiters-mode)
    (paredit-mode)
    (setq *acl2-doc-link-color* "#aaff00")

    (let ((scriptBuf (get-buffer-create "script")))
      (set-buffer scriptBuf)
      (lisp-mode)))

;;; *** Basic configuration
(global-unset-key (kbd "C-z"))          ; allow others use C-z prefix
(global-set-key (kbd "C-z w") 'ace-window)
(global-set-key (kbd "C-z r") 'crux-recentf-find-file)
(global-set-key (kbd "C-z SPC") 'fixup-whitespace)
(global-set-key (kbd "C-z L") 'ef-themes-select-light)
(global-set-key (kbd "C-<f7>") 'ef-themes-select-light)
(global-set-key (kbd "M-<f7>") 'ef-themes-select)
(global-set-key (kbd "C-z D") 'ef-themes-select-dark)

(global-set-key (kbd "C-S-l s") 'org-store-link)
(global-set-key (kbd "C-S-l i") 'org-insert-link)
(global-set-key (kbd "C-S-l o") 'org-open-at-point)
(global-set-key (kbd "C-]") 'insert-graph-arrow)


(defun jump-to-line-in-file ()
  "Describe me"
  (interactive)
  (let ((line (thing-at-point 'filename)))
    (let ((line-components (split-string line ":")))
      (let ((file (nth 0 line-components))
            (path (nth 1 line-components))
            (line (nth 3 line-components)))
        (message (format "line components %s > %s > %s" file path line))
        (progn
          (find-file-other-window path)
          (goto-line (string-to-number line)))))))

  (global-set-key (kbd "C-x j l") 'jump-to-line-in-file)

(defun go-80 ()
    (interactive)
  (beginning-of-line)
  (move-to-column 80))

(defun go-80-word-beginning ()
  (interactive)
  (beginning-of-line)
  (go-80)
  (forward-word)
  (backward-word))

(defun cleanup-80 ()
    (interactive)
    (beginning-of-line)
    (go-80)
    (forward-word)
    (backward-word)

    ;; insert new line char
    (newline-and-indent))

(global-set-key (kbd "C-z 8") 'cleanup-80)
(global-set-key (kbd "C-h b") 'helm-descbinds)

(setq prelude-guru nil) ;; better for slime

(menu-bar-mode 1)
(global-hl-line-mode 0)

(global-set-key (kbd "C-z f") 'vc-git-grep)

(require 'prelude-packages)
(prelude-require-packages '(
                            birds-of-paradise-plus-theme
                            buffer-move
                            chyla-theme
                            dash
                            ef-themes
                            enh-ruby-mode
                            graphviz-dot-mode
                            helm-core
                            helm-descbinds
                            helm-projectile
                            htmlize
                            kurecolor
                            load-theme-buffer-local
                            magit
                            mode-line-bell
                            monokai-theme
                            noctilux-theme
                            ob-restclient
                            org-mind-map
                            orgit
                            paredit
                            parsec
                            projectile
                            projectile-rails
                            projectile-rails
                            prop-menu

                            psc-ide
                            psci
                            purescript-mode

                            rails-log-mode
                            rainbow-delimiters
                            redshank
                            restclient-helm
                            rspec-mode
                            rubocop
                            ruby-hash-syntax
                            ruby-refactor
                            slime
                            slime-repl-ansi-color
                            string-inflection
                            switch-window
                            tree-sitter-langs
                            use-package
                            vterm ;needs: sudo apt install libvterm-dev cmake
                            multi-vterm
                            web-mode
                            zenburn-theme
                            zeno-theme
                            ))

(eval-when-compile
    (require 'use-package))
(require 'diminish)                ;; if you use :diminish
(require 'bind-key)                ;; if you use any :bind variant

; (add-to-list 'load-path "/home/jacek/.emacs.d/elpa/enh-ruby-mode-20190513.254/enh-ruby-mode.el") ; must be added after any path containing old ruby-mode

;;; problem with enh-ruby-mode
;; (autoload 'enh-ruby-mode "enh-ruby-mode" "Major mode for ruby files" t)

(global-set-key (kbd "C-z '") (quote ruby-toggle-string-quotes))

;; (add-to-list 'auto-mode-alist '("\\.rb$" . enh-ruby-mode))
;; (add-to-list 'interpreter-mode-alist '("ruby" . enh-ruby-mode))                                          ;
;; (add-to-list 'auto-mode-alist
;;                    '("\\(?:\\.rb\\|ru\\|rake\\|thor\\|jbuilder\\|gemspec\\|podspec\\|/\\(?:Gem\\|Rake\\|Cap\\|Thor\\|Vagrant\\|Guard\\|Pod\\)file\\)\\'" . enh-ruby-mode))

;;; ignore rufo for now
;; (setq rufo-enable-format-on-save t)
;; (add-hook 'enh-ruby-mode-hook 'rufo-minor-mode)

(setq org-src-fontify-natively t)


(require 'load-theme-buffer-local)

;;; get rid of utf-8 warning in Ruby mode
(setq ruby-insert-encoding-magic-comment nil)

;; magit warning silencing
(setq magit-auto-revert-mode nil)
(setq magit-last-seen-setup-instructions "1.4.0")

(load "server")
(unless (server-running-p)
  (server-start))

;;; TODO
;; (add-hook 'scheme-mode-hook (lambda () (swap-paredit)))

(add-hook 'overwrite-mode-hook #'(lambda () (invert-face 'mode-line)))

;;; *** Whitespace
(setq whitespace-line-column 480)


;;; *** plantuml
;;; basic plantuml config

(prelude-require-packages '(flycheck-plantuml))

(setq plantuml-jar-path "~/bin/plantuml.jar")
(setq plantuml-default-exec-mode 'jar)

;; Enable plantuml-mode for PlantUML files
(add-to-list 'auto-mode-alist '("\\.puml\\'" . plantuml-mode))

;;; integrate with org-mode
(require 'org)
(add-to-list
 'org-src-lang-modes '("plantuml" . plantuml))

;;; *** string inflection
(require 'string-inflection)

;; default
(global-set-key [f5] 'string-inflection-all-cycle)

;; for ruby
(add-hook 'ruby-mode-hook
            #'(lambda ()
               (local-set-key [f6] 'string-inflection-ruby-style-cycle)))

(setq string-inflection-skip-backward-when-done t)

;;; *** Graphviz

;;; *** Org mode configuration

;;; org-mode source code blocks
(defun insert-named-source-block (language)
    "Insert source block with LANGUAGE string provided."
  (insert "#+begin_src ")
  (insert language)
  (insert "\n")
  (insert "\n")
  (insert "#+end_src")
  (beginning-of-line )
  (backward-char))

(defun insert-emacs-lisp-source-block ()
  (interactive)
  (insert-named-source-block "emacs-lisp"))

(defun insert-lisp-source-block ()
  (interactive)
  (insert-named-source-block "lisp"))

(add-hook 'org-mode-hook
          #'(lambda ()
              (local-set-key (kbd "C-z #") 'insert-lisp-source-block)))

(require 'org)

;;; correct way of adding links
;; https://orgmode.org/manual/Adding-Hyperlink-Types.html
(org-link-set-parameters "pdf"
                       :follow #'org-pdf-open)

(defun org-pdf-open (link)
  "Where page number is 105, the link should look like:
   [[pdf:/path/to/file.pdf#105][My description.]]"
  (let* ((path+page (split-string link "#"))
         (pdf-file
          (split-string
           (car path+page)
           ":"))
         (afile (car pdf-file))
         (page (car (cdr path+page))))
    ;; (message "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz %s %s" page afile)
    (start-process "view-pdf" nil "evince" "--page-index" page afile)))

;;; My own additions
(require 'org-vlc)
(require 'jacek-verse)

(add-hook 'org-mode-hook
          #'(lambda ()
              (local-set-key [f5] 'verse-link)))

(defun my-file-line-link ()
  "Copy the buffer full path and line number into a clipboard
                 for pasting into *.org file."
  (interactive)
  (let* ((home-part (concat "/home/"
                            (user-login-name)))
         (the-link
          (let ((file-link
                 (concat "file:"
                         (let ((bfn buffer-file-name))
                           (if (string-prefix-p home-part bfn)
                               (concat "~"
                                       (substring bfn (length home-part)))
                             bfn))
                         "::"
                         (substring  (what-line) 5))))
            (if (string-match " " file-link)
                (concat "[[" file-link "]]")
              file-link))))
    (kill-new
     (message the-link))))

       ;; we had to cheat to have C-z \ as a shortcut
(global-set-key (kbd (format "%s %c" "C-z" 92)) 'my-file-line-link)
(global-set-key (kbd "C-z q")                   'my-file-line-link)

(defun md-to-org-cleanup ()
  "After we use pandoc to concert md file, we need to
                        remove PROPERTIES drawers"
  (interactive)
  (search-forward ":END:")
  (search-backward ":PROPERTIES:")
  (beginning-of-line)
  ;; we remove 3 lines
  ;; 6 because we 1 clear then 2 remove empty line
  (dotimes (n 6)
    (kill-line)))

(global-set-key (kbd "C-z 9") 'md-to-org-cleanup)

(defun insert-org-heading-link ()
  (interactive)
  (let* ((enteredw (word-at-point))
         (startpoint (search-backward enteredw))
         (cpoint (point))
         (heading-names (org-map-entries #'org-get-heading nil 'file))
         (the-heading (if (member enteredw heading-names)
                          enteredw
                        (completing-read (format "Select heading %s " enteredw)
                                         heading-names
                                         nil
                                         t
                                         enteredw)))
         (the-link (when the-heading
                     (format "[[*%s][%s]]" the-heading the-heading))))

    (when the-link
      (replace-region-contents (+ 0 startpoint)
                               (+ (length enteredw) cpoint)
                               (lambda ()
                                 the-link))
      ;; go to the end of the-link
      (search-forward "]]"))))

(add-hook 'org-mode-hook
          #'(lambda ()
              (local-set-key (kbd "C-z l") 'insert-org-heading-link)))

(require 'restclient)

(org-babel-do-load-languages
   'org-babel-load-languages
   '((restclient . t)))

;; Org-Roam basic configuration


(defun org-roam-my-reload ()
  (interactive)
  (setq org-roam-directory   (file-truename (org-roam-my-folder)))
  (setq org-roam-db-location (file-truename (org-roam-my-db)))
  (org-roam-db-sync)
  (message "reloaded org-roam-directory to %S" org-roam-directory))

(defun org-roam-my-folder ()
  (concat (getenv "HOME")
          "/Documents/Roams/"
          "current"
          "/org-roam/"))

(defun org-roam-my-db ()
  (concat (org-roam-my-folder)
          "org-roam"
          ".db"))


(message (format "org-roam folder  %s" (org-roam-my-folder)))
(message (format "org-roam db-file %s" (org-roam-my-db)))

(defun org-roam-dired ()
  "Open dired buffer on org-roam folder."
  (interactive)
  (dired (org-roam-my-folder)))

(use-package org-roam
  :ensure t
  :after org
  :init (setq org-roam-v2-ack t) ;; Acknowledge V2 upgrade
  :custom
  ;; file-truename can resolve symbolic links
  (org-roam-directory   (file-truename (org-roam-my-folder)))
  (org-roam-db-location (file-truename (org-roam-my-db)))
  :config
  (org-roam-db-autosync-enable)
  (setq org-roam-completion-everywhere t)
  :bind (("C-x n d" . org-roam-dired)
         ("C-x n P" . org-roam-dailies-goto-previous-note)
         ("C-x n R" . org-roam-my-reload)
         ("C-x n N" . org-roam-dailies-goto-next-note)
         ("C-x n T" . org-roam-dailies-goto-today)
         ("C-x n U" . org-roam-ui-open)
         ("C-x n f" . org-roam-node-find)
         ("C-x n g" . org-roam-graph)
         ("C-x n r" . org-roam-node-random)
         (:map org-mode-map
               (("C-x n i" . org-roam-node-insert)
                ("C-x n o" . org-id-get-create)
                ("C-x n t" . org-roam-tag-add)
                ("C-x n s" . org-roam-db-sync)
                ("C-x n a" . org-roam-alias-add)
                ("C-x n l" . org-roam-buffer-toggle)))))

(require 'org-protocol)
(require 'org-roam-protocol)

(use-package org-brain
  :ensure t
  :init
  (setq org-brain-path
        "~/Documents/org-brain")
  ;; For Evil users
  (with-eval-after-load 'evil
    (evil-set-initial-state 'org-brain-visualize-mode 'emacs))
  :config
  (bind-key "C-z b" 'org-brain-prefix-map org-mode-map)
  (setq org-id-track-globally t)
  (setq org-id-locations-file "~/.emacs.d/.org-id-locations")
  (add-hook 'before-save-hook #'org-brain-ensure-ids-in-buffer)
  (push '("b" "Brain" plain (function org-brain-goto-end)
          "* %i%?" :empty-lines 1)
        org-capture-templates)
  (setq org-brain-visualize-default-choices 'all)
  (setq org-brain-title-max-length 12)
  (setq org-brain-include-file-entries nil
        org-brain-file-entries-use-title nil))

;; Allows you to edit entries directly from org-brain-visualize
(use-package polymode
  :config
  (add-hook 'org-brain-visualize-mode-hook #'org-brain-polymode))

(use-package websocket
  :ensure t
  :after org-roam)

(use-package yafolding
  :ensure t
  :bind (("C-x y f" . yafolding-mode)))

;;; *** vscode interaction
(defun open-buffer-in-vscode ()
      (interactive)

      ;; this possibly crashes emacs
      ;; (save-buffer)

  (let ((bfn (buffer-file-name)))
    (when bfn (let ((com (concat "code " bfn)))
                (shell-command com)))))

(global-set-key [f9] 'open-buffer-in-vscode)

;;; *** PureScript

(require 'psc-ide)

(add-hook 'purescript-mode-hook
          (lambda ()
            (psc-ide-mode)
            (company-mode)
            (flycheck-mode)
            (turn-on-purescript-indentation)))

(add-hook 'purescript-mode-hook 'inferior-psci-mode)

;;; *** MacOSX specific settings
(when nil
  ;; Allow hash to be entered on MacOSX
  (fset 'insertPound "#")
  (global-set-key (kbd "M-3") 'insertPound)

;;; MacOSX style shortcuts
  (global-set-key (kbd "C-z z") 'undo)
  (global-set-key (kbd "C-z x") 'clipboard-kill-region)
  (global-set-key (kbd "C-z c") 'clipboard-kill-ring-save)
  (global-set-key (kbd "C-z v") 'clipboard-yank)

;;; MacOSX F keys
  (global-set-key (kbd "C-z 3") 'kmacro-start-macro-or-insert-counter)
  (global-set-key (kbd "C-z 4") 'kmacro-end-or-call-macro))

;;; *** Shortcuts
(global-set-key (kbd "C-z a") 'bs-cycle-previous)
(global-set-key (kbd "C-z s") 'bs-cycle-next)

;;; switch-window
(global-set-key (kbd "C-x o") 'switch-window)

;;; *** Web mode
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(setq web-mode-code-indent-offset 2)
(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(add-hook 'web-mode-hook #'(lambda () (smartparens-mode -1)))

;;; insert only <% side of erb tag, autopairing wi
(fset 'insert-rails-erb-tag [?< ?% ])
(global-set-key (kbd "C-z =") 'insert-rails-erb-tag)

;;; *** C/CPP
;;; that assumes we have emacs29, ran autogen.sh and configured the source for tree-sitter support
;;; and installed parses for c/cpp

(add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
(add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
(add-to-list 'major-mode-remap-alist
             '(c-or-c++-mode . c-or-c++-ts-mode))

;;; more info about possible ivy completions
(defun ivy-debug-candidates ()
  (interactive)
  (message "ivy text %s" ivy-text)
  (message "ivy regex %s" ivy-regex)
  (message "ivy length %s" ivy--length)
  (message "ivy old candidates %s" ivy--old-cands)
  (message "possible completions %s"
           (cl-remove-duplicates
            (cl-map 'list
                    (lambda (co)
                      (substring co 0 1))
                    (cl-map 'list (lambda (c)
                                    (replace-regexp-in-string ivy--old-re "" c))
                            ivy--old-cands))
            :test (lambda (x y) (or (null y) (equal x y))))))

(global-set-key [f7] 'ivy-debug-candidates)

;;; *** Elm
(add-hook 'elm-mode-hook 'elm-format-on-save-mode)

;;; *** Rust

;; this may not be needed because prelude defaults

;;; *** C#


;;; *** Ocaml
;; https://discuss.ocaml.org/t/how-to-start-with-emacs-to-work-on-ocaml-codebases/10312/19

;;;; OCaml support

;; major mode for editing OCaml code
;; it also features basic toplevel integration
(use-package tuareg
  :ensure t
  :mode (("\\.ocamlinit\\'" . tuareg-mode)))

;; major mode for editing Dune files
(use-package dune
  :ensure t)

(use-package merlin
  :ensure t
  :config
  ;; we're using flycheck instead file:~/.emacs.d/elpa/flycheck-ocaml-20220730.542/flycheck-ocaml.el::37
  (with-eval-after-load 'merlin
    ;; Disable Merlin's own error checking
    (setq merlin-error-after-save nil)

    ;; Enable Flycheck checker
    (flycheck-ocaml-setup))
  (add-hook 'merlin-mode-hook #'company-mode))

(use-package ocamlformat
  :ensure t
  :config
  (add-hook 'before-save-hook 'ocamlformat-before-save))

(use-package flycheck-ocaml
  :ensure t)

;; eldoc integration for Merlin
(use-package merlin-eldoc
  :ensure t
  :hook ((tuareg-mode) . merlin-eldoc-setup))

(use-package merlin-ac
  :ensure t)

(use-package merlin-company
  :ensure t)

(use-package merlin-iedit
  :ensure t)

;;; copied from merlin post install
(let ((opam-share (ignore-errors (car (process-lines "opam" "var" "share")))))
  (when (and opam-share (file-directory-p opam-share))
    ;; Register Merlin
    (add-to-list 'load-path (expand-file-name "emacs/site-lisp" opam-share))
    (autoload 'merlin-mode "merlin" nil t nil)
    ;; Automatically start it in OCaml buffers
    (add-hook 'tuareg-mode-hook 'merlin-mode t)
    (add-hook 'caml-mode-hook 'merlin-mode t)
    ;; Use opam switch to lookup ocamlmerlin binary
    (setq merlin-command 'opam)))

;;; *** Haskell
;;; make sure Emacs uses stack in Haskell Projects by default
(setq haskell-process-type 'stack-ghci)

(add-hook 'haskell-mode-hook (lambda () (setq-local company-dabbrev-downcase nil)))

(defun capitalize-and-join-backwards ()
    (interactive)
    (search-backward " ")
    (right-char)
    (right-char)
    (insert " ")
    (left-char)
    (left-char)
    (capitalize-word 1)
    (paredit-forward-delete)
    (left-char)
    (paredit-backward-delete))

(global-set-key (kbd "C-z 2") 'capitalize-and-join-backwards)

(add-hook 'haskell-mode-hook
            #'(lambda ()
               (local-set-key (kbd "C-c C-d h") 'haskell-hoogle)))

(add-hook 'haskell-interactive-mode-hook
            #'(lambda ()
               (local-set-key (kbd "C-c C-d h") 'haskell-hoogle)))

(add-hook 'haskell-interactive-mode-hook
            #'(lambda ()
               (prelude-mode -1)
               (local-set-key (kbd "C-a") 'haskell-interactive-mode-bol)))

(use-package ormolu
  :ensure t
  :hook (haskell-mode . ormolu-format-on-save-mode)
  ;; :bind
  ;; :map
  ;; (haskell-mode-map ("C-z h" . ormolu-format-buffer))
  )

;;; *** Lisp

;;; **** Geiser
   (setq geiser-active-implementations '(scheme chezscheme racket))
   ;; (setq geiser-racket-binary "/usr/bin/racket")

;;; *** Clojure
   (add-to-list 'auto-mode-alist '("\\.edn\\'" . clojure-mode))

   (add-hook 'cider-repl-mode-hook
             #'(lambda ()
                (local-set-key (kbd "C-c M-k") 'cider-repl-clear-buffer)))

   (add-hook 'cider-repl-mode-hook
             #'(lambda ()
                (local-set-key (kbd "C-c M-a") 'cider-load-all-files)))

;;; **** Slime
;;; this code has been responsible for slime version problem
;; (defvar slime-helper-el "~/quicklisp/slime-helper.el")
;; (when (file-exists-p slime-helper-el)
;;   (load (expand-file-name slime-helper-el)))
(require 'slime)
(require 'slime-autoloads)

(setq slime-contribs '(slime-fancy slime-fancy-inspector))

(defun slime-contrib-directory ()
    (let* ((slime-folder-prefix "slime-20")
           (folder-length (length slime-folder-prefix))
           (slime-folder (car (seq-filter (lambda(x) (and (>= (length x)
                                                              folder-length)
                                                          (equal slime-folder-prefix
                                                                 (subseq x 0 folder-length))) )
                                          (directory-files "~/.emacs.d/elpa")))))
      (concat "~/.emacs.d/elpa/" slime-folder "/contrib/")))

(setq slime-complete-symbol*-fancy t
        slime-complete-symbol-function 'slime-fuzzy-complete-symbol)


;;; copy last s-expression to repl
;;; useful for expressions like (in-package #:whatever)
;;; alternatively you can use C-c ~ with cursor after (in-package :some-package)
;;; https://www.reddit.com/r/lisp/comments/ehs12v/copying_last_expression_to_repl_in_emacsslime/
(defun slime-copy-last-expression-to-repl (string)
    (interactive (list (slime-last-expression)))
    (slime-switch-to-output-buffer)
    (goto-char (point-max))
    (insert string))

(defun slime-copy-last-expression (string)
  (interactive (list (slime-last-expression)))
  (kill-new string)
  (message "copied the last sexp"))

(global-set-key (kbd "C-z e") 'slime-copy-last-expression-to-repl)
(global-set-key (kbd "C-z t") 'slime-copy-last-expression)

;;; switch between Lisp related buffers
(global-set-key (kbd "C-z ;") 'slime-selector)

;;; restart lisp after error
(global-set-key (kbd "C-z R") 'slime-restart-inferior-lisp)

;;; **** Paredit
(add-hook 'minibuffer-inactive-mode-hook #'paredit-mode)
(add-hook 'minibuffer-inactive-mode-hook #'rainbow-delimiters-mode)

(defun swap-paredit ()
    "Replace smartparens with superior paredit."
    (smartparens-mode -1)
    (paredit-mode +1))

(autoload 'paredit-mode "paredit"
    "Minor mode for pseudo-structurally editing Lisp code." t)
(add-hook 'emacs-lisp-mode-hook (lambda () (swap-paredit)))

(add-hook 'lisp-mode-hook (lambda () (swap-paredit)))
(add-hook 'lisp-interaction-mode-hook (lambda () (swap-paredit)))

(add-hook 'scheme-mode-hook (lambda () (swap-paredit)))
(add-hook 'geiser-repl-mode-hook (lambda () (swap-paredit)))
(add-hook 'geiser-repl-mode-hook 'rainbow-delimiters-mode)

(add-hook 'slime-repl-mode-hook (lambda () (swap-paredit)))
(add-hook 'slime-repl-mode-hook 'rainbow-delimiters-mode)

(add-hook 'clojure-mode-hook (lambda () (swap-paredit)))
(add-hook 'cider-repl-mode-hook (lambda () (swap-paredit)))

;;; **** The rest
(setq common-lisp-hyperspec-root
        (format
         "file:/home/%s/Documents/Manuals/Lisp/HyperSpec-7-0/HyperSpec/"
         user-login-name))

      (require 'redshank-loader)
      (eval-after-load "redshank-loader"
        `(redshank-setup '(lisp-mode-hook
                           slime-repl-mode-hook)
                         t))

(defun unfold-lisp ()
    "Unfold lisp code."
    (interactive)
    (search-forward ")")
    (backward-char)
    (search-forward " ")
    (newline-and-indent))

(global-set-key (kbd "C-z 0") 'unfold-lisp)

(defun insert-serapeum-arrow ()
  (interactive)
  (insert "(~> )")
  (backward-char))

(global-set-key (kbd "C-z i") 'insert-serapeum-arrow)

;;; *** Parentheses coloring
;;; this add capability to define your own hook for responding to theme changes
(defvar after-load-theme-hook nil
  "Hook run after a color theme is loaded using `load-theme'.")
(defadvice load-theme (after run-after-load-theme-hook activate)
    "Run `after-load-theme-hook'."
    (run-hooks 'after-load-theme-hook))

(require 'color)
(defun hsl-to-hex (h s l)
    "Convert H S L to hex colours."
    (let (rgb)
      (setq rgb (color-hsl-to-rgb h s l))
      (color-rgb-to-hex (nth 0 rgb)
                        (nth 1 rgb)
                        (nth 2 rgb))))

(defun hex-to-rgb (hex)
    "Convert a 6 digit HEX color to r g b."
    (mapcar #'(lambda (s) (/ (string-to-number s 16) 255.0))
            (list (substring hex 1 3)
                  (substring hex 3 5)
                  (substring hex 5 7))))


(defun bg-color ()
     "Return COLOR or it's hexvalue."
     (let ((color (face-attribute 'default :background)))
       (if (equal (substring color 0 1) "#")
           color
         (apply 'color-rgb-to-hex
                (let ((color-rgb (color-name-to-rgb color)))
                  (if (null color-rgb)
                      '(0.0 0.0 0.0)
                    color-rgb))))))

(defun bg-light ()
    "Calculate background brightness."
    (< (color-distance  "white"
                        (bg-color))
       (color-distance  "black"
                        (bg-color))))

(defun whitespace-line-bg ()
    "Calculate long line highlight depending on background brightness."
    (apply 'color-rgb-to-hex
           (apply 'color-hsl-to-rgb
                  (apply (if (bg-light) 'color-darken-hsl 'color-lighten-hsl)
                         (append
                          (apply 'color-rgb-to-hsl
                                 (hex-to-rgb
                                  (bg-color)))
                          '(7))))))

(defun bracket-colors ()
    "Calculate the bracket colours based on background."
    (let (hexcolors lightvals)
      (setq lightvals (if (bg-light)
                          (list (list .60 1.0 0.55) ; H S L
                                (list .30 1.0 0.40)
                                (list .11 1.0 0.55)
                                (list .01 1.0 0.65)
                                (list .75 0.9 0.55) ; H S L
                                (list .49 0.9 0.40)
                                (list .17 0.9 0.47)
                                (list .05 0.9 0.55))
                        (list (list .70 1.0 0.68) ; H S L
                              (list .30 1.0 0.40)
                              (list .11 1.0 0.50)
                              (list .01 1.0 0.50)
                              (list .81 0.9 0.55) ; H S L
                              (list .49 0.9 0.40)
                              (list .17 0.9 0.45)
                              (list .05 0.9 0.45))))
      (dolist (n lightvals)
        (push (apply 'hsl-to-hex n) hexcolors))
      (reverse hexcolors)))


(defun colorise-brackets ()
    "Apply my own colours to rainbow delimiters."
    (interactive)
    (require 'rainbow-delimiters)
    (custom-set-faces
     ;; change the background but do not let theme to interfere with the foreground
     `(whitespace-line ((t (:background ,(whitespace-line-bg)))))
     ;; or use (list-colors-display)
     `(rainbow-delimiters-depth-2-face ((t (:foreground ,(nth 0 (bracket-colors))))))
     `(rainbow-delimiters-depth-3-face ((t (:foreground ,(nth 1 (bracket-colors))))))
     `(rainbow-delimiters-depth-4-face ((t (:foreground ,(nth 2 (bracket-colors))))))
     `(rainbow-delimiters-depth-5-face ((t (:foreground ,(nth 3 (bracket-colors))))))
     `(rainbow-delimiters-depth-6-face ((t (:foreground ,(nth 4 (bracket-colors))))))
     `(rainbow-delimiters-depth-7-face ((t (:foreground ,(nth 5 (bracket-colors))))))
     `(rainbow-delimiters-depth-8-face ((t (:foreground ,(nth 6 (bracket-colors))))))
     `(rainbow-delimiters-depth-9-face ((t (:foreground ,(nth 7 (bracket-colors))))))
     `(rainbow-delimiters-unmatched-face ((t (:foreground "white" :background "red"))))
     `(highlight ((t (:foreground "#ff0000" :background "#888"))))))

(colorise-brackets)

;;; *** Buffer movement
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(add-hook 'after-load-theme-hook 'colorise-brackets)

;; moving buffers
(require 'buffer-move)
;; need to find unused shortcuts for moving up and down
;; (global-set-key (kbd "<M-s-up>")     'buf-move-up)
;; (global-set-key (kbd "<M-s-down>")   'buf-move-down)
;; (global-set-key (kbd "<M-s-left>")   'buf-move-left)
;; (global-set-key (kbd "<M-s-right>")  'buf-move-right)

;;; *** Conclusion
(provide 'personal)
;;; personal ends here
