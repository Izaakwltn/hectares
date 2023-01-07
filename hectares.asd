;;;; hectares.asd
;;;;
;;;; Copyright Izaak Walton (c) 2022

(asdf:defsystem #:hectares
  :version "0.0.1"
  :author "Izaak Walton <izaakw@protonmail.com>"
  :license "GNU General Purpose License"
  :description "IMSLP API library"
  :depends-on ("dexador" "cl-json" "alexa" "lquery")
  :serial t
  :components ((:module "src"
                :serial t
                :components ((:file "package")
                             (:file "config")
                             (:file "requests")
                             (:file "works")
                             (:file "people")
                             (:file "gathering")
                             (:file "search")
                             (:file "metadata")))))
