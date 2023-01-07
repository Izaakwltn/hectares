;;;; works.lisp
;;;;
;;;; Copyright Izaak Walton (c) 2022

(in-package #:hectares)


;;; defining struct for works (using struct over class for speed)

(defstruct work title composer link)

(defmethod print-object ((obj work) stream)
  (print-unreadable-object (obj stream :type t)
    (with-accessors ((title work-title)
                     (composer work-composer)
                     (link work-link))
        obj
      (format stream
              "~a (~a) ~a" title composer link))))

;;; converting jsons to imslp-works

(defun shelve-work (json-object)
  "Converts a json-object into an imslp-work object"
  (let ((data (nth 4 json-object)))
    (make-work :title (cdr (third data))
               :composer (cdr (second data))
               :link (cdr (nth 5 json-object)))))
