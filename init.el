(package-initialize)

(setq-default inhibit-splash-screen t
              inhibit-startup-message t
              inhibit-startup-echo-area-message t
              visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow)
              left-fringe-width nil
              indicate-empty-lines t
              indent-tabs-mode nil
              mouse-yank-at-point t
              show-trailing-whitespace t
              python-fill-docstring-style "symmetric"
              org-todo-keywords '((sequence "TODO" "DONE" "WAIT"))
              ispell-program-name "aspell")

(setq-default js-switch-indent-offset 2)

(menu-bar-mode -1)
(tool-bar-mode -1)
(when (boundp 'scroll-bar-mode)
  (scroll-bar-mode nil))

(global-hl-line-mode t)
(global-linum-mode t)

;; Disable backup and auto saving to #files#. That's what version control is for
(setq auto-save-default nil)
(setq make-backup-files nil)

(global-auto-revert-mode t) ; Auto-revert file to disk version when files change externally
(setq require-final-newline t) ; Always add new line to the end of a file
(add-hook 'before-save-hook    ; Delete trailing swhitespace on save
          'delete-trailing-whitespace)

(global-set-key (kbd "C-/") 'comment-region)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

;; C-x c is bound to kill-emacs. I don't need a hotkey for that.
(global-unset-key (kbd "C-x c"))

(require 'package)
(setq package-enable-at-startup nil)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;;(load-file (expand-file-name "helm.el" user-emacs-directory))
(load-file (expand-file-name "fira.el" user-emacs-directory))
(load-file (expand-file-name "ivy.el" user-emacs-directory))

(use-package evil
  :ensure t
  :config
  (evil-mode t)

  (use-package evil-org
    :ensure t)

  (use-package evil-magit
    :ensure t)

  (evil-define-command my/evil-save-and-kill (file &optional bang)
    "Saves the current buffer and kills the current buffer."
    :repeat nil
    (interactive "<f><!>")
    (evil-write nil nil nil file bang)
    (kill-buffer))

  (evil-ex-define-cmd "wq" 'my/evil-save-and-kill)

  (evil-define-command my/evil-kill (&optional force)
    "Kills the current buffer"
    :repeat nil
    (interactive "<!>")
    (kill-buffer))

  (evil-ex-define-cmd "q" 'my/evil-kill))

(use-package atom-dark-theme
  :ensure t
  :config
  (load-theme 'atom-dark t))

(use-package projectile
  :ensure t
  :config
  (projectile-mode)

  (use-package ag
    :ensure t)

  (use-package projectile-ripgrep
    :ensure t
    :config
    (global-set-key (kbd "C-c p s r") 'projectile-ripgrep)))

(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode)

  (use-package flycheck-flow
    :ensure t
    :config
    (add-hook 'javascript-mode-hook 'flycheck-mode)
    (add-hook 'web-mode-hook 'flycheck-mode)
    (flycheck-add-next-checker 'javascript-eslint 'javascript-flow)
    (flycheck-add-next-checker 'javascript-flow 'javascript-flow-coverage))

  (defun my/use-project-lint-executables ()
    "Try to locate lint executables from project-local directories."
    (let* ((eslint (if (projectile-project-p)
                       (car (projectile-expand-paths '("node_modules/.bin/eslint")))
                     nil))
           (jshint (if (projectile-project-p)
                       (car (projectile-expand-paths '("node_modules/.bin/jshint")))
                     nil))
           (flake8 (if (projectile-project-p)
                       (car (projectile-expand-paths '("venv/bin/flake8")))
                     nil)))
      (when (and eslint (file-executable-p eslint))
        (setq-local flycheck-javascript-eslint-executable eslint))
      (when (and jshint (file-executable-p jshint))
        (setq-local flycheck-javascript-jshint-executable jshint))
      (when (and flake8 (file-executable-p flake8))
        (setq-local flycheck-python-flake8-executable flake8))))

  (add-hook 'flycheck-mode-hook #'my/use-project-lint-executables))

(use-package dockerfile-mode
  :ensure t)

;; Auto detect indentation of files
(use-package dtrt-indent
  :ensure t
  :config (dtrt-indent-mode 1))

;; Save files when Emacs loses focus
(use-package focus-autosave-mode
  :ensure t
  :config (focus-autosave-mode))

(use-package magit
  :ensure t
  :config (global-set-key (kbd "C-x g") 'magit-status))

(use-package powerline
  :ensure t
  :config (powerline-center-evil-theme))

(use-package ledger-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.ledger$" . ledger-mode)))

(use-package nix-mode
  :ensure t)

(use-package company
  :ensure t
  :config
  (global-company-mode))

(use-package js-doc
  :ensure t)

(use-package yaml-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
  (add-hook 'yaml-mode-hook
      '(lambda ()
        (define-key yaml-mode-map "\C-m" 'newline-and-indent))))

(use-package web-mode
  :ensure t
  :config
  (add-hook 'web-mode-hook
      (lambda ()
        ;; short circuit js mode and just do everything in jsx-mode
        (if (equal web-mode-content-type "javascript")
            (web-mode-set-content-type "jsx")
          (message "now set to: %s" web-mode-content-type))))

  (flycheck-add-mode 'javascript-eslint 'web-mode))

(use-package nix-buffer
  :ensure t
  :config
  (defun nix-buffer-find-file-hook ()
    (when (not (file-remote-p (buffer-file-name)))
      (nix-buffer)))
  (add-hook 'find-file-hook 'nix-buffer-find-file-hook))

(use-package polymode
  :ensure t
  :defer t)

(use-package poly-markdown
  :ensure polymode
  :defer t
  :mode (("\\.md" . poly-markdown-mode)
         ("\\.mkd" . poly-markdown-mode)
         ("\\.markdown" . poly-markdown-mode))
  :config (add-hook 'poly-markdown-mode (lambda () flyspell-mode)))

(use-package firestarter
  :ensure t
  :config
  (firestarter-mode))

(use-package elm-mode
  :ensure t
  :config
  (add-to-list 'company-backends 'company-elm))

(use-package direnv
  :ensure t
  :config
  (direnv-mode))


(use-package rjsx-mode
  :ensure t
  :config
  ;; Use rjsx mode for all js files, not only JSX files
  (add-to-list 'auto-mode-alist '(".*\\.js\\'" . rjsx-mode)))

(provide 'init)
;;; init.el ends here
