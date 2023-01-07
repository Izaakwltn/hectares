;;;; people.lisp
;;;;
;;;; Copyright Izaak Walton (c) 2022

(in-package #:hectares)

;;; defining struct for people

(defstruct person name link) ; struct is much faster than class

(defmethod print-object ((obj person) stream)
  (print-unreadable-object (obj stream :type t)
    obj
    (format stream "~a, ~a" (person-name obj) (person-link obj))))


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

;;; ^^^ this parsing approach is flawed for one named or band names- without a comma

                                        
(defun shelve-person (json-object)
  (make-person :name (subseq (cdadr json-object) 9)
               :link (cdr (nth 5 json-object))))
