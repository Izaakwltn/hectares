;;;; search.lisp
;;;;
;;;; Copyright Izaak Walton (c) 2022

(in-package :hectares)

;;; search methods for imslp (brainstorm for now)
;;;
;;; start off, look for a match for a full name (people) or full

(defvar *search-result* nil)

(defun search-people-json (full-name json-objects)
  (flet ((make-work (thread-number)
           (lambda ()
             (loop :for i :from thread-number :to 999 :by *cores*
                   :if (if (> (length (cdadr (nth i json-objects))) 9)
                           (equal (subseq (cdadr (nth i json-objects)) 9)
                                  full-name)
                           nil)
                     :do (setq *search-result* (shelve-person (nth i json-objects)))))))
    (let ((threads nil))
      (dotimes (i *cores*)
        (let ((name (format nil "Searcher #~D" i)))
          (push (bt:make-thread (make-work i) :name name) threads)))
      (dolist (thread threads)
        (bt:join-thread thread)))))
                         

;;; if (subseq (cdadr json-object) 9) == name, good to go
           
(declaim (ftype (function (string) imslp-person) search-people))
(defun search-people (full-name)
  (setq *search-result* nil)
  (flet ((make-work (thread-number)
           (lambda ()
             (loop :for i :upfrom thread-number :by *cores*
                   :if (list-ran-out-p (dex:get (people-url (* i 1000))))
                         :do (return)
                   :else
                     :do (search-people-json full-name
                                             (parse-json-objects
                                              (dex:get (people-url (* i 1000)))))))))
    (let ((threads nil))
      (dotimes (i *cores*)
        (let ((name (format nil "IMSLP gatherer #~D" i)))
          (push (bt:make-thread (make-work i) :name name) threads)))
      (dolist (thread threads)
        (bt:join-thread thread))))
  *search-result*)

;;; it works!

