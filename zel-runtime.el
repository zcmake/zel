;;; -*- lexical-binding: t -*-

(eval-when-compile
  (require 'cl))

(defun zel--str (x)
  (format "%S" x))

(defun zel--stringify (x)
  (cond ((stringp x) x)
        ((symbolp x) (symbol-name x))
        (t (zel--str x))))

(defun zel--cat (&rest l)
  (mapconcat 'zel--stringify l ""))
 
(defun zel--unique (&optional x)
  (cl-gensym (zel--stringify (or x 'x))))

(provide 'zel-runtime)
