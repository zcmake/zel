;;; -*- lexical-binding: t -*-

(eval-and-compile
  (require 'cl)
  (require 'zel-runtime))

(defmacro zel--dbind (args expr &rest body)
  "Identical to `destructuring-bind'."
  (declare (indent defun))
  `(destructuring-bind ,args ,expr ,@body))

(defmacro zel--let (a b &rest l)
  (declare (indent 2))
  (if (atom a)
      `(let ((,a ,b)) ,@l)
    `(zel--dbind ,a ,b ,@l)))

(defmacro zel--let-unique (vars &rest body)
  (declare (indent 1))
  (if (atom vars)
      `(zel--let-unique (,vars) ,@body)
    `(let (,@(mapcar (lambda (x) `(,x (zel--unique ',x)))
                     vars))
       ,@body)))

(defmacro zel--add (l x)
  `(progn
     (if ,l
         (nconc ,l (list ,x))
       (setq ,l (list ,x)))
     nil))

(defmacro zel--each (x l &rest body)
  (declare (indent 2))
  (zel--let-unique (v)
    `(progn
       (mapc (lambda (,v)
             (zel--let ,x ,v
               ,@body))
             ,l)
       nil)))

(provide 'zel-macros)
