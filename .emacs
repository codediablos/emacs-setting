;;### Add load config file ###
(load-file "~/.emacs.d/minimial-cedet-config.el")

(require 'package)
;; list the packages you want
(setq package-list '("auto-complete"))
;; list the repositories containing them
(setq package-archives '(("melpa-stable" . "https://stable.melpa.org/packages/")))
;;			 ("elpa" . "http://tromey.com/elpa/")
;;			 ("gnu" . "http://elpa.gnu.org/packages/")
;;			 ("marmalade" . "http://marmalade-repo.org/packages/")))

;; activate all the packages (in particular autoloads)
(package-initialize)

;; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

;; install the missing packages
;;(dolist (package package-list)
;;  (unless (package-installed-p package)
;;    (package-install package))

;;### Add load path ###
(let ((base "~/.emacs.d/elpa/"))
  (add-to-list 'load-path base)
  (dolist (f (directory-files base))
    (let ((name (concat base "/" f)))
      (when (and (file-directory-p name)
		 (not (equal f ".."))
		 (not (equal f ".")))
	(add-to-list 'load-path name)))))

(add-to-list 'load-path "~/.emacs.d/site-lisp/")

;;(setq debug-on-error t)

;; Show the current function name in the header line
(which-function-mode)

;; check OS type
(cond
 ((string-equal system-type "windows-nt") ; Microsoft Windows
;;  (progn
;;    (message "Microsoft Windows") )
  )
 ((string-equal system-type "darwin")   ; Mac OS X
;;  (progn
;;    (message "Mac OS X") )
  )
 ((string-equal system-type "gnu/linux") ; linux
;;  (progn
;;    (message "Linux") )
  )
 )

;;### Add load custom theme path ###
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

;; ### require ###
(require 'point-undo)
(require 'sudoku)

(setq column-number-mode t)

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
(global-set-key [f8] 'tabbar-forward-tab)
(global-set-key [f7] 'tabbar-backward-tab)
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

;;osx keys
;;(setq mac-option-key-is-meta 'meta)
;;(setq mac-command-key-is-meta nil)
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


;; ### emacs modes ###
(autoload 'iedit-mode "iedit" "Edit multiple regions with the same content simultaneously." t)
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
;; ______________________________________________________________________

;;
;; ### Auto select mode ###
;; ______________________________________________________________________
(add-to-list 'auto-mode-alist '(".mk'" . makefile-gmake-mode))
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-to-list 'auto-mode-alist '("\\defconfig\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("\\COMMIT_EDITMSG\\'" . conf-mode))
(add-to-list 'auto-mode-alist '(".conf'" . conf-mode))
(add-to-list 'auto-mode-alist '("\\Kconfig\\'" . shell-script-mode))
(add-to-list 'auto-mode-alist '(".dts" . c-mode))
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
(add-hook 'java-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode nil)
	    (setq tab-width 4)))
(add-hook 'js2-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode nil)
	    (setq tab-width 4)))
(add-hook 'python-mode-hook
	  (lambda ()
	    (setq indent-tabs-mode nil)
	    (setq python-indent 4)
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
(add-to-list 'load-path "~/.emacs.d/snippets")
;;(require 'yasnippet)
;;(yas-global-mode 1)
;; ______________________________________________________________________

;;
;; nodejs-repl-mode
;;
(require 'nodejs-repl)
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
;;(defvar bingtranslate-appId "RzST1D9TBCZ34kYPD2Pm0PmGaSfNojInLLzmXDlsmhk")

;; Your priority language to translate from.
;(defvar bingtranslate-from-priority "en")

;; Your priority language to translate to.
;;(defvar bingtranslate-to-priority "zh-CHT")

;;(require 'bing-translate-api)
;; key bounding
;;(global-set-key [M-f1] 'bingtranslate-region-or-input)

;; add a pair of language
;; Parameters: "pair name" "from language" "to language"
;;(bingtranslate-add-pair "1" "zh-CHT" "en")
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


(load-theme 'monokai t)
;; ______________________________________________________________________


;;
;; w3m
;; ______________________________________________________________________
;;(require 'w3m)
;;(require 'w3m-load)
;;(require 'mime-w3m)
;;(setq w3m-use-cookies t)
;;(setq w3m-default-display-inline-images t)
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
 '(ansi-color-names-vector
   ["#272822" "#F92672" "#A6E22E" "#E6DB74" "#66D9EF" "#FD5FF0" "#A1EFE4" "#F8F8F2"])
 '(compilation-message-face (quote default))
 '(custom-safe-themes
   (quote
    ("183784d00a6fd5029d827512bc66eb28a4c3dac60a6803577c20592f61557dba" "08efabe5a8f3827508634a3ceed33fa06b9daeef9c70a24218b70494acdf7855" "49eea2857afb24808915643b1b5bd093eefb35424c758f502e98a03d0d3df4b1" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "7a00b0710bb2e400d33a925f94b1cd8cfa2281f864ac9506b9046703e0045d66" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "1e7e097ec8cb1f8c3a912d7e1e0331caeed49fef6cff220be63bd2a6ba4cc365" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" "6d1977ebe72065bf27f34974a9e5cb5dc0a7f296804376fad412d981dee7a7e4" "e4e97731f52a5237f37ceb2423cb327778c7d3af7dc831788473d4a76bcc9760" "e587bd7ea49915da4556c1f5b535e920cb3f65f033ae636ba8ed0d2ca2a14df4" default)))
 '(ecb-layout-window-sizes nil)
 '(ecb-options-version "2.40")
 '(fci-rule-color "#49483E")
 '(highlight-changes-colors ("#FD5FF0" "#AE81FF"))
 '(highlight-tail-colors
   (("#49483E" . 0)
    ("#67930F" . 20)
    ("#349B8D" . 30)
    ("#21889B" . 50)
    ("#968B26" . 60)
    ("#A45E0A" . 70)
    ("#A41F99" . 85)
    ("#49483E" . 100)))
 '(magit-diff-use-overlays nil)
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#F92672")
     (40 . "#CF4F1F")
     (60 . "#C26C0F")
     (80 . "#E6DB74")
     (100 . "#AB8C00")
     (120 . "#A18F00")
     (140 . "#989200")
     (160 . "#8E9500")
     (180 . "#A6E22E")
     (200 . "#729A1E")
     (220 . "#609C3C")
     (240 . "#4E9D5B")
     (260 . "#3C9F79")
     (280 . "#A1EFE4")
     (300 . "#299BA6")
     (320 . "#2896B5")
     (340 . "#2790C3")
     (360 . "#66D9EF"))))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   (unspecified "#272822" "#49483E" "#A20C41" "#F92672" "#67930F" "#A6E22E" "#968B26" "#E6DB74" "#21889B" "#66D9EF" "#A41F99" "#FD5FF0" "#349B8D" "#A1EFE4" "#F8F8F2" "#F8F8F0")))
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
;;(add-to-list 'auto-mode-alist '("\\.jade$" . jade-mode))
;; ______________________________________________________________________

;;
;; whitespace
;; ______________________________________________________________________
(require 'whitespace)
(autoload 'whitespace-mode           "whitespace" "Toggle whitespace visualization."        t)
(autoload 'whitespace-toggle-options "whitespace" "Toggle local `whitespace-mode' options." t)
;; ______________________________________________________________________


;;
;; whitespace
;; ______________________________________________________________________
(eval-after-load 'js2-mode
  '(define-key js2-mode-map (kbd "C-c b") 'web-beautify-js))
(eval-after-load 'json-mode
  '(define-key json-mode-map (kbd "C-c b") 'web-beautify-js))
(eval-after-load 'sgml-mode
  '(define-key html-mode-map (kbd "C-c b") 'web-beautify-html))
(eval-after-load 'css-mode
  '(define-key css-mode-map (kbd "C-c b") 'web-beautify-css))

(eval-after-load 'js2-mode
  '(add-hook 'js2-mode-hook
	     (lambda ()
	       (add-hook 'before-save-hook 'web-beautify-js-buffer t t))))

(eval-after-load 'json-mode
  '(add-hook 'json-mode-hook
	     (lambda ()
	       (add-hook 'before-save-hook 'web-beautify-js-buffer t t))))

(eval-after-load 'sgml-mode
  '(add-hook 'html-mode-hook
	     (lambda ()
	       (add-hook 'before-save-hook 'web-beautify-html-buffer t t))))

(eval-after-load 'css-mode
  '(add-hook 'css-mode-hook
	     (lambda ()
	       (add-hook 'before-save-hook 'web-beautify-css-buffer t t))))
;; ______________________________________________________________________
