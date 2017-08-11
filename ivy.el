;;; ivy --- Ivy configuration
;;; Commentary:
;;;   My Ivy configuration
;;; Code:

(use-package counsel
  :ensure t

  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")

  ;; Make C-x f and C-x C-f the same.
  (global-set-key (kbd "C-x f") 'find-file)

  ;; recommended keybindings
  ;; Ivy-based interface to standard commands
  (global-set-key (kbd "C-s") 'swiper)
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "<f1> f") 'counsel-describe-function)
  (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
  (global-set-key (kbd "<f1> l") 'counsel-find-library)
  (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
  (global-set-key (kbd "<f2> u") 'counsel-unicode-char)

  ;; Ivy-based interface to shell and system tools
  (global-set-key (kbd "C-c g") 'counsel-git)
  (global-set-key (kbd "C-c j") 'counsel-git-grep)
  (global-set-key (kbd "C-c k") 'counsel-ag)
  (global-set-key (kbd "C-x l") 'counsel-locate)
  (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)

  ;; Ivy-resume and other commands
  (global-set-key (kbd "C-c C-r") 'ivy-resume)

  ;; Magit+Ivy
  (setq magit-completing-read-function 'ivy-completing-read)

  ;; Magit+Projectile
  (setq projectile-completion-system 'ivy)

  (setq ivy-re-builders-alist
        '((t . ivy--regex-ignore-order))))

(provide 'ivy)
;;; ivy.el ends here
