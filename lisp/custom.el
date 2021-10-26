(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; /////////////////////////////////////////////////////////
(global-hl-line-mode 1)
(fringe-mode 0)
(set-face-attribute 'default nil :height 160)
(setq ring-bell-function 'ignore)

(keyfreq-mode 1)

;; (defun alternate-buffer ()
;;   (interactive)
;;   (switch-to-buffer (other-buffer)))

(defun xah-open-in-external-app (&optional file)
  "Open the current file or dired marked files in external app.

The app is chosen from your OS's preference."
  (interactive)
  (let ( doIt
         (myFileList
          (cond
           ((string-equal major-mode "dired-mode") (dired-get-marked-files))
           ((not file) (list (buffer-file-name)))
           (file (list file)))))

    (setq doIt (if (<= (length myFileList) 5)
                   t
                 (y-or-n-p "Open more than 5 files? ") ) )

    (when doIt
      (cond
       ((string-equal system-type "windows-nt")
        (mapc (lambda (fPath) (w32-shell-execute "open" (replace-regexp-in-string "/" "\\" fPath t t)) ) myFileList))
       ((string-equal system-type "darwin")
        (mapc (lambda (fPath) (shell-command (format "open \"%s\"" fPath)) )  myFileList) )
       ((string-equal system-type "gnu/linux")
        (mapc (lambda (fPath) (let ((process-connection-type nil)) (start-process "" nil "xdg-open" fPath))) myFileList) ) ) ) ) )

(defun open-emacs-dotfile()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(defun open-emacs-custom()
  (interactive)
  (find-file "~/.emacs.d/lisp/custom.el"))

(defun open-emacs-evil()
  (interactive)
  (find-file "~/.emacs.d/lisp/init-evil.el"))

;; //////////////////////      tada-packages //////////////////////

;; (defun er-indent-buffer ()
;;   "Indent the currently visited buffer."
;;   (interactive)
;;   (indent-region (point-min) (point-max)))

(defun er-indent-buffer ()
  "Indent the currently visited buffer."
  (interactive)
  (indent-region (point-min) (point-max)))

(defun er-indent-region-or-buffer ()
  "Indent a region if selected, otherwise the whole buffer."
  (interactive)
  (save-excursion
    (if (region-active-p)
        (progn
          (indent-region (region-beginning) (region-end))
          (message "Indented selected region."))
      (progn
        (er-indent-buffer)
        (message "Indented buffer.")))))

(use-package nyan-mode
  :ensure t
  :config (nyan-mode 1))

(use-package youdao-dictionary
  :ensure t)

(use-package symbol-overlay
  :ensure t
  )

(use-package evil-nerd-commenter
  :ensure t
  :config
  ;; (evilnc-default-hotkeys)
  ;; (define-key evil-normal-state-map (kbd ",/") 'evilnc-comment-or-uncomment-lines)
  ;; (define-key evil-visual-state-map (kbd ",/") 'evilnc-comment-or-uncomment-lines)
  )

(use-package mwim
  :ensure t)
;; :bind (("C-a" . mwim-)
;; ("C-e" . mwim-end)))
                                        ;(global-set-key (kbd "C-a") 'mwim-beginning)
                                        ;(global-set-key (kbd "C-e") 'mwim-end)

(use-package restart-emacs
  :ensure t)

;; (use-package powerline
;;   :ensure t
;;   :config
;;   (powerline-center-evil-theme))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(use-package hungry-delete
  :ensure t)

;(define-key evil-visual-state-map (kbd ",/") 'evilnc-comment-or-uncomment-lines)
;(define-key evil-insert-state-map (kbd "DEL") 'hungry-delete-backward)
;(define-key evil-insert-state-map (kbd "C-d") 'hungry-delete-forward)

(global-set-key (kbd "M-i") 'symbol-overlay-put)
(global-set-key (kbd "M-n") 'symbol-overlay-switch-forward)
(global-set-key (kbd "M-p") 'symbol-overlay-switch-backward)
;; (global-set-key (kbd "<f7>") 'symbol-overlay-mode)
(global-set-key (kbd "<f8>") 'symbol-overlay-remove-all)


(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)

(setq which-key-idle-delay 0.06)
(setq which-key-idle-secondary-delay 0.05)

(provide 'custom)
