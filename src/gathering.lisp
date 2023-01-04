;;;; gathering.lisp
;;;;
;;;; Copyright Izaak Walton (c) 2022

(in-package :hectares)

;;; Functions for gathering all people or objects

(defvar *all-people* nil)

(defun gather-people ()
  "Gathers all people on imslp into the variable *all-people*, returns *all-people*"
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

;;; Gathering all works (may be unrealistic with current memory


(defvar *all-work-strings* nil)
(defvar *all-works* nil)

(defun gather-works ()   ; ridiculously slow
  (setq *all-work-strings* nil)
  (flet ((make-work (thread-number)
           (lambda ()
             (loop :for i :upfrom thread-number :by *cores*
                   :if (list-ran-out-p (dex:get (works-url (* i 1000))))
                     :do (return)
                   :else
                     :do (push (mapcar #'shelve-work (parse-json-objects (dex:get (works-url (* i 1000))))) *all-works*)))))
    (let ((threads nil))
      (dotimes (i *cores*)
        (let ((name (format nil "IMSLP gatherer #~D" i)))
          (push (bt:make-thread (make-work i) :name name) threads)))
      (dolist (thread threads)
        (bt:join-thread thread))))
  *all-work-strings*)
