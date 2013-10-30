(defvar myposition nil)
;;(setq pos_cnt 0)
;;(setq pos_list '(0))
;;(defvar pos_list nil)
(defvar pos_list (make-ring 100))

(defadvice previous-line (before save-position (&optional n try-vscroll))
;;  (setq myposition (point)))
;;  (setq pos_list (append (list (point)) pos_list)))
  (ring-insert-at-beginning pos_list (point)))
(ad-activate 'previous-line)

(defun back ()
  (interactive)
;;  (setq myposition (pop pos_list))
;;  (message "Position is: %d" (myposition))
;;  (goto-char myposition))
;;  (goto-char (pop pos_list)))
  (goto-char (ring-remove  pos_list)))
;;  (setq myposition (pop pos_list))
;;  (when myposition
;;    (goto-char myposition)))

(defun get_pos_list()
  (interactive)
  (message "list is: %S" pos_list))

(provide 'prepos)