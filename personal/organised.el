  ;;; code:

  ;;; WARNING! this *.el file has been generated automatically from
  ;;; a corresponding *.org file. Do not edit this *.el file, but edit
  ;;; the *.org file which will generate the *.el file upon executing
  ;;; Mx org-babel-tangle.

(defun insert-graph-arrow ()
  (interactive)
  (insert " -> "))

  (defun load-acl2 ()
    (interactive)
    (load "~/Documents/acl2-8.3/emacs/emacs-acl2.el")
    (setq inferior-acl2-program "~/Documents/acl2-8.3/saved_acl2"))

  (defun acl2-goodies ()
    (interactive)
    (rainbow-delimiters-mode)
    (paredit-mode)
    (setq *acl2-doc-link-color* "#aaff00")

    (let ((scriptBuf (get-buffer-create "script")))
      (set-buffer scriptBuf)
      (lisp-mode)))

  (defun double-flash-mode-line ()
        (let ((flash-sec (/ 1.0 20)))
          (invert-face 'mode-line)
          (run-with-timer flash-sec nil #'invert-face 'mode-line)
          (run-with-timer (* 2 flash-sec) nil #'invert-face 'mode-line)
          (run-with-timer (* 3 flash-sec) nil #'invert-face 'mode-line)))

  (defun go-80-word-beginning ()
    (interactive)
    (beginning-of-line)
    (forward-char 80)
    (forward-word)
    (backward-word))

  (defun cleanup-80 ()
    (interactive)
    (beginning-of-line)
    (forward-char 80)
    (forward-word)
    (backward-word)

    ;; insert new line char
    (newline-and-indent))

  (global-set-key (kbd "s-8") 'cleanup-80)

  (setq prelude-guru nil) ;; better for slime
      ;; (setq guru-warn-only t) ;; not suitable for slime

  (menu-bar-mode 1)
  (global-hl-line-mode -1)
      ;; (setq prelude-flyspell nil)
      ;;(smartparens-global-mode -1)

  (global-set-key (kbd "s-f") 'vc-git-grep)

  (prelude-require-packages '(buffer-move
                                  enh-ruby-mode
                                  graphviz-dot-mode
                                  helm-descbinds
                                  helm-projectile
                                  ido-completing-read+
                                  kurecolor
                                  load-theme-buffer-local
                                  magit
                                  mode-line-bell
                                  ob-restclient
                                  paredit
                                  projectile
                                  projectile-rails
                                  projectile-rails
                                  rails-log-mode
                                  rainbow-delimiters
                                  redshank
                                  restclient-helm
                                  rspec-mode
                                  rubocop
                                  ruby-hash-syntax
                                  ruby-refactor
                                  rvm
                                  slime
                                  slime-repl-ansi-color
                                  string-inflection
                                  switch-window
                                  vterm     ;needs: sudo apt install libvterm-dev cmake
                                  vterm-toggle
                                  web-mode))

      ; (add-to-list 'load-path "/home/jacek/.emacs.d/elpa/enh-ruby-mode-20190513.254/enh-ruby-mode.el") ; must be added after any path containing old ruby-mode
  (autoload 'enh-ruby-mode "enh-ruby-mode" "Major mode for ruby files" t)

  (global-set-key (kbd "s-'") (quote ruby-toggle-string-quotes))

  (add-to-list 'auto-mode-alist '("\\.rb$" . enh-ruby-mode))
  (add-to-list 'interpreter-mode-alist '("ruby" . enh-ruby-mode))                                          ;
  (add-to-list 'auto-mode-alist
                   '("\\(?:\\.rb\\|ru\\|rake\\|thor\\|jbuilder\\|gemspec\\|podspec\\|/\\(?:Gem\\|Rake\\|Cap\\|Thor\\|Vagrant\\|Guard\\|Pod\\)file\\)\\'" . enh-ruby-mode))

      ;;; ignore rufo for now
      ;; (setq rufo-enable-format-on-save t)
      ;; (add-hook 'enh-ruby-mode-hook 'rufo-minor-mode)

  (setq org-src-fontify-natively t)

  (helm-descbinds-mode)
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

   (add-hook 'overwrite-mode-hook #'(lambda () (double-flash-mode-line)))

  (defun my/ibuffer-visit-buffers-other-tab ()
    "Open buffers marked with m in other tabs."
    (interactive)
    (mapc
     #'switch-to-buffer-other-tab
     (or (ibuffer-get-marked-buffers)
         (list (ibuffer-current-buffer)))))

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

  (require 'string-inflection)

  ;; default
  (global-set-key [f5] 'string-inflection-all-cycle)

  ;; for ruby
  (add-hook 'ruby-mode-hook
            '(lambda ()
               (local-set-key [f6] 'string-inflection-ruby-style-cycle)))

  (setq string-inflection-skip-backward-when-done t)

  (add-hook 'graphviz-dot-mode-hook
              '(lambda ()
                 (local-set-key (kbd "C-]") 'insert-graph-arrow)))

(require 'org)
(org-add-link-type "pdf" 'org-pdf-open nil)

(defun org-pdf-open (link)
  "Where page number is 105, the link should look like:
   [[pdf:/path/to/file.pdf#105][My description.]]"
  (let* ((path+page (split-string link "#"))
         (pdf-file (car path+page))
         (page (car (cdr path+page))))
    (start-process "view-pdf" nil "evince" "--page-index" page pdf-file)))

   (add-hook 'org-mode-hook
             '(lambda ()
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

       ;; we had to cheat to have s-\ as a shortcut
(global-set-key (kbd (format "%s-%c" "s" 92)) 'my-file-line-link)

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

       (global-set-key (kbd "s-9") 'md-to-org-cleanup)

  (require 'restclient)

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((restclient . t)))

  (defun open-buffer-in-vscode ()
    (interactive)

    ;; this possibly crashes emacs
    ;; (save-buffer)

    (let ((bfn (buffer-file-name)))
      (when bfn (let ((com (concatenate 'string "code " bfn)))
                  (shell-command com)))))

  (global-set-key [f9] 'open-buffer-in-vscode)

  ;; Allow hash to be entered on MacOSX
  (fset 'insertPound "#")
  (global-set-key (kbd "M-3") 'insertPound)

  ;;; MacOSX style shortcuts
  (global-set-key (kbd "s-z") 'undo)
  (global-set-key (kbd "s-x") 'clipboard-kill-region)
  (global-set-key (kbd "s-c") 'clipboard-kill-ring-save)
  (global-set-key (kbd "s-v") 'clipboard-yank)

  ;;; MacOSX F keys
  (global-set-key (kbd "s-3") 'kmacro-start-macro-or-insert-counter)
  (global-set-key (kbd "s-4") 'kmacro-end-or-call-macro)

  (global-set-key (kbd "s-a") 'bs-cycle-previous)
  (global-set-key (kbd "s-s") 'bs-cycle-next)

  ;;; switch-window
  (global-set-key (kbd "C-x o") 'switch-window)

  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (add-hook 'web-mode-hook #'(lambda () (smartparens-mode -1)))

  ;;; insert only <% side of erb tag, autopairing wi
  (fset 'insert-rails-erb-tag [?< ?% ])
  (global-set-key (kbd "s-=") 'insert-rails-erb-tag)

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

  (global-set-key (kbd "s-2") 'capitalize-and-join-backwards)


  (add-hook 'haskell-mode-hook
              '(lambda ()
                 (local-set-key (kbd "C-]") 'insert-graph-arrow)))

  (add-hook 'haskell-interactive-mode-hook
              '(lambda ()
                 (local-set-key (kbd "C-]") 'insert-graph-arrow)))

  (add-hook 'haskell-mode-hook
            '(lambda ()
               (local-set-key (kbd "C-c C-d h") 'haskell-hoogle)))

  (add-hook 'haskell-interactive-mode-hook
            '(lambda ()
               (local-set-key (kbd "C-c C-d h") 'haskell-hoogle)))

  (add-hook 'haskell-interactive-mode-hook
            '(lambda ()
               (prelude-mode -1)
               (local-set-key (kbd "C-a") 'haskell-interactive-mode-bol)))

   (setq geiser-active-implementations '(scheme chezscheme racket))
   ;; (setq geiser-racket-binary "/usr/bin/racket")

   (add-to-list 'auto-mode-alist '("\\.edn\\'" . clojure-mode))

   (add-hook 'cider-repl-mode-hook
             '(lambda ()
                (local-set-key (kbd "C-c M-k") 'cider-repl-clear-buffer)))

   (add-hook 'cider-repl-mode-hook
             '(lambda ()
                (local-set-key (kbd "C-c M-a") 'cider-load-all-files)))

  ;;; this code has been responsible for slime version problem
  ;; (defvar slime-helper-el "~/quicklisp/slime-helper.el")
  ;; (when (file-exists-p slime-helper-el)
  ;;   (load (expand-file-name slime-helper-el)))

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

  (global-set-key (kbd "s-e") 'slime-copy-last-expression-to-repl)

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

  (global-set-key (kbd "s-0") 'unfold-lisp)

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
        (apply 'color-rgb-to-hex (color-name-to-rgb color)))))

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

  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
  (add-hook 'after-load-theme-hook 'colorise-brackets)

  ;; moving buffers
  (require 'buffer-move)
  ;; need to find unused shortcuts for moving up and down
  (global-set-key (kbd "<M-s-up>")     'buf-move-up)
  (global-set-key (kbd "<M-s-down>")   'buf-move-down)
  (global-set-key (kbd "<M-s-left>")   'buf-move-left)
  (global-set-key (kbd "<M-s-right>")  'buf-move-right)

  (provide 'personal)
  ;;; personal ends here
