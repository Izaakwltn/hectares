;;;; metadata.lisp
;;;;
;;;; Copyright Izaak Walton (c) 2022

(in-package :hectares)

;;; Gathering metadata for a given work or person

(defun collect-html (link)
  (dex:get link))
                 
(defstruct metaperson name dates link) 
;;; later add wikipedia link, number of compositions, other stuff? idk

(defmethod print-object ((obj metaperson) stream)
  (print-unreadable-object (obj stream :type t)
    (with-accessors ((name metaperson-name)
                     (dates metaperson-dates)
                    ; (wiki metaperson-wiki)
                     (link metaperson-link))
        obj
      (format stream "~a | ~a | ~a" name dates link))))

(defun parse-dates (name-date-string)
  (if (string-equal (subseq name-date-string 0 1) "(")
      name-date-string
      (parse-dates (subseq name-date-string 1))))
             
(defun dates (person-link)
  (let ((parsed-content (lquery:$ (initialize (collect-html person-link)))))
    (parse-dates (vector-pop (lquery:$ parsed-content "div .cp_firsth" (text))))))

;;; I need to find a way to handle pages that have been deleted, like:
;;; https://imslp.org/wiki/Category:Johann,_Bach

;(defun page-deleted-p (link)
 ; (let ((parsed-content (lquery:$ (initialize (collect-html link)))))
  ;  (lquery:$ parsed-content "div .mw-warning-with-logexcerpt")))

(defmethod metadata ((person person))
  (make-metaperson :name (person-name person)
                :dates (dates (person-link person))
                :link (person-link person)))

