(defun is-in-terminal()
  "Returns true if emacs is running in a terminal"
    (not (display-graphic-p)))

(defmacro when-term (&rest body)
  "Works just like `progn' but will only evaluate expressions
   in VAR when Emacs is running in a terminal else just nil."
  `(when (is-in-terminal) ,@body))

(defmacro when-not-term (&rest body)
  "Works just like `progn' but will only evaluate expressions
   in VAR when Emacs is running in a terminal else just nil."
  `(when (not (is-in-terminal)) ,@body))

(custom-set-variables
 '(custom-safe-themes (quote ("a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" default))))
(custom-set-faces
)

(load-theme 'solarized-light t)

;;(setq sml/theme 'light)
;;(sml/setup)

;; UTF-8 please
(require 'iso-transl)
(setq locale-coding-system 'utf-8) ; pretty
(set-terminal-coding-system 'utf-8) ; pretty
(setq default-terminal-coding-system 'utf-8-unix) ; pretty
(set-selection-coding-system 'utf-8) ; please
(prefer-coding-system 'utf-8) ; with sugar on top
(setq-default indent-tabs-mode nil)
(set-locale-environment "en_US.UTF-8")
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)

;; Answering just 'y' or 'n' will do
(defalias 'yes-or-no-p 'y-or-n-p)

(add-hook 'text-mode-hook 'auto-fill-mode)
(add-hook 'prog-mode-hook 'auto-fill-mode)

;; set column width to 79 and visual line mode
(setq-default fill-column 79)
(global-visual-line-mode 1)

(defun set-exec-path-from-shell-PATH ()
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string "^.*\n.*shell\n" "" (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(when-not-term
 (set-exec-path-from-shell-PATH)
 )

(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

;;(when-not-term
;;(openwith-mode -1)
;;)

(setq dired-dwim-target t)

;; (define-key global-map (kbd "RET") 'newline-and-indent)

;; turn on automatic bracket insertion by pairs. New in emacs 24
(electric-pair-mode 1)

;; delete the region when typing, just like as we expect nowadays.
(delete-selection-mode t)

(show-paren-mode t)

(size-indication-mode 1)
(column-number-mode t)

;; http://emacsredux.com/blog/2013/03/29/automatic-electric-indentation/
;;(electric-indent-mode +1)


;; pdf-tools
;;(pdf-tools-install)

;; Set default font
;; (when-not-term
;; (set-face-attribute 'default nil
;;                     :family "Monaco"
;;                     :height 120
;;                     :weight 'normal
;;                     :width 'normal)
;; )

;;(require 'emms-setup)
;;(emms-all)
;;(emms-default-players)

;;(setq emms-source-file-default-directory "~/Music/")

;; (use-package helm
;;   :ensure t
;;   :diminish helm-mode
;;   :init (progn
;;           (require 'helm-config)
;;           (use-package helm-projectile
;;             :ensure t
;;             :commands helm-projectile
;;             :bind ("C-c p h" . helm-projectile))
;;           (use-package helm-ag :defer 10  :ensure t)
;;           (setq helm-locate-command "mdfind -interpret -name %s %s"
;;                 helm-ff-newfile-prompt-p nil
;;                 helm-M-x-fuzzy-match t)
;;           (helm-mode)
;;           (use-package helm-swoop
;;             :ensure t
;;             :bind ("H-w" . helm-swoop)))
;;   :bind (("C-c h" . helm-command-prefix)
;;          ("C-`" . helm-resume)
;;          ("C-x C-f" . helm-find-files)))

