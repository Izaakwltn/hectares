;;;; hectares.asd
;;;;
;;;; Copyright Izaak Walton (c) 2022

(asdf:defsystem #:hectares
  :version "0.0.1"
  :author "Izaak Walton <izaakw@protonmail.com>"
  :license "GNU General Purpose License"
  :description "IMSLP API library"
  :depends-on ("dexador" "cl-json")
  :serial t
  :components ((:file "package")
               (:file "request-parsing")
               (:file "works")
               (:file "people")))