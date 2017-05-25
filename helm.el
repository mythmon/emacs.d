;;; helm --- Helm configuration
;;; Commentary:
;;;   My Helm configuration, based on http://tuhdo.github.io/helm-intro.html
;;; Code:

(use-package helm
  :ensure t
  :init

  ;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
  ;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
  ;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
  (global-set-key (kbd "C-c h") 'helm-command-prefix)
  (global-unset-key (kbd "C-x c"))

  :config
  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
  (define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

  (setq helm-split-window-in-side-p           t  ; open helm buffer inside current window
        helm-move-to-line-cycle-in-source     t  ; wrap top-to-bottom
        helm-echo-input-in-header-line        t) ; Send current input in header-line when non-nil.

  (add-hook 'helm-minibuffer-set-up-hook 'helm-hide-minibuffer-maybe)

  (setq helm-autoresize-max-height 0)
  (setq helm-autoresize-min-height 20)

  (helm-mode 1)

  (helm-mode 1)
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "C-x f") 'helm-find-files)
  (global-set-key (kbd "C-x C-f") 'helm-find-files))

(provide 'helm)
;;; helm.el ends here