(use-package ivy :ensure t
  :diminish (ivy-mode . "")
  :bind
  (:map ivy-mode-map
   ("C-'" . ivy-avy))
  :config
  (ivy-mode 1)
  ;; add ‘recentf-mode’ and bookmarks to ‘ivy-switch-buffer’.
  (setq ivy-use-virtual-buffers t)
  ;; number of result lines to display
  (setq ivy-height 10)
  ;; does not count candidates
  (setq ivy-count-format "")
  ;; no regexp by default
  (setq ivy-initial-inputs-alist nil)
  ;; configure regexp engine.
  (setq ivy-re-builders-alist
	;; allow input not in order
        '((t   . ivy--regex-ignore-order))))

;; it looks like counsel is a requirement for swiper
(use-package counsel
  :ensure t
  )

(use-package swiper
  :ensure try
  :config
  (progn
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t)
    (global-set-key "\C-s" 'swiper)
    (global-set-key (kbd "C-c C-r") 'ivy-resume)
    (global-set-key (kbd "<f6>") 'ivy-resume)
    (global-set-key (kbd "M-x") 'counsel-M-x)
    (global-set-key (kbd "C-x C-f") 'counsel-find-file)
    (global-set-key (kbd "<f1> f") 'counsel-describe-function)
    (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
    (global-set-key (kbd "<f1> l") 'counsel-load-library)
    (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
    (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
    (global-set-key (kbd "C-c g") 'counsel-git)
    (global-set-key (kbd "C-c j") 'counsel-git-grep)
    (global-set-key (kbd "C-c k") 'counsel-ag)
    (global-set-key (kbd "C-x l") 'counsel-locate)
    (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
    (define-key read-expression-map (kbd "C-r") 'counsel-expression-history)
    ))

(use-package company
  :ensure t
  :config (add-hook 'after-init-hook 'global-company-mode)
  (add-to-list 'company-backends 'company-ob-ipython))

(use-package tex
:ensure auctex)

;;View LaTex compiled pdf in emacs
(setq TeX-view-program-list '(("Emacs" "emacsclient %o")))
(setq TeX-view-program-selection '((output-pdf "Emacs")))

;;correlate SyncTeX
(server-start)
(add-hook 'LaTeX-mode-hook 'TeX-PDF-mode)
(add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)
(setq TeX-source-correlate-method 'synctex)
(setq TeX-source-correlate-start-server t)

;;latexMk
(require 'auctex-latexmk)
(auctex-latexmk-setup) 

;;CDLaTeX
(add-hook 'LaTeX-mode-hook 'turn-on-cdlatex) ;with AUCTeX LaTeX mode


;;reftex
;; Turn on RefTeX in AUCTeX
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
;; Activate nice interface between RefTeX and AUCTeX
(setq reftex-plug-into-AUCTeX t)

(use-package pdf-tools
  :ensure t
  :pin manual ;; manually update
  :config
  ;; initialise
  (pdf-tools-install)
  ;; open pdfs scaled to fit page
  (setq-default pdf-view-display-size 'fit-page)
   ;; use normal isearch
  (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)
  ;; more fine-grained zooming
  (setq pdf-view-resize-factor 1.1)

  ;; keyboard shortcuts
  (define-key pdf-view-mode-map (kbd "h") 'pdf-annot-add-highlight-markup-annotation)
  (define-key pdf-view-mode-map (kbd "t") 'pdf-annot-add-text-annotation)
  (define-key pdf-view-mode-map (kbd "D") 'pdf-annot-delete))


(use-package org-pdfview
  :ensure t)

(use-package interleave
  :ensure t
  :config
  )

;; prevent demoting heading also shifting text inside sections
(setq org-adapt-indentation nil)

;; Enable org export to odt (OpenDocument Text)
;; It is disabled by default in org 8.x
(require 'ox-odt nil t)
(require 'ox-beamer nil t)

;; electric pair
(add-hook 'org-mode-hook
          (lambda () 
            (modify-syntax-entry ?~ "$~" org-mode-syntax-table)
            (modify-syntax-entry ?/ "$/" org-mode-syntax-table)
            ))
;; utf-8
(modify-coding-system-alist 'file "" 'utf-8-unix)

;;pdftools
;;(add-to-list 'org-file-apps '("\\.pdf\\'" . org-pdfview-open))
;;(add-to-list 'org-file-apps '("\\.pdf::\\([[:digit:]]+\\)\\'" . org-pdfview-open))

(add-to-list 'org-file-apps 
             '("\\.pdf\\'" . (lambda (file link) (org-pdfview-open link))))

;; set maximum indentation for description lists
(setq org-list-description-max-indent 5)

;; prevent demoting heading also shifting text inside sections
(setq org-adapt-indentation nil)

(when-term
(setq org-startup-with-inline-images t)
)

;;(setq org-image-actual-width t)
(setq org-image-actual-width 400)

(defun shk-fix-inline-images ()
  (when org-inline-image-overlays
    (org-redisplay-inline-images)))

(eval-after-load 'org
  (add-hook 'org-babel-after-execute-hook 'shk-fix-inline-images))

(setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5))

;;CDLaTeX
(add-hook 'org-mode-hook 'turn-on-org-cdlatex)

;; use LaTeXMK
(setq org-latex-pdf-process (list "latexmk"))

;; MathML
;;(setq org-latex-to-mathml-convert-command
;;      "latexmlmath \"%i\" --presentationmathml=%o")

(add-to-list 'org-latex-packages-alist '("margin=3cm" "geometry"))
;;(add-to-list 'org-latex-packages-alist '("" "siunitx"))

;;Minted
(setq org-latex-listings 'minted)
(require 'ox-latex)
(add-to-list 'org-latex-packages-alist '("cache=false" "minted" nil))
(add-to-list 'org-latex-minted-langs '(ipython "python"))

(setq org-highlight-latex-and-related '(latex))

;;(setq org-clock-sound nil) ;; no sound
(setq org-clock-sound t) ;; Standard Emacs beep

(use-package org-cliplink
  :ensure try
  :config
  (global-set-key (kbd "C-x p i") 'org-cliplink)
  )

(use-package org-download
  :ensure t)

(use-package ox-reveal
  :ensure ox-reveal
  :config
  (setq org-reveal-mathjax t)
  (setq org-reveal-root ""))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (ipython . t)
   (C . t)
   (calc . t)
   (latex . t)
   (emacs-lisp . t)
   (shell . t)
   (R . t)
   (ledger . t)
   (js         . t)
   (perl       . t)
   (scala      . t)
   (clojure    . t)
   (ruby       . t)
   (dot        . t)
   (css        . t)
   (plantuml   . t)
   ))

(defun my-org-confirm-babel-evaluate (lang body)
  "Do not confirm evaluation for these languages."
  (not (or (string= lang "C")
           (string= lang "python")
           (string= lang "emacs-lisp")
           (string= lang "latex")
           (string= lang "ipython")
           (string= lang "sh")
           (string= lang "bash")
           (string= lang "R")
           (string= lang "ledger")
           (string= lang "dot")
           (string= lang "plantuml")

           )))
(setq org-confirm-babel-evaluate 'my-org-confirm-babel-evaluate)

;; use ob-async

(use-package ob-async
  :ensure t
  :config
  ;; (add-to-list 'org-ctrl-c-ctrl-c-hook 'ob-async-org-babel-execute-src-block)
  )

;; (setq org-latex-listings t)
;; (add-to-list 'org-latex-packages-alist '("" "listings"))
;; (add-to-list 'org-latex-packages-alist '("" "color"))

;; (require 'htmlize)
(setq org-src-fontify-natively t
      org-src-window-setup 'current-window
      org-src-strip-leading-and-trailing-blank-lines t
      org-src-tab-acts-natively t
      org-src-preserve-indentation t
      org-edit-src-content-indentation 0)

;; Change org latex table scientific notation
(setq org-latex-table-scientific-notation "\\( %s\\times10^{%s} \\)")

(use-package ob-ipython
  :ensure t
  :init
)

;; set key for agenda and capture
(global-set-key (kbd "C-c a") 'org-agenda)
(define-key global-map (kbd "C-c c") 'org-capture)

;; file to save todo items
(setq org-agenda-files (quote ("~/Documents/myPlace/myLife.org")))

;;finish

(defun org-custom-link-img-follow (path)
  (org-open-file-with-emacs
   (format "../images/%s" path)))

(defun org-custom-link-img-export (path desc format)
  (cond
   ((eq format 'html)
    (format "<img src=\"/images/%s\" alt=\"%s\"/>" path desc))))

(org-add-link-type "img" 'org-custom-link-img-follow 'org-custom-link-img-export)

;; ;;(yas-reload-all)
;; (add-hook 'prog-mode-hook #'yas-minor-mode)
;; (add-hook 'text-mode-hook #'yas-minor-mode)

;; Remove Yasnippet's default tab key binding
;;(define-key yas-minor-mode-map (kbd "<tab>") nil)
;;(define-key yas-minor-mode-map (kbd "TAB") nil)
;; Set Yasnippet's key binding to shift+tab
;;(define-key yas-minor-mode-map (kbd "<backtab>") 'yas-expand)
;; Alternatively use Control-c + tab
;;(define-key yas-minor-mode-map (kbd "\C-c TAB") 'yas-expand)

;; (eval-after-load 'yasnippet
;;   '(progn
;;      (define-key yas-keymap (kbd "TAB") nil)
;;      (define-key yas-keymap (kbd "C-o") 'yas-next-field-or-maybe-expand)
;; ))

(use-package yasnippet
  :ensure t
  :diminish yas-minor-mode
  :init (yas-global-mode)
  )

;; flycheck
(use-package flycheck
  :ensure t
  :diminish flycheck-mode
  :init (global-flycheck-mode))

(use-package ledger-mode
  :ensure t
  :mode "\\.ledger\\'"
  :config
  (define-key ledger-mode-map (kbd "C-c c") 'ledger-mode-clean-buffer)
  (setq ledger-post-amount-alignment-at :decimal
        ledger-post-amount-alignment-column 49
        ledger-clear-whole-transactions t)
  (use-package flycheck-ledger
    :ensure t ))

(use-package prodigy
  :ensure t
  :config
  (prodigy-define-service
    :name "nikola"
    :command "nikola"
    :args '("auto")
    :cwd "/home/carlosperez/Documents/gh/blog"
    :tags '(blog nikola)
    :stop-signal 'sigint
    :kill-process-buffer-on-stop: t
    ))

(defun nikola-deploy () ""
       (interactive)
       (venv-with-virtualenv "nikolablog" (shell-command "cd /home/carlosperez/Documents/gh/blog; nikola github_deploy"))
       )

(setq py-python-command "python3")
(setq python-shell-interpreter "python3")

;; (use-package jedi
;;   :ensure t
;;   :init
;;   (add-hook 'python-mode-hook 'jedi:setup)
;;   (add-hook 'python-mode-hook 'jedi:ac-setup))


(use-package elpy
  :ensure t
  :config 
  (elpy-enable)
  (setq python-shell-interpreter "jupyter"
        python-shell-interpreter-args "console --simple-prompt")
)

(use-package virtualenvwrapper
  :ensure t
  :config
  (venv-initialize-interactive-shells)
  (venv-initialize-eshell))

;;(setq elpy-rpc-backend "jedi")

(setenv "WORKON_HOME" "/home/carlosperez/anaconda3/envs")
(pyvenv-mode 1)

(add-hook 'shell-mode-hook #'company-mode)
(define-key shell-mode-map (kbd "TAB") #'company-manual-begin)

(use-package irony
  :ensure t
  :config (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'objc-mode-hook 'irony-mode)

  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options))


(use-package company-c-headers
  :ensure t
  :config
  (add-to-list 'company-backends 'company-c-headers)
  (add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode)))


(require 'company-irony-c-headers)
;; Load with `irony-mode` as a grouped backend
(eval-after-load 'company
  '(add-to-list
    'company-backends '(company-irony-c-headers company-irony)))

(use-package clang-format
  :ensure t
  :config
  (global-set-key (kbd "C-c i") 'clang-format-region)
  (global-set-key (kbd "C-c u") 'clang-format-buffer)

  (setq clang-format-style-option "llvm"))

(use-package magit
  :ensure t
  :init
  (progn
  (bind-key "C-x g" 'magit-status)
  )
  :config
  (setq vc-handled-backends (delq 'Git vc-handled-backends)))
