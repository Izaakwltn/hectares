;;;; metadata.lisp
;;;;
;;;; Copyright Izaak Walton (c) 2022

(in-package :hectares)

;;; Gathering metadata for a given work or person

(defun collect-html (link)
  (dex:get link))
                 
(defstruct metaperson name dates link other-data) 
;;; later add wikipedia link, number of compositions, other stuff

(defmethod print-object ((obj metaperson) stream)
  (print-unreadable-object (obj stream :type t)
    (with-accessors ((name metaperson-name)
                     (dates metaperson-dates)
                    ; (wiki metaperson-wiki)
                     (link metaperson-link))
        obj
      (format stream "~%~%~a~%~a~%~a" name dates link))))

(defun parse-dates (name-date-string)
  (if (string-equal (subseq name-date-string 0 1) "(")
      name-date-string
      (parse-dates (subseq name-date-string 1))))
             
(defmethod dates ((person person))
  (let ((parsed-content (lquery:$ (initialize (collect-html (person-link person))))))
    (parse-dates (vector-pop (lquery:$ parsed-content "div .cp_firsth" (text))))))

(defgeneric other-data (object)
  (:documentation "Returns assorted other data from the object page"))

(defmethod other-data ((person person)) ;Later parse out specifics
  (let ((parsed-content (lquery:$ (initialize (collect-html (person-link person))))))
    (lquery:$ parsed-content "span" (text))))


;;; I need to find a way to handle pages that have been deleted, like:
;;; https://imslp.org/wiki/Category:Johann,_Bach

;(defun page-deleted-p (link)
 ; (let ((parsed-content (lquery:$ (initialize (collect-html link)))))
  ;  (lquery:$ parsed-content "div .mw-warning-with-logexcerpt")))

(defgeneric metadata (object)
  (:documentation "Returns a meta(data) version of the object"))

(defmethod metadata ((person person))
  (make-metaperson :name (person-name person)
                   :dates (dates person)
                   :link (person-link person)
                   :other-data (other-data person)))

;;; Metadata for works

(defstruct metawork title composer link origin movements other-data)

(defmethod print-object ((obj metawork) stream)
  (print-unreadable-object (obj stream :type t)
    (with-accessors ((title metawork-title)
                     (composer metawork-composer)
                     (link metawork-link)
                     (origin metawork-origin)
                     (movements metawork-movements)
                     (data metawork-other-data))
        obj
      (format stream "~%~a~%~a~%~a~%~%~a~%~a~%" title composer link origin movements))))

(defmethod metadata ((work work))
  (let ((parsed-content (lquery:$ (initialize (collect-html (work-link work))))))
    (let ((data (lquery:$ parsed-content "div .wp_header td" (text))))
  (make-metawork :title (work-title work)
                 :composer (work-composer work)
                 :link (work-link work)
                 :movements (aref data 0)
                 :origin (aref data 1) ;; add date function for finding the date of a piece
                 :other-data nil)))) ;; make an other-data method for works
  
;(defun works-list (person)
  
