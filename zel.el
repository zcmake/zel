;;; -*- lexical-binding: t -*-

(defmacro zel-test= (a b)
  `(if (not (equal ,a ,b))
       (error (format "\n(zel-test= %S %S)\nExpected %S, got %S" ',a ',b ,a ,b))
     t))

(defun zel-run-tests ()
  (zel-test= t t)
  (zel-test= t (not nil))
  t)

(provide 'zel)
