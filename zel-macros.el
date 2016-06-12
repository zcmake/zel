;;; -*- lexical-binding: t -*-

(eval-and-compile
  (require 'cl)
  (require 'zel-runtime))

(defmacro zel--with-unique (vars &rest body)
  (declare (indent 1))
  (if (atom vars)
      `(zel--with-unique (,vars) ,@body)
    `(let (,@(mapcar (lambda (x) `(,x (zel--unique ',x)))
                     vars))
       ,@body)))

(defmacro zel--add (l x)
  `(progn
     (if ,l
         (nconc ,l (list ,x))
       (setq ,l (list ,x)))
     nil))

(provide 'zel-macros)
