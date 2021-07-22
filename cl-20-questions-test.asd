(defsystem "cl-20-questions-test"
  :defsystem-depends-on ("prove-asdf")
  :author "Rajasegar Chandran"
  :license ""
  :depends-on ("cl-20-questions"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "cl-20-questions"))))
  :description "Test system for cl-20-questions"
  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
