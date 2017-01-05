;;; letcheck-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (or (file-name-directory #$) (car load-path)))

;;;### (autoloads nil "letcheck" "letcheck.el" (22319 1680 0 0))
;;; Generated autoloads from letcheck.el

(autoload 'letcheck-mode "letcheck" "\
Toggle checking of let assignments.
If point is inside a let form, the variables in this let block
are checked and if previously defined variable in this let
binding is referenced, it is highlighted with warning face.  This
is because it is not possible to reference local variables in let
form in Emacs LISP.  This will guide the user to spot this kind
of error and advice her to change the let into let*.

\(fn &optional ARG)" t nil)

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; letcheck-autoloads.el ends here
