;; -*- lexical-binding: t -*-
(require 'htmlfontify)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("marmalade" . "http://marmalade-repo.org/packages/")))
(message "package archives configured added")

(package-initialize)
(message "packages initialized")

(package-refresh-contents)
(message "packages refreshed")

(setq
 elnode-init-port
 (string-to-number (or (getenv "PORT") "8080")))
(setq elnode-init-host "0.0.0.0")
(setq elnode-do-init nil)
(message "elnode init done")

(package-install 'elnode)
(message "elnode installed")

(setq base-dir default-directory)
(load-file (concat base-dir "esxml/esxml.el"))
(defun handler (httpcon)
  "Demonstration function"
  (elnode-http-start httpcon "200"
                     '("Content-type" . "text/html")
                     `("Server" . ,(concat "GNU Emacs " emacs-version)))
  (elnode-http-return httpcon
    (esxml-demo httpcon)))

(let ((count 0))
  (defun sxml-demo (httpcon)
    (incf count)
    (case (intern (elnode-http-pathinfo httpcon))            
      (/messages (with-current-buffer "*Messages*" (sxml-to-xml `(html (body (pre ,(buffer-string)))))))
      
      (t (sxml-to-xml
          `(html
            (body
             (h1 "Hello from Emacs!") (br)
             "Trying to visit " ,(format "%s" (elnode-http-pathinfo httpcon)) (br)
             "Visit " (a (@ (href "/messages")) "messages") " to see the *Messages* buffer." (br)
             "Have been visited " ,(format "%s" count) " times since last started.")))))))

(elnode-start 'handler :port elnode-init-port :host elnode-init-host)
;;(elnode-init)

(while t
  (accept-process-output nil 1))

;; End
