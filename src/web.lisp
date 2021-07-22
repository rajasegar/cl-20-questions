(in-package :cl-user)
(defpackage cl-20-questions.web
  (:use :cl
        :caveman2
        :cl-20-questions.config
        :cl-20-questions.view
        :cl-20-questions.db
        :datafly
        :sxql)
  (:export :*web*))
(in-package :cl-20-questions.web)

;; for @route annotation
(syntax:use-syntax :annot)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(clear-routing-rules *web*)

(defstruct node contents yes no)

(defvar *nodes* '((:node "people" :question "Is the person a man?" :yes "male" :no "female")
                  (:node "male" :question "Is he living?" :yes "liveman" :no "deadman")
                  (:node "deadman" :question "Was he American?" :yes "us" :no "them")
                  (:node "us" :question "Is he on a coin?" :yes "coin" :no "cidence")
                  (:node "coin" :question "Is the coin a penny?" :yes "penny" :no "coins")
                  (:node "penny" :question "Lincoln")
                  (:node "bird" :question "Is it a bird?" :yes "peacock" :no "mammal")
                  (:node "peacock" :question "Peacock")
                  (:node "mammal" :question "Is it a mammal?" :yes "common-pet" :no "eat-meat")
                  (:node "eat-meat" :question "Does it eat meat?" :yes "large-groups" :no "nil")
                  ))

;; Utils
(defun find-node (id)
  "find node from nodes"
  (car (remove-if #'(lambda (item)
		 (if (string= (getf item :node)  id)
		     nil
		     t)) *nodes*)))

;;
;; Routing rules

(defroute "/" ()
  (let ((n (find-node "people")))
  (render #P"index.html" (list :node n))))

(defroute "/next" (&key _parsed)
  (let ((n (find-node (cdr (assoc "node" _parsed :test #'string=)))))
    (print _parsed)
    (if n
        (render #P"_question.html" (list :node n))
        (render #P"_sorry.html"))))


;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
