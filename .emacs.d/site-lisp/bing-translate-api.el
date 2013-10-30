;;; bing-translate-api.el --- Use bing translate api to perform translations

;; Copyright (C) 2012 zxy
;; Author: zxy <gcoordinate@gmail.com>
;; Maintainer: zxy <gcoordinate@gmail.com>
;; Created: May 2012
;; Version: 0.2

;; This file is NOT part of Emacs.
;;
;; GNU Emacs is free software: you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free
;; Software Foundation, either version 3 of the License, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
;; FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
;; more details.

;; You should have received a copy of the GNU General Public License along
;; with GNU Emacs. If not, see <http://www.gnu.org/licenses/>.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Installation
;; ============
;;
;; (add-to-list 'load-path (concat git-path "translate-emacs-toolkit"))
;;
;; ;; Your appId. Application at http://www.bing.com/toolbox/bingdeveloper/
;; (defvar bingtranslate-appId "your-appId")
;;
;; ;; Your priority language to translate from.
;; (defvar bingtranslate-from-priority "en")
;;
;; ;; Your priority language to translate to.
;; (defvar bingtranslate-to-priority "zh-CHS")
;;
;; (require 'bing-translate-api)
;; (global-set-key [M-f1] 'bingtranslate-region-or-input)
;;
;; ;; add a pair of language
;; ;; Parameters: "pair name" "from language" "to language"
;; (bingtranslate-add-pair "1" "zh-CHS" "en")
;;

(require 'url)
(message (concat "Loading " load-file-name))

;; public var

(defcustom bingtranslate-service "http://api.microsofttranslator.com/V2/Ajax.svc/Translate?"
  "Service to use for translation."
  :group 'bingtranslate
  :type 'string)

(defcustom bingtranslate-appId ""
  "Service to use for translation."
  :group 'bingtranslate
  :type 'string)

(defcustom bingtranslate-from-priority "en"
  "Priority from language."
  :group 'bingtranslate
  :type 'string)

(defcustom bingtranslate-to-priority "zh-CHS"
  "Priority to language."
  :group 'bingtranslate
  :type 'string)

;; private var

(defvar bingtranslate-language-list
  '("en"
    "zh-CHS"
    "zh-CHT"
    ;; http://www.emreakkas.com/internationalization/microsoft-translator-api-languages-list-language-codes-and-names
    "ar"
    "cs"
    "da"
    "de"
    ;; "en"
    ;; "et"
    ;; "fi"
    ;; "fr"
    ;; "nl"
    ;; "el"
    ;; "he"
    ;; "ht"
    ;; "hu"
    ;; "id"
    ;; "it"
    ;; "ja"
    ;; "ko"
    ;; "lt"
    ;; "lv"
    ;; "no"
    ;; "pl"
    ;; "pt"
    ;; "ro"
    ;; "es"
    ;; "ru"
    ;; "sk"
    ;; "sl"
    ;; "sv"
    ;; "th"
    ;; "tr"
    ;; "uk"
    ;; "vi"
    ;; "zh-CHS"
    ;; "zh-CHT"
    ))

(defvar bingtranslate-language-pair (make-hash-table :test 'equal))

(defvar bingtranslate-history-hash (make-hash-table :test 'equal))

(defvar bingtranslate-history-text "")

(defvar bingtranslate-history-from "")

(defvar bingtranslate-history-to "")

;; defun

(defun bingtranslate-make-url (text from to)
  "Generate the url to send to the translation service."
  (concat bingtranslate-service
          "appId=" bingtranslate-appId
          "&from=" from
          "&to=" to
          "&text=" (url-hexify-string text)))

(defun bingtranslate-url-callback (status)
  "Switch to the buffer returned by `url-retreive'."
  ;; (switch-to-buffer (current-buffer))
  (goto-char (point-min))
  (if (search-forward-regexp "^$" nil t)
      ;; (if (search-forward-regexp "\"" nil t)
      (setq header (buffer-substring (point-min) (point))
            data (buffer-substring (1+ (point)) (point-max)))
    ;; unexpected situation, return the whole buffer
    (setq data (buffer-string)))
  ;; (message (encode-coding-string (buffer-string) 'utf-8))
  ;; (setq result (decode-coding-string (buffer-string) 'utf-8))
  (setq result (decode-coding-string data 'utf-8))
  (setq result (substring result 2 (- (length result) 1)))
  (kill-new result)
  (kill-buffer (current-buffer))
  (puthash (concat bingtranslate-history-text " from "
                   bingtranslate-history-from " to "
                   bingtranslate-history-to) result bingtranslate-history-hash)
  (message result))

(defun bingtranslate-region-or-input ()
  "Translate region or input"
  (interactive)
  ;; if marked
  (if (and mark-active
           (/= (point) (mark)))
      (setq bingtranslate-history-text (buffer-substring (point) (mark)))
    ;; read text from mini buffer
    (progn
      (if (equal nil (current-word))
          (setq defaultext bingtranslate-history-text)
        (setq defaultext (current-word)))
      (setq bingtranslate-history-text (read-string (format "[bingtranslate] text (default %s): " defaultext)
                                                    nil nil defaultext nil))))
  ;; read other infor
  (setq tmptype (completing-read (format "[bingtranslate] language pair name or from language (default %s): " bingtranslate-from-priority) 
                                 bingtranslate-language-list
                                 nil t nil nil bingtranslate-from-priority))
  ;; get pair
  (setq pair (gethash tmptype bingtranslate-language-pair))
  (if (and (not (equal "" pair))
           (not (equal nil pair)))
      (progn
        (setq bingtranslate-history-from (car pair))
        (setq bingtranslate-history-to (car (cdr pair))))
    (progn
      (setq bingtranslate-history-from tmptype)
      (setq bingtranslate-history-to (completing-read (format "[bingtranslate] to language (default %s): " bingtranslate-to-priority) 
                                                      bingtranslate-language-list
                                                      nil t nil nil bingtranslate-to-priority))
      ))
  (setq result (gethash (concat bingtranslate-history-text " from "
                                bingtranslate-history-from " to "
                                bingtranslate-history-to) bingtranslate-history-hash))
  (if (and (not (equal "" result))
           (not (equal nil result)))
      (message result)
    (url-retrieve (bingtranslate-make-url bingtranslate-history-text
                                          bingtranslate-history-from
                                          bingtranslate-history-to) 'bingtranslate-url-callback)
    ))

(defun bingtranslate-show-history ()
  "Show translate history"
  (interactive)
  (with-output-to-temp-buffer "*translate-temp*"
    (print "<Temp buffer show translate history. Type 'q' to close.>")
    (print "--------------------------------------------------------")
    (loop for k being the hash-key of bingtranslate-history-hash do
          (print k)
          (print (gethash k bingtranslate-history-hash))
          (print "--------------------------------------------------------"))
    (switch-to-buffer "*translate-temp*")
    ))

(defun bingtranslate-add-pair (key from to)
  "Add a pair of language for translate."
  (interactive)
  (setq result (gethash key bingtranslate-language-pair))
  (if (or (member key bingtranslate-language-list)
          (and (not (equal "" result))
               (not (equal nil result))))
      (message (format "[bingtranslate] Language pair named %s exist!" key))
    (progn
      (setq bingtranslate-language-list (cons key bingtranslate-language-list))
      (puthash key (list from to) bingtranslate-language-pair))
    ))

(provide 'bing-translate-api)

;;; bing-translate-api.el ends here
