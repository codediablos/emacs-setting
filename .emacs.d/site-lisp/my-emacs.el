
(defun beauty-code ()
  "beauty your code"
  (interactive)
  (mark-whole-buffer)
  (tabify)
  (delete-trailing-whitespace))


(defun reload-dotemacs-file ()
  "reload your .emacs file without restarting Emacs"
  (interactive)
  (load-file "~/.emacs") )


(provide 'my-emacs)
