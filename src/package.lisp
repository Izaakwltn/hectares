;;;; package.lisp
;;;;
;;;; Copyright Izaak Walton (c) 2022

(defpackage #:hectares
  (:documentation "imslp-api tools")
  (:use #:cl)

  ;;; config.lisp
  (:export #:set-cores)

  ;;; requests.lisp
  (:export #:imslp-retformat
           #:imslp-request-url
           #:people-url
           #:works-url
           #:parse-json-objects)

  ;;; works.lisp
  (:export #:work
           #:shelve-work)

  ;;; people.lisp
  (:export #:person
           #:shelve-person)

  ;;; gathering.lisp
  (:export #:*all-people* ; unecessary? check later
           #:gather-people
           #:*all-works*
           #:gather-works)

  ;;; search.lisp
  (:export #:*search-result*
           #:search-people
           #:search-works)


  ;;; metadata.lisp
  (:export #:metaperson
           #:dates
           #:other-data
           #:metadata
           #:metawork))
