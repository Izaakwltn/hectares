;;;; config.lisp
;;;;
;;;; Copyright Izaak Walton (c) 2022

(in-package :hectares)

;;; For now just configure with your number of cores for multithreading:

(defparameter *cores* 4) 

(defun set-cores (number-of-cores)
  (setq *cores* number-of-cores))
