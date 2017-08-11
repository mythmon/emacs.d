;;; package -- summary

;;; Commentary:
;;; Enable Fira Code and it's ligatures

;;; Code:

;; Someday, it would be nice to use Fira Code and get the ligatures. Watch
;; https://github.com/tonsky/FiraCode/wiki/Setting-up-Emacs for advice
;; about this.

(defun my/big-font ()
  "Set the default font to a big font, suitable for 4k monitors."
  (interactive)
  (set-frame-font "Fira Mono 16" t))

(defun my/small-font ()
  "Set the default font to a small font, suitable for laptop screens."
  (interactive)
  (set-frame-font "Fira Mono 10" t))

(my/small-font)

(provide 'fira)
;;; fira ends here
