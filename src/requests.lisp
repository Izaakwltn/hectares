;;;; requests.lisp
;;;;
;;;; Copyright Izaak Walton (c) 2022

(in-package #:hectares)

;;; Using IMSLP API as directed at: "https://imslp.org/wiki/IMSLP:API"

(declaim (ftype (function (string) (or t null)) imslp-retformat-p))
(defun imslp-retformat-p (string)
  "Determines whether a string qualifies as a mediawiki return format."
  (check-type string string)
  (member string '("json" "php" "xml" "txt" "dbg" "yaml" "wddx" "dump" "none") :test #'equal))
  
(deftype imslp-retformat ()
  `(satisfies imslp-retformat-p))

(declaim (ftype (function (integer integer imslp-retformat) string) imslp-request-url))
(defun imslp-request-url (type start retformat)
  "Generates an imslp api url for either type=1 (people) or type=2 (works), a starting point, and a return format."
  (concatenate 'string "https://imslp.org/imslpscripts/API.ISCR.php?account=worklist/disclaimer=accepted/sort=id/type="
               (write-to-string type)
               "/start="
               (write-to-string start)
               "/retformat="
               retformat))

;;; generating urls for accessing people and works from a given start-id

;;; both of these will return 1000 items from the starting point

;;; defaulting to json but I may add optional retformat later

(declaim (ftype (function (integer) string) people-url))
(defun people-url (start)
  "Generates a url for people from a given start-id."
  (imslp-request-url 1 start "json"))

(declaim (ftype (function (integer) string) people-url))
(defun works-url (start)
  "Generates a url for works from a given start-id."
  (imslp-request-url 2 start "json"))

;;; Check whether another request should be made past the <=1000 you've gathered

(defun list-ran-out-p (json-string)
  "Returns t if there are no people or works in a given request."
  (equal (subseq json-string 2 10) "metadata"))

;;; parsing jsons for later

(defun parse-json-objects (json-string)
  "Takes a json string and returns a list of :cl-json objects"
  (remove-if #'(lambda (x)
                 (equal (first x) ':metadata))
             (cl-json:decode-json-from-string json-string)))
