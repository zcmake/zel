;;; -*- lexical-binding: t -*-

(require 'zel)

(defconst zel--tests-passed 0)
(defconst zel--tests-failed 0)
(defconst zel--tests ())

(defmacro zel--define-test (name &rest body)
  (declare (indent 1))
  `(zel--add zel--tests (list ',name (lambda () ,@body))))

(defmacro zel--test (x msg)
  `(if (not ,x)
       (progn (incf zel--tests-failed)
              (throw 'zel--test-result ,msg))
     (incf zel--tests-passed)))

(defmacro zel--test= (a b)
  `(zel--test (equal ,a ,b)
              (format "failed:\n  (zel--test= %S %S)\n  expected %S, was %S"
                      ',a ',b ,a ,b)))

(defun zel-run-tests ()
  (setq-local lexical-binding t)
  (setq zel--tests-passed 0)
  (setq zel--tests-failed 0)
  (zel--each (name f) zel--tests
    (let ((result (catch 'zel--test-result (funcall f))))
      (if (stringp result)
          (princ (zel--cat " " name " " result "\n")))))
  (princ (zel--cat " " zel--tests-passed " passed, " zel--tests-failed " failed\n")))

(zel--define-test test=
  (zel--test= t t)
  (zel--test= t (not nil)))

(zel--define-test zel--str
  (zel--test= "a" (zel--str 'a))
  (zel--test= "\"a\"" (zel--str "a"))
  (zel--test= "(a b)" (zel--str '(a b))))

(zel--define-test zel--stringify
  (zel--test= "a" (zel--stringify 'a))
  (zel--test= "a" (zel--stringify "a"))
  (zel--test= "(a b)" (zel--stringify '(a b)))
  (zel--test= "(\"a\" \"b\")" (zel--stringify '("a" "b"))))

(zel--define-test zel--cat
  (zel--test= "a" (zel--cat 'a))
  (zel--test= "ab" (zel--cat 'a "b"))
  (zel--test= "(a b)" (zel--cat '(a b))))

(zel--define-test zel--unique
  (let ((a (zel--unique 'x))
        (b (zel--unique 'x)))
    (zel--test= nil (eq a b))))

(zel--define-test zel--dbind
  (zel--dbind (a b) '(1 2)
    (zel--test= a 1)
    (zel--test= b 2))
  (zel--dbind (x . y) '(1 . 2)
    (zel--test= x 1)
    (zel--test= y 2)))

(zel--define-test zel--let
  (zel--let a 1
    (zel--test= 1 a))
  (let ((b 1))
    (zel--test= 1 b)
    (zel--let b 2
      (zel--test= 2 b)))
  (zel--let (x y) '(1 2)
    (zel--test= 1 x)
    (zel--test= 2 y)))

(zel--define-test zel--let-unique
  (zel--let-unique (b)
    (zel--let a b
      (zel--let-unique (b)
        (zel--test= nil (eq a b))))))

(zel--define-test zel--add
  (zel--let l ()
    (zel--add l 'a)
    (zel--test= l '(a))
    (zel--add l 'b)
    (zel--test= l '(a b))))

(zel--define-test zel--each
  (zel--let a nil
    (zel--each x '(1 2 3)
      (setq a x))
    (zel--test= 3 a))
  (zel--let l ()
    (zel--each (x . y) '((a . 1) (b . 2))
      (zel--add l (list x y)))
    (zel--test= '((a 1) (b 2)) l)))

(zel--define-test zel-eval
  (zel--test= t (zel-eval t ()))
  (zel--test= 1 (zel-eval 1 ())))

(zel--define-test zel-compile
  (zel--test= t (zel-compile t))
  (zel--test= t (zel-compile t))
  (zel--test= nil (zel-compile nil)))

(zel--define-test zel-scheme
  (zel--test= nil (zel--special-p '(zzz x)))
  (zel--test= 1 (zel-scheme 1)))

(provide 'zel-test)
