;;### Add load path ###
(add-to-list 'load-path "~/.emacs.d/site-lisp/")
(add-to-list 'load-path "~/.emacs.d/site-lisp/cedet-1.1/common")
(add-to-list 'load-path "~/.emacs.d/site-lisp/cedet-1.1/semantic-ia")
(add-to-list 'load-path "~/.emacs.d/site-lisp/yasnippet-0.6.1c")
(add-to-list 'load-path "~/.emacs.d/site-lisp/markdown-mode")
(add-to-list 'load-path "~/.emacs.d/site-lisp/color-theme-6.6.0")
(add-to-list 'load-path "~/.emacs.d/site-lisp/emacs-w3m/")
(add-to-list 'load-path "~/.emacs.d/site-lisp/emacs-jabber-0.8.91/")
(add-to-list 'load-path "~/.emacs.d/site-lisp/magit")
(add-to-list 'load-path "~/.emacs.d/site-lisp/mo-git-blame")
(add-to-list 'load-path "~/.emacs.d/site-lisp/tramp-2.2.7/lisp/")
(add-to-list 'load-path "~/.emacs.d/site-lisp/android-mode")
(add-to-list 'load-path "~/.emacs.d/site-lisp/ecb")
(add-to-list 'load-path "~/.emacs.d/site-lisp/js2")
(add-to-list 'load-path "~/.emacs.d/site-lisp/iedit")
(add-to-list 'load-path "~/.emacs.d/site-lisp/python-mode.el-6.1.2")
(add-to-list 'load-path "~/.emacs.d/site-lisp/auto-complete-1.3.1")
(add-to-list 'load-path "~/.emacs.d/site-lisp/jade-mode")

;;(add-to-list 'load-path "~/.emacs.d/site-lisp/emacs-nav-49")

;;### Add load custom theme path ###
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/zenburn-emacs/")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/emacs-color-theme-solarized/")

;; ### require ###
(require 'cedet)
(require 'yasnippet)
(require 'point-undo)
(require 'sudoku)
;;(require 'bitlbee)
(require 'magit)


;;
;; ### Key Binding ###
;; ______________________________________________________________________
;;(define-key global-map "\C-xg" 'goto-line)
(global-set-key [f5] 'point-undo)
(global-set-key [f6] 'point-redo)
(global-set-key [?\C-x ?\C-g] 'goto-line)
(global-set-key [?\C-x ?\C-r] 'replace-string)
;;(global-set-key [?\C-x ?\j] 'semantic-ia-fast-jump)
(global-set-key [(meta n)] 'tabbar-forward-tab)
(global-set-key [(meta p)] 'tabbar-backward-tab)
;;(global-set-key (kbd "<apps>") (lookup-key global-map (kbd "C-x")))
;;(global-set-key (kbd "<apps>") 'goto-line)
;;(global-set-key [C-A-f5] 'goto-line)
;;(define-key ctl-x-map "g" 'goto-line)
;;(define-key ctl-x-map "," 'point-undo)
;;(define-key ctl-x-map "." 'point-redo)
;;(define-key global-map "\C-x\C-g" 'goto-line)
;;(define-key global-map "\C-x\C-r" 'replace-string)
;;(define-key semantic-tag-folding-mode-map (kbd "C-c , -") 'semantic-tag-folding-fold-block)
;;(define-key semantic-tag-folding-mode-map (kbd "C-c , +") 'semantic-tag-folding-show-block)
;;(define-key global-map (kbd "M-/") 'semantic-ia-complete-symbol)
(global-set-key [f12] 'semantic-ia-fast-jump)
(global-set-key [S-f12]
                (lambda ()
                  (interactive)
                  (if (ring-empty-p (oref semantic-mru-bookmark-ring ring))
                      (error "Semantic Bookmark ring is currently empty"))
                  (let* ((ring (oref semantic-mru-bookmark-ring ring))
                         (alist (semantic-mrub-ring-to-assoc-list ring))
                         (first (cdr (car alist))))
                    (if (semantic-equivalent-tag-p (oref first tag)
                                                   (semantic-current-tag))
                        (setq first (cdr (car (cdr alist)))))
                    (semantic-mrub-switch-tags first))))
;; ______________________________________________________________________


;;
;; ### Setting backups ###
;; ______________________________________________________________________
;;(setq make-backup-files nil)
(setq backup-directory-alist (quote (("." . "~/.emacs-backups"))))
(setq auto-save-default nil)
;;(setq auto-save-file-name-transforms
;;      `((".*" ,"~/.emacs-auto-save-list" t)))
;; ______________________________________________________________________

;; ### Make Emacs stop asking "Active processes exist; kill them and exit anyway" ###
(defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
  "Prevent annoying \"Active processes exist\" query when you quit Emacs."
  (flet ((process-list ())) ad-do-it))


;;
;; ### Using server mode ###
;; ______________________________________________________________________
;;(server-start)
;; ______________________________________________________________________


;; ### emacs modes ###
(autoload 'iedit-mode "iedit" "Edit multiple regions with the same content simultaneously." t)
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
;; ______________________________________________________________________

;;
;; ### Auto select mode ###
;; ______________________________________________________________________
(add-to-list 'auto-mode-alist '(".mk'" . makefile-mode))
(add-to-list 'auto-mode-alist '("\\defconfig\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("\\COMMIT_EDITMSG\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("conf" . conf-mode))
(add-to-list 'auto-mode-alist '("\\Kconfig\\'" . shell-script-mode))
(add-to-list 'auto-mode-alist '(".dts" . c-mode))
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
;; ______________________________________________________________________

;;############ Enable narrow to region ##############
(put 'narrow-to-region 'disabled nil)
;; ______________________________________________________________________

;;
;;############ Closing all other buffers in Emacs ##############

(defun kill-other-buffers ()
    "Kill all other buffers."
    (interactive)
    (mapc 'kill-buffer
          (delq (current-buffer)
                (remove-if-not 'buffer-file-name (buffer-list)))))
;; ______________________________________________________________________

;;
;;############ Kernel C style ##############
;; ______________________________________________________________________
;;(setq c-basic-offset 8)
;;(setq-default indent-tabs-mode nil)

(defun c-lineup-arglist-tabs-only (ignored)
  "Line up argument lists by tabs, not spaces"
  (let* ((anchor (c-langelem-pos c-syntactic-element))
	 (column (c-langelem-2nd-pos c-syntactic-element))
	 (offset (- (1+ column) anchor))
	 (steps (floor offset c-basic-offset)))
    (* (max steps 1)
       c-basic-offset)))

(add-hook 'c-mode-common-hook
	  (lambda ()
	    ;; Add kernel style
	    (c-add-style
	     "linux-tabs-only"
	     '("linux" (c-offsets-alist
			(arglist-cont-nonempty
			 c-lineup-gcc-asm-reg
			 c-lineup-arglist-tabs-only))))))

(add-hook 'c-mode-hook
	  (lambda ()
	    (let ((filename (buffer-file-name)))
	      ;; Enable kernel mode for the appropriate files
	      (when (and filename
			 (string-match (expand-file-name "~/src/linux-trees")
				       filename))
		(setq indent-tabs-mode t)
		(c-set-style "linux-tabs-only")))))

;; Add kernel style
(c-add-style "kernel-coding"
	     '( "linux"
		(c-basic-offset . 8)
		(indent-tabs-mode . t)
		(tab-width . 8)
		(c-comment-only-line-offset . 0)
		(c-hanging-braces-alist
		 (brace-list-open)
		 (brace-entry-open)
		 (substatement-open after)
		 (block-close . c-snug-do-while)
		 (arglist-cont-nonempty))
		(c-cleanup-list brace-else-brace)
		(c-offsets-alist
		 (statement-block-intro . +)
		 (knr-argdecl-intro . 0)
		 (substatement-open . 0)
		 (substatement-label . 0)
		 (label . 0)
		 (statement-cont . +))
		))

(c-add-style "my-coding-style"
	     '( "k&r"
		(c-basic-offset . 4)
		(indent-tabs-mode . nil)
		(tab-width . 4)
		(c-comment-only-line-offset . 0)
		(c-hanging-braces-alist
		 (brace-list-open)
		 (brace-entry-open)
		 (substatement-open after)
		 (block-close . c-snug-do-while)
		 (arglist-cont-nonempty))
		(c-cleanup-list brace-else-brace)
		(c-offsets-alist
		 (statement-block-intro . +)
		 (knr-argdecl-intro . 0)
		 (substatement-open . 0)
		 (substatement-label . 0)
		 (label . 0)
		 (statement-cont . +))
		))

;;(defun linux-c-mode ()
;;  "C mode with adjusted defaults for use with the Linux kernel."
;;  (interactive)
;;  (c-mode)
;;  (c-set-style "K&R")
;;  (setq tab-width 8)
;;  (setq indent-tabs-mode t)
;;  (setq c-basic-offset 8))

;;(defvar kernel-keywords '("linux" "kernel" "driver")
;;  "Keywords which are used to indicate this file is kernel code.")

(add-hook 'c-mode-hook
	  (lambda ()
	    (c-set-style "kernel-coding")))
(add-hook 'c++-mode-hook
	  (lambda ()
	    (c-set-style "my-coding-style")))
(add-hook 'python-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode t)
	    (setq python-indent 8)
	    (setq tab-width 4)))
;;	      (let* ((filename (buffer-file-name))
;;		     (is-kernel-code nil))
;;		(if filename
;;		    (dolist (keyword kernel-keywords)
;;		      (if (string-match keyword filename)
;;			  (setq is-kernel-code t))))
;;		(if is-kernel-code
;;		    (c-set-style "kernel-coding")
;;		  (c-set-style "my-coding-style")))))

;;(add-hook 'c-mode-hook 'kernel-coding)
;;(add-hook 'c++-mode-hook 'my-coding-style)

(put 'set-goal-column 'disabled nil)
;; ______________________________________________________________________


;;
;; ediff setting
;; ______________________________________________________________________
;; only hilight current diff:
(setq-default ediff-highlight-all-diffs 'nil)

;; turn off whitespace checking:
(setq ediff-diff-options "-w")
;; ______________________________________________________________________


;;
;; ### My Test Program ###
;; ______________________________________________________________________
(require 'my-emacs)

(defun count-word-buffer ()
  (interactive)
  (let ((count 0))
    (save-excursion
      (goto-char (point-min))
      (while (< (point) (point-max))
	(forward-word 1)
	(setq count (1+ count)))
      (message "buffer contains %d words." count))))
;; ______________________________________________________________________


;;
;; Enable EDE (Project Management) features
;; ______________________________________________________________________
;;(require 'ecb)
;;(global-ede-mode )1
;; Enable SRecode (Template management) minor-mode.
;;(global-srecode-minor-mode 1)
;; ______________________________________________________________________


;;
;; ido mode
;; ______________________________________________________________________
(require 'ido)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode t)
;; ______________________________________________________________________


;;
;; xcscope
;; ______________________________________________________________________
;; ### plugs setting ###
(require 'xcscope)
(setq cscope-do-not-update-database "t")
(setq cscope-set-initial-directory "./")

;; ### add cscope hook
(add-hook 'java-mode-hook (function cscope:hook))
(add-hook 'makefile-mode-hook (function cscope:hook))
(add-hook 'conf-mode-hook (function cscope:hook))
;; ______________________________________________________________________


;;
;; yasnippet
;; ______________________________________________________________________
(yas/initialize)
(yas/load-directory "~/.emacs.d/site-lisp/yasnippet-0.6.1c/snippets")
;; ______________________________________________________________________


;;
;; semantic-ia
;; ______________________________________________________________________
(require 'semantic-ia)

(semantic-load-enable-minimum-features)
(semantic-load-enable-code-helpers)
(semantic-load-enable-guady-code-helpers)
(semantic-load-enable-excessive-code-helpers)
;;(semantic-load-enable-semantic-debugging-helpers)
;;(require 'semantic-tag-folding nil 'noerror)
;;(global-semantic-tag-folding-mode 1)
(global-semantic-decoration-mode nil)
(global-semantic-stickyfunc-mode nil)
;; ______________________________________________________________________


;;
;; python-mode
;;
(require 'python-mode)

(setq py-shell-name "ipython")
(setq py-load-pymacs-p t)
;; ______________________________________________________________________

;;
;; auto-complete
;;
(require 'auto-complete-config)
(ac-config-default)
(ac-set-trigger-key "TAB")
;; ______________________________________________________________________


;;
;; bing translate
;; ______________________________________________________________________
;; Your appId. Application at http://www.bing.com/toolbox/bingdeveloper/
(defvar bingtranslate-appId "RzST1D9TBCZ34kYPD2Pm0PmGaSfNojInLLzmXDlsmhk")

;; Your priority language to translate from.
(defvar bingtranslate-from-priority "en")

;; Your priority language to translate to.
(defvar bingtranslate-to-priority "zh-CHT")

(require 'bing-translate-api)
;; key bounding
(global-set-key [M-f1] 'bingtranslate-region-or-input)

;; add a pair of language
;; Parameters: "pair name" "from language" "to language"
(bingtranslate-add-pair "1" "zh-CHT" "en")
;; ______________________________________________________________________


;;
;; cflow
;; ______________________________________________________________________
(require 'cflow-mode)
(defvar cmd nil nil)
(defvar cflow-buf nil nil)
(defvar cflow-buf-name nil nil)

(defun yyc/cflow-function (function-name)
  "Get call graph of inputed function. "
  ;;(interactive "sFunction name:\n")
  (interactive (list (car (senator-jump-interactive "Function name: "
						    nil nil nil))))
  (setq cmd (format "cflow  -b --main=%s %s" function-name buffer-file-name))
  (setq cflow-buf-name (format "**cflow-%s:%s**"
			       (file-name-nondirectory buffer-file-name)
			       function-name))
  (setq cflow-buf (get-buffer-create cflow-buf-name))
  (set-buffer cflow-buf)
  (setq buffer-read-only nil)
  (erase-buffer)
  (insert (shell-command-to-string cmd))
  (pop-to-buffer cflow-buf)
  (goto-char (point-min))
  (cflow-mode)
  )
;; ______________________________________________________________________

;;
;; Customizing colors used in diff mode
;; ______________________________________________________________________
(defun custom-diff-colors ()
  "update the colors for diff faces"
  (set-face-attribute
   'diff-added nil :foreground "green")
  (set-face-attribute
   'diff-removed nil :foreground "red")
  (set-face-attribute
   'diff-changed nil :foreground "purple"))
(eval-after-load "diff-mode" '(custom-diff-colors))
;; ______________________________________________________________________


;;
;; color-theme
;; ______________________________________________________________________
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)))
;;     (color-theme-hober)))

;;(load-theme 'zenburn t)
(load-theme 'solarized-dark t)
;;(load-theme 'solarized-light t)
;; ______________________________________________________________________


;;
;; jabber
;; ______________________________________________________________________
(require 'jabber)
(setq jabber-account-list
      '(("codediablos@gmail.com"
	 (:network-server . "talk.google.com")
	 (:connection-type . ssl))))
;; ______________________________________________________________________


;;
;; w3m
;; ______________________________________________________________________
(require 'w3m)
(require 'w3m-load)
;;(require 'mime-w3m)
(setq w3m-use-cookies t)
(setq w3m-default-display-inline-images t)
;; ______________________________________________________________________


;;
;; markdown-mode
;; ______________________________________________________________________
(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)
(setq auto-mode-alist
      (cons '("\\.text" . markdown-mode) auto-mode-alist))
;; ______________________________________________________________________


;;
;; mo-git-blame
;; ______________________________________________________________________
(autoload 'mo-git-blame-file "mo-git-blame" nil t)
(autoload 'mo-git-blame-current "mo-git-blame" nil t)
;; ______________________________________________________________________


;;
;; tabbar
;; (install-elisp "http://www.emacswiki.org/emacs/download/tabbar.el")
;; ______________________________________________________________________
(require 'tabbar)
;;(require 'ctab)

(tabbar-mode t)
;;(ctab-mode t)

;;(setq tabbar-buffer-groups-function nil)

(dolist (btn '(tabbar-buffer-home-button
	       tabbar-scroll-left-button
	       tabbar-scroll-right-button))
  (set btn (cons (cons "" nil)
		 (cons "" nil))))

(setq tabbar-separator '(1.5))

(set-face-attribute
 'tabbar-default nil
 :family "Comic Sans MS"
 :background "black"
 :foreground "gray72"
 :height 1.0)
(set-face-attribute
 'tabbar-unselected nil
 :background "black"
 :foreground "grey72"
 :box nil)
(set-face-attribute
 'tabbar-selected nil
 :background "black"
 :foreground "yellow"
 :box nil)
(set-face-attribute
 'tabbar-button nil
 :box nil)
(set-face-attribute
 'tabbar-separator nil
 :height 1.5)

(defun tabbar-add-tab (tabset object &optional append_ignored)
  "Add to TABSET a tab with value OBJECT if there isn't one there yet.
 If the tab is added, it is added at the beginning of the tab list,
 unless the optional argument APPEND is non-nil, in which case it is
 added at the end."
  (let ((tabs (tabbar-tabs tabset)))
    (if (tabbar-get-tab object tabset)
	tabs
      (let ((tab (tabbar-make-tab object tabset)))
	(tabbar-set-template tabset nil)
	(set tabset (sort (cons tab tabs)
			  (lambda (a b) (string< (buffer-name (car a)) (buffer-name (car b))))))))))
;; ______________________________________________________________________


;;
;; tramp
;; (install-elisp "https://savannah.gnu.org/projects/tramp/")
;; ______________________________________________________________________
(add-to-list 'Info-default-directory-list "~/.emacs.d/tramp-2.2.7/info/")
(require 'tramp)
;; ______________________________________________________________________


;;
;; undo-tree
;; ______________________________________________________________________
;;(require 'undo-tree)
;;(global-undo-tree-mode)
;; ______________________________________________________________________

;;
;; aspell
;; ______________________________________________________________________
(setq-default ispell-program-name "aspell")
(setq text-mode-hook '(lambda()
                        (flyspell-mode t)
                        ))
;; ______________________________________________________________________


;;
;; android mode
;; ______________________________________________________________________
(require 'android-mode)
;;(setq android-mode-sdk-dir "~/Android/android-sdk-linux")
(setq android-mode-sdk-dir "~/Android/android-sdks")
;; ______________________________________________________________________

;;
;; ecb mode
;; ______________________________________________________________________
(require 'ecb)
(defconst ecb-cedet-required-version-max '(1 1 4 9)
  "Maximum version of CEDET currently accepted by ECB.See `ecb-required-cedet-version-min' for an explanation.")
(setq stack-trace-on-error t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ecb-layout-window-sizes nil)
 '(ecb-options-version "2.40"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(global-set-key [f1] 'ecb-hide-ecb-windows)
(global-set-key [f2] 'ecb-show-ecb-windows)
(global-set-key [f9] 'ecb-minor-mode)

;;(define-key global-map "/C-c1" 'ecb-maximize-window-directories)
;;(define-key global-map "/C-c2" 'ecb-maximize-window-sources)
;;(define-key global-map "/C-c3" 'ecb-maximize-window-methods)
;;(define-key global-map "/C-c4" 'ecb-maximize-window-history)
;;(define-key global-map "/C-c`" 'ecb-restore-default-window-sizes)
(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)
;; ______________________________________________________________________

;;
;; ecb mode
;; ______________________________________________________________________
;;(require 'nav)
;;(nav-disable-overeager-window-splitting)
;;(global-set-key [f8] 'nav-toggle)
;; ______________________________________________________________________

;;
;; web mode
;; ______________________________________________________________________
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(setq web-mode-engines-alist
      '(("php"    . "\\.phtml\\'")
        ("blade"  . "\\.blade\\."))
)
;; ______________________________________________________________________

;;
;; jade-mode
;; ______________________________________________________________________
(require 'sws-mode)
(require 'jade-mode)
(add-to-list 'auto-mode-alist '("\\.styl$" . sws-mode))
(add-to-list 'auto-mode-alist '("\\.jade$" . jade-mode))
;; ______________________________________________________________________
