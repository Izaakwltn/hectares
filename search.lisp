;;;; search.lisp
;;;;
;;;; Copyright Izaak Walton (c) 2022

(in-package :hectares)

;;; search methods for imslp (brainstorm for now)
;;;
;;; start off, look for a match for a full name (people) or full

;(defvar *search-result* nil)

;(defun search-people-json (full-name json-objects)
 ; "Searches a list of people json-objects for a given full-name string"
  ;(flet ((make-work (thread-number)
   ;        (lambda ()
    ;         (loop :for i :from thread-number :to 999 :by *cores*
     ;              :if (if (> (length (cdadr (nth i json-objects))) 9)
      ;                     (equal (subseq (cdadr (nth i json-objects)) 9)
       ;                           full-name)
         ;                  nil)
        ;             :do (setq *search-result* (shelve-person (nth i json-objects)))))))
   ; (let ((threads nil))
    ;  (dotimes (i *cores*)
     ;   (let ((name (format nil "Searcher #~D" i)))
      ;    (push (bt:make-thread (make-work i) :name name) threads)))
     ; (dolist (thread threads)
      ;  (bt:join-thread thread)))))
       ;                  

;;; if (subseq (cdadr json-object) 9) == name, good to go
           
;(declaim (ftype (function (string) imslp-person) search-people))
;(defun search-people (full-name)
 ; "Searches all people on imslp for a given full-name string (until that person has been found)"
  ;(setq *search-result* nil)
 ; (flet ((make-work (thread-number)
  ;         (lambda ()
   ;          (loop :for i :upfrom thread-number :by *cores*
       ;            :if (list-ran-out-p (dex:get (people-url (* i 1000))))
    ;                     :do (return)
     ;              :else
      ;               :do (search-people-json full-name
        ;                                     (parse-json-objects
         ;                                     (dex:get (people-url (* i 1000)))))))))
;    (let ((threads nil))
 ;     (dotimes (i *cores*)
  ;      (let ((name (format nil "IMSLP gatherer #~D" i)))
   ;       (push (bt:make-thread (make-work i) :name name) threads)))
    ;  (dolist (thread threads)
     ;   (bt:join-thread thread))))
 ; *search-result*)

;;; it works!

(alexa:define-string-lexer name-lexer
  ()
  ("[A-zÀ-ú][A-zÀ-ú]*" (return $@))
  ("[0-9][0-9]*" (return $@))
  (" " nil)
  ("," nil)
  ("-" nil)
  ("'" nil)  
  ("."))


(defun lex-name (name-string)
  "Breaks a name into its individual words"
  (loop :with lexer := (name-lexer name-string)
        :for tok := (funcall lexer)
        :while tok
        :collect tok))

(lex-name "Bach, Johann Sebastian")

(defun compare-lexed-names-inclusive (name1 name2)
  "Compares two lexed names for common words. Returns the number of common words."
  (loop :with common-word-count := 0
        :for i :in name1
        :if (member i name2 :test #'string-equal)
          :do (setq common-word-count (1+ common-word-count))
        :finally (return common-word-count)))

(defun compare-lexed-names-exclusive (name1 name2)
  (loop :for i :in name1
        :if (not (member i name2 :test #'string-equal))
          :do (return 0)
        :finally (return 1)))

(defun compare-string-names (name1 name2)
  "Compares two names/queries for common words. Returns the number of common words."
  (compare-lexed-names-exclusive (lex-name name1) (lex-name name2)))

;;; searching

(defvar *search-result* nil)

;;; probably change name-string to search-string
;;; likewise with lexer, change to search-lexer and return query?


;;;
;;; CHANGE DEFAULT SEARCHES TO BE FULL KEYWORD EXCLUSIVE-
;;; "bach" returns a bunch of bachs, "johann bach" returns a bunch of johann bachs, etc
;;;
(defun search-people-json (name-string json-objects)
  "Searches a list of people json-objects for a given search string"
  (flet ((make-work (thread-number)
           (lambda ()
             (loop :for i :from thread-number :to 999 :by *cores*
                   :if (and (> (length (cdadr (nth i json-objects))) 9)
                            (> (compare-string-names (subseq (cdadr (nth i json-objects)) 9)
                                                        name-string)
                               0))
                               :do (setq *search-result* (cons (shelve-person (nth i json-objects))
                                                           *search-result*))))))
    (let ((threads nil))
      (dotimes (i *cores*)
        (let ((name (format nil "Searcher #~D" i)))
          (push (bt:make-thread (make-work i) :name name) threads)))
      (dolist (thread threads)
        (bt:join-thread thread)))))


(declaim (ftype (function (string) list) search-people))
(defun search-people (name-string)
  "Searches all people on imslp for a given name string (until that person has been found)"
  (setq *search-result* nil)
  (flet ((make-work (thread-number)
           (lambda ()
             (loop :for i :upfrom thread-number :by *cores*
                   :if (list-ran-out-p (dex:get (people-url (* i 1000))))
                         :do (return)
                   :else
                     :do (search-people-json name-string
                                             (parse-json-objects
                                              (dex:get (people-url (* i 1000)))))))))
    (let ((threads nil))
      (dotimes (i *cores*)
        (let ((name (format nil "IMSLP gatherer #~D" i)))
          (push (bt:make-thread (make-work i) :name name) threads)))
      (dolist (thread threads)
        (bt:join-thread thread))))
  *search-result*)


;;; Searching for works

(defun search-works-json (search-string json-object-list)
  "Searches a list of work json-objects for a given search string"
  (flet ((make-work (thread-number)
           (lambda ()
             (loop :for i :from thread-number :to 999 :by *cores*
                   :if (let ((work-data (nth 4 (nth i json-object-list))))
                         (> (compare-string-names search-string (concatenate 'string (cdr (third work-data))
                                                               " "
                                                               (cdr (second work-data))))
                               0))
                               :do (setq *search-result* (cons (shelve-work (nth i json-object-list))
                                                           *search-result*))))))
    (let ((threads nil))
      (dotimes (i *cores*)
        (let ((name (format nil "Searcher #~D" i)))
          (push (bt:make-thread (make-work i) :name name) threads)))
      (dolist (thread threads)
        (bt:join-thread thread)))))

(defun search-works (search-string)
  "Searches all people on imslp for a given name string (until that person has been found)"
  (setq *search-result* nil)
  (flet ((make-work (thread-number)
           (lambda ()
             (loop :for i :upfrom thread-number :by *cores*
                   :if (list-ran-out-p (dex:get (works-url (* i 1000))))
                         :do (return)
                   :else
                     :do (search-works-json search-string
                                             (parse-json-objects
                                              (dex:get (works-url (* i 1000)))))))))
    (let ((threads nil))
      (dotimes (i *cores*)
        (let ((name (format nil "IMSLP gatherer #~D" i)))
          (push (bt:make-thread (make-work i) :name name) threads)))
      (dolist (thread threads)
        (bt:join-thread thread))))
  *search-result*)

;;; make separate search parameters for exclusivity, like violin concerto should only return violin concertos
;;; actually change
