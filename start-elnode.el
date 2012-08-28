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
(package-install 'esxml)
(message "esxml installed")
(require 'esxml)

(let ((count 1))
  (defun default-page (httpcon)
    "Demonstration function"
    (let ((path (elnode-http-pathinfo httpcon)))
      (setq count (1+ count))
      (elnode-http-start httpcon "200"
                         '("Content-type" . "text/html")
                         `("Server" . ,(concat "GNU Emacs " emacs-version)))
      (elnode-http-return httpcon
        (sxml-to-xml `(html
                       (body
                        (h1 "Hello from EEEMACS.")
                        (br) "We have been visited " ,(prin1-to-string count) " times"
                        (br) "We are visiting, " ,path "."
                        (br) "Click " (a (@ (href "/messages")) "here") " for the log.")))))))

(defun log-page (httpcon)
(elnode-http-start httpcon "200"
                         '("Content-type" . "text/html")
                         `("Server" . ,(concat "GNU Emacs " emacs-version)))
      (elnode-http-return httpcon
        (sxml-to-xml `(html
                       (body
                        (pre
                         ,(with-current-buffer "*Messages*"
                            (buffer-substring-no-properties (point-min)
                                                            (point-max)))))))))

(defun my-server (httpcon)
  (elnode-dispatcher
   httpcon
   '((\"^/messages/$\" . #'log-page))
   #'default-page))

(elnode-start 'my-server :port elnode-init-port :host elnode-init-host)
;;(elnode-init)

(while t
  (accept-process-output nil 1))

;; End
