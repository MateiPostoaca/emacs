(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq initial-scratch-message "")
(setq visible-bell t)

(use-package no-littering)
(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

(set-fringe-mode 10)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)

(load-theme 'modus-operandi t)

;; Line numbers
(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Set monospace font
(add-to-list 'default-frame-alist '(font . "JetBrainsMono Nerd Font-10"))
(add-to-list 'default-frame-alist '(line-spacing . 0))

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package command-log-mode)

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package all-the-icons)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package ivy-rich)

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package evil)
(evil-mode 1)

(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(use-package org
  :hook (org-mode . efs/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")
  (setq org-hide-emphasis-markers t)
  (efs/org-font-setup))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.0)
                  (org-level-2 . 1.0)
                  (org-level-3 . 1.0)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.0)
                  (org-level-6 . 1.0)
                  (org-level-7 . 1.0)
                  (org-level-8 . 1.0)))
    (set-face-attribute (car face) nil :font "JetBrainsMono Nerd Font-10" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font-10")
(set-face-attribute 'fixed-pitch nil :font "JetBrainsMono Nerd Font-10")
(set-face-attribute 'variable-pitch nil :font "JetBrainsMono Nerd Font-10")

(dolist (face '(default fixed-pitch))
  (set-face-attribute `,face nil :font "JetBrainsMono Nerd Font-10"))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 80
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

(setq org-directory "/mnt/d/Documents/Personal/Notes")
(setq org-agenda-files (directory-files-recursively org-directory "\\.org$"))

(setq org-agenda-start-with-log-mode t)
(setq org-log-done 'time)
(setq org-log-into-drawer t)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(with-eval-after-load 'org
  (define-key org-mode-map (kbd "M-n") #'org-next-link)
  (define-key org-mode-map (kbd "M-p") #'org-previous-link))
(add-hook 'org-todo-repeat-hook #'org-reset-checkbox-state-subtree)

(defun my/org-journal-file-name ()
  (let ((dir (expand-file-name (format-time-string "%Y/%m/" (current-time))
                               (concat org-directory "/Struct/Journal/"))))
    (unless (file-directory-p dir)
      (make-directory dir t))
    (expand-file-name (format-time-string "%Y-%m-%d.org" (current-time)) dir)))

(defun my/org-journal-template ()
  (format "_Journal Entry - %s_\n\n"
          (format-time-string "%Y/%m/%d %A")))

(defun my/open-daily-journal ()
  (interactive)
  (let ((journal-file (my/org-journal-file-name)))
    (find-file journal-file)
    (when (not (file-exists-p journal-file))
      (insert (my/org-journal-template))
      (save-buffer))))

(global-set-key (kbd "C-c f j") 'my/open-daily-journal)

(setq org-agenda-custom-commands
  '(("d" "Daily Agenda"
     ((agenda "" ((org-agenda-span 'day)))))))

(setq user-emacs-directory (expand-file-name "~/.cache/emacs"))
(setq make-backup-files nil)

;; Setup Romanian keyboard
(setq default-input-method "romanian-prefix")
(set-input-method "romanian-prefix")
(defvar use-default-input-method t)
(make-variable-buffer-local 'use-default-input-method)
(defun activate-default-input-method ()
  (interactive)
  (if use-default-input-method
      (activate-input-method default-input-method)
    (inactivate-input-method)))
(add-hook 'after-change-major-mode-hook 'activate-default-input-method)
(add-hook 'minibuffer-setup-hook 'activate-default-input-method)
(defun inactivate-default-input-method ()
  (setq use-default-input-method nil))
(add-hook 'c-mode-hook 'inactivate-default-input-method)

(setq org-link-frame-setup
   '((vm . vm-visit-folder-other-frame)
     (vm-imap . vm-visit-imap-folder-other-frame)
     (gnus . org-gnus-no-new-news)
     (file . find-file)
     (wl . wl-other-frame)))
(global-set-key (kbd "C-<tab>") 'mode-line-other-buffer)
(setq split-width-threshold 80)
(setq split-height-threshold nil)
(setq org-startup-with-inline-images t)
(setq org-image-actual-width nil)
