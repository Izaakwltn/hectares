;;;; request-parsing.lisp
;;;;
;;;; Copyright Izaak Walton (c) 2022

(in-package #:hectares)

;;; Using IMSLP API as directed at: "https://imslp.org/wiki/IMSLP:API"

(declaim (ftype (function (string) (or t null)) imslp-retformat-p))
(defun imslp-retformat-p (string)
  (check-type string string)
  (member string '("json" "php" "xml" "txt" "dbg" "yaml" "wddx" "dump" "none") :test #'equal))
  
(deftype imslp-retformat ()
  `(satisfies imslp-retformat-p))
;type is 1 for people or 2 for works
(declaim (ftype (function (integer integer imslp-retformat) string) imslp-request-url))
(defun imslp-request-url (type start retformat)
  (concatenate 'string "https://imslp.org/imslpscripts/API.ISCR.php?account=worklist/disclaimer=accepted/sort=id/type="
               (write-to-string type)
               "/start="
               (write-to-string start)
               "/retformat="
               retformat))

;;; generating urls for accessing people and works from a given start-id

;;; both of these will return 1000 items

(defun people-url (start)
  (imslp-request-url 1 start "json"))

(defun works-url (start)
  (imslp-request-url 2 start "json"))

;;;
(defun list-ran-out-p (json-string)
  (equal (subseq json-string 2 10) "metadata"))

;;; parsing jsons for later

(defun parse-json-objects (json-string)
  (remove-if #'(lambda (x)
                 (equal (first x) ':metadata))
             (cl-json:decode-json-from-string json-string)))

(defparameter *cores* 4)

(defvar *all-people* nil)

(defun gather-people ()
  (setq *all-people* nil)
  (flet ((make-work (thread-number)
           (lambda ()
             (loop :for i :upfrom thread-number :by *cores*
                   :if (list-ran-out-p (dex:get (people-url (* i 1000))))
                     :do (return)
                   :else
                     :do (push (mapcar #'shelve-person (parse-json-objects (dex:get (people-url (* i 1000))))) *all-people*)))))
    (let ((threads nil))
      (dotimes (i *cores*)
        (let ((name (format nil "Gatherer #~D" i)))
          (push (bt:make-thread (make-work i) :name name) threads)))
      (dolist (thread threads)
        (bt:join-thread thread))))
  (setq *all-people* (reduce #'append *all-people*))
  *all-people*)

(defvar *all-work-strings* nil)
(defvar *all-works* nil)

;;; optimize by using one process to parse the json objects, then another function to then shelve all of those works
;;;there are just too many
;;;the heap keeps overloading
;;;should I move them to a file of matched pairs?
(defun gather-work-strings ()
  (setq *all-work-strings* nil)
  (flet ((make-work (thread-number)
           (lambda ()
             (loop :for i :upfrom thread-number :by *cores*
                   :if (list-ran-out-p (dex:get (works-url (* i 1000))))
                     :do (return)
                   :else
                     :do (push (dex:get (works-url (* i 1000))) *all-work-strings*)))))
    (let ((threads nil))
      (dotimes (i *cores*)
        (let ((name (format nil "IMSLP gatherer #~D" i)))
          (push (bt:make-thread (make-work i) :name name) threads)))
      (dolist (thread threads)
        (bt:join-thread thread))))
  *all-work-strings*)

;;; eventually optimizing here:

;;;(defun gather-works ()
 ; (setq *all-works* nil)
  ;;(flet ((make-work (thread-number)
    ;       (lambda ()
     ;        (loop :for i :u
  


;;;------------------------------------------------------------------------
;;; old, non-parallel version:

;;; iterating through all people on imslp, returns list of json strings

;(defun all-people-json-strings ()
 ; (loop :with all-folks := nil
  ;      :for i :upfrom 0
   ;     :if (list-ran-out-p (dex:get (people-url (* i 1000))))
    ;      :return all-folks
     ;   :else
      ;    :do (setq all-folks (cons (dex:get (people-url (* i 1000))) all-folks))))

;(defun all-people-json-objects ()
 ; (reduce #'append (mapcar #'parse-json-objects (all-people-json-strings))))

;(defun all-works-json-strings ()
 ; (loop :with all-works := nil
  ;      :for i :upfrom 0
   ;     :if (list-ran-out-p (dex:get (works-url (* i 1000))))
    ;      :return all-works
     ;;   :else
       ;   :do (setq all-works (cons (dex:get (works-url (* i 1000))) all-works))))

;(defun all-works-json-objects ()
 ; (reduce #'append (mapcar #'parse-json-objects (all-works-json-strings))))
