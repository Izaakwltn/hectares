;;;; works.lisp
;;;;
;;;; Copyright Izaak Walton (c) 2022

(in-package #:hectares)


;;; defining class for imslp works

(defclass imslp-work ()
  ((title :accessor title
          :initarg :title)
   (composer :accessor composer
             :initarg :composer)
   (link     :accessor link
             :initarg :link)))

(defmethod print-object ((obj imslp-work) stream)
  (print-unreadable-object (obj stream :type t)
    (with-accessors ((title title)
                     (composer composer)
                     (link link))
        obj
      (format stream
              "~a (~a) ~a" title composer link))))

(defun make-imslp-work (title composer link) ; you'd like that wouldn't you
  (make-instance 'imslp-work :title title
                             :composer composer
                             :link link))

;;; converting jsons to imslp-works

(defun shelve-work (json-object)
  "Converts a json-object into an imslp-work object"
  (let ((data (nth 4 json-object)))
    (make-imslp-work (cdr (third data))
                     (cdr (second data))
                     (cdr (nth 5 json-object)))))

(defun all-works ()
  "Returns a list of all works on imslp as imslp-work objects"
  (mapcar #'shelve-work (all-works-json-objects)))
