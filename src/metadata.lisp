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

;;;
;;; Metadata for works
;;;

(defstruct metawork title composer link origin first-publication movements instrumentation other-data)

                                        ; eventually add first publication, instrumentation

(defmethod print-object ((obj metawork) stream)
  (print-unreadable-object (obj stream :type t)
    (with-accessors ((title metawork-title)
                     (composer metawork-composer)
                     (link metawork-link)
                     (origin metawork-origin)
                     (first-publication metawork-first-publication)
                     (movements metawork-movements)
                     (instrumentation metawork-instrumentation)
                     (data metawork-other-data))
        obj
      (format stream "~%~a~%~a~%~a~%~%Year/Location: ~a~%First Publication: ~a~%~a~%Instrumentation: ~a" title composer link origin first-publication movements instrumentation))))

;;; Gather work data from the General information section at the bottom of the page
;;; collect into key-pairs that can be searched using #'match-meta

(defgeneric data-list (object)
  (:documentation "Collects data on an imslp object in matched pairs"))

(defmethod data-list ((work work))
  (let ((parsed-content (lquery:$ (initialize (collect-html (work-link work))))))
    (loop :with a := (lquery:$ parsed-content "div .wi_body th" (text))
          :with b := (lquery:$ parsed-content "div .wi_body td" (text))
          :for i :from 0 :to (- (length a) 1)
          :collect (list (aref a i) (aref b i)))))

(defun match-meta (first-three pair-list)
  (second (find-if #'(lambda (x)
                       (string-equal (subseq (first x) 0 3)
                                     first-three))
                   pair-list)))

(defmethod metadata ((work work))
  (let ((data (data-list work)))
    (make-metawork :title (work-title work)
                   :composer (work-composer work)
                   :link (work-link work)
                   :instrumentation (match-meta "Ins" data)
                   :movements (match-meta "Mov" data)
                   :origin (match-meta "Yea" data)
                   :first-publication (match-meta "Fir" data)
                   :other-data nil)))
