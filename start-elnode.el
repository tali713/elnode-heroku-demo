;; -*- lexical-binding: t -*-
(require 'htmlfontify)
(load "~/esxml/esxml.el")
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

(let ((count 1))
  (defun handler (httpcon)
    "Demonstration function"
    (setq count (1+ count))
    (elnode-http-start httpcon "200"
                       '("Content-type" . "text/html")
                       `("Server" . ,(concat "GNU Emacs " emacs-version)))
    (elnode-http-return httpcon
      (sxml-to-xml `(html
                     (body
                      (h1 "Hello from EEEMACS.")
                      (br) "We have been visited " ,(prin1-to-string count) " times"
                      (br) "Click " (a (@ (href "/messages")) "here") " for the log."))))))

(elnode-start 'handler :port elnode-init-port :host elnode-init-host)
;;(elnode-init)

(while t
  (accept-process-output nil 1))

;; End
