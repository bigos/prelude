  ;;; code:

  ;;; WARNING! this *.el file has been generated automatically from
  ;;; a corresponding *.org file. Do not edit this *.el file, but edit
  ;;; the *.org file which will generate the *.el file upon executing
  ;;; Mx org-babel-tangle.

  (defun load-acl2 ()
    (interactive)
    (load "~/Documents/acl2-8.2/emacs/emacs-acl2.el")
    (setq inferior-acl2-program "~/Documents/acl2-8.2/saved_acl2"))

  (defun acl2-goodies ()
    (interactive)
    (rainbow-delimiters-mode)
    (paredit-mode)

    (let ((scriptBuf (get-buffer-create "script")))
      (set-buffer scriptBuf)
      (lisp-mode)))

  (fset 'line-split-at-80
        (lambda (&optional arg) "Keyboard macro." (interactive "p")
          (kmacro-exec-ring-item
           (quote ([5 1 1 21 56 48 6 18 32 6 return] 0 "%d")) arg)))

  ;;; make sure Emacs uses stack in Haskell Projects by default
  (setq haskell-process-type 'stack-ghci)

  (setq prelude-guru nil) ;; better for slime
  ;; (setq guru-warn-only t) ;; not suitable for slime

  (menu-bar-mode 1)
  (global-hl-line-mode -1)
  ;; (setq prelude-flyspell nil)
  ;;(smartparens-global-mode -1)

  (global-set-key (kbd "s-f") 'vc-git-grep)

  (prelude-require-packages '(buffer-move
                              helm-descbinds
                              helm-projectile
                              restclient-helm
                              ob-restclient
                              ido-completing-read+
                              kurecolor
                              load-theme-buffer-local
                              magit
                              paredit
                              projectile
                              projectile-rails
                              rails-log-mode
                              rainbow-delimiters
                              redshank
                              projectile-rails
                              rspec-mode
                              rubocop
                              ruby-hash-syntax
                              ruby-refactor
                              rvm
                              enh-ruby-mode
                              slime
                              switch-window
                              underwater-theme
                              string-inflection
                              web-mode))

  ; (add-to-list 'load-path "/home/jacek/.emacs.d/elpa/enh-ruby-mode-20190513.254/enh-ruby-mode.el") ; must be added after any path containing old ruby-mode
  (autoload 'enh-ruby-mode "enh-ruby-mode" "Major mode for ruby files" t)

  (global-set-key [8388647] (quote ruby-toggle-string-quotes))

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

  (add-hook 'prog-mode-hook 'linum-mode)
  (add-hook 'haskell-mode-hook (lambda () (setq-local company-dabbrev-downcase nil)))

  (require 'string-inflection)

  ;; default
  (global-set-key [f5] 'string-inflection-all-cycle)

  ;; for ruby
  (add-hook 'ruby-mode-hook
            '(lambda ()
               (local-set-key [f6] 'string-inflection-ruby-style-cycle)))

  (setq string-inflection-skip-backward-when-done t)

(require 'org)
(org-add-link-type "pdf" 'org-pdf-open nil)

(defun org-pdf-open (link)
  "Where page number is 105, the link should look like:
   [[pdf:/path/to/file.pdf#105][My description.]]"
  (let* ((path+page (split-string link "#"))
         (pdf-file (car path+page))
         (page (car (cdr path+page))))
    (start-process "view-pdf" nil "evince" "--page-index" page pdf-file)))

  (require 'restclient)

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((restclient . t)))

  (defun open-buffer-in-vscode ()
    (interactive)

    ;; this possibly crashes emacs
    ;; (save-buffer)

    (let ((fn (buffer-file-name)))
      (when fn (let ((com (concatenate 'string "code " fn)))
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

  ;;; for Haskell
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

  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (add-hook 'web-mode-hook #'(lambda () (smartparens-mode -1)))

  ;;; insert only <% side of erb tag, autopairing wi
  (fset 'insert-rails-erb-tag [?< ?% ])
  (global-set-key (kbd "s-=") 'insert-rails-erb-tag)

   (setq geiser-active-implementations '(chez racket))
   ;; (setq geiser-racket-binary "/usr/bin/racket")

  ;;; this code has been responsible for slime version problem
  ;; (defvar slime-helper-el "~/quicklisp/slime-helper.el")
  ;; (when (file-exists-p slime-helper-el)
  ;;   (load (expand-file-name slime-helper-el)))

  (require 'slime)

  (setq slime-contribs '(slime-fancy))

  (defun slime-contrib-directory ()
    (let* ((slime-folder-prefix "slime-20")
           (folder-length (length slime-folder-prefix))
           (slime-folder (car (seq-filter (lambda(x) (and (>= (length x)
                                                              folder-length)
                                                          (equal slime-folder-prefix
                                                                 (subseq x 0 folder-length))) )
                                          (directory-files "~/.emacs.d/elpa")))))
      (concat "~/.emacs.d/elpa/" slime-folder "/contrib/")))

  (if (file-exists-p (concat (slime-contrib-directory)
                             "slime-repl-ansi-color.el"))
      (push 'slime-repl-ansi-color slime-contribs)
    (print  (concat
             "Optional file useful with slime missing\n"
             "download it from  https://raw.githubusercontent.com/enriquefernandez/slime-repl-ansi-color/master/slime-repl-ansi-color.el\n"
             "and drop it in:\n"
             (slime-contrib-directory))))

  ;; (slime-setup)

  ;; this is causing an error
  (slime-setup '(
                 ;; slime-asdf ;; is causing an error
                 slime-editing-commands
                 slime-fancy
                 slime-fancy-inspector
                 slime-fontifying-fu
                 slime-fuzzy
                 slime-indentation
                 slime-mdot-fu
                 slime-package-fu
                 slime-references
                 slime-repl
                 slime-sbcl-exts
                 slime-scratch
                 slime-xref-browser))

  (slime-autodoc-mode)
  (setq slime-complete-symbol*-fancy t
        slime-complete-symbol-function 'slime-fuzzy-complete-symbol)

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
        "file:/home/jacek/Documents/Manuals/Lisp/HyperSpec-7-0/HyperSpec/")

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
