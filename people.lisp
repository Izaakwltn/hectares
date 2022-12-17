;;;; people.lisp
;;;;
;;;; Copyright Izaak Walton (c) 2022

(in-package #:hectares)

;;; defining class for imslp persons

(defclass imslp-person () ; later break into first name and last name
  ((name :accessor name
         :initarg :name)
   (link :accessor link
         :initarg :link)))

(defmethod print-object ((obj imslp-person) stream)
  (print-unreadable-object (obj stream :type t)
    (with-accessors ((name name)
                     (link link))
        obj
      (format stream "~a, ~a" name link))))

(defun make-imslp-person (name link)
  (make-instance 'imslp-person :name name
                               :link link))

;;; potentially useful later, but for now, unused
(defun parse-first-last (name-string)
  "Parses a 'last, first' name string into a (first last) list"
  (loop :with name-pair := nil
        :with current-name := ""

        :for i :from 1 :to (length name-string)
        :if (equal (subseq name-string (1- i) i) ",")
          :do (progn (setq name-pair (cons current-name name-pair))
                     (setq current-name ""))
        :else :do (setq current-name (concatenate 'string
                                                  current-name
                                                  (subseq name-string (1- i) i)))
        :finally (return (cons (subseq current-name 1) name-pair))))

;;; this parsing approach is flawed for one named or band names- without a comma
;(defun shelve-person (json-object)
;  (let ((nom (parse-first-last (subseq (cdadr json-object) 9))))
;    (make-imslp-person (first nom)
;                       (second nom)
;                       (cdr (nth 5 json-object)))))

(defun shelve-person (json-object)
  (make-imslp-person (subseq (cdadr json-object) 9)
                     (cdr (nth 5 json-object))))

(defun all-people ()
  (mapcar #'shelve-person (all-people-json-objects)))
