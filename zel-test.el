;;; -*- lexical-binding: t -*-

(require 'zel)

(defmacro zel-test= (a b)
  `(if (not (equal ,a ,b))
       (error (format "(zel-test= %S %S)\nExpected %S, got %S" ',a ',b ,a ,b))
     t))

(defun zel-run-tests ()
  (zel-test= t t)
  (zel-test= t (not nil))
  (zel-test= t (zel-eval t ()))
  (zel-test= 1 (zel-scheme 1))
  (zel-test= 'x (zel-compile 'x))
  t)

(provide 'zel-test)
