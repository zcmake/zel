;;; -*- lexical-binding: t -*-

(require 'zel)

(defmacro zel-test= (a b)
  `(if (not (equal ,a ,b))
       (error (format "(zel-test= %S %S)\nExpected %S, got %S" ',a ',b ,a ,b))
     t))

(defun zel-run-tests ()
  (setq-local lexical-binding t)
  (zel-test= t t)
  (zel-test= t (not nil))
  (zel-test= t (zel-eval t ()))
  (zel-test= 1 (zel-scheme 1))
  (zel-test= t (zel-compile t))
  (zel-test= nil (zel-compile nil))
  (let ((x1 (zel--unique 'x))
	(x2 (zel--unique 'x)))
    (zel-test= nil (eq x1 x2)))
  (let ((l ()))
    (zel--add l 'foo)
    (zel-test= l '(foo)))
  (zel-test= nil (zel--special-p '(zzz x)))
  t)

(provide 'zel-test)
