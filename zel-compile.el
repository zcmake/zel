;;; -*- lexical-binding: t -*-

(eval-and-compile
  (require 'zel-macros))

(defun zel-compile (s &optional env)
  (cond ((zel--literal-p s) s)
        ((zel--special-p s) (zel--special s env))
        (t (error (format "Bad object in expression: %S" s)))))

(defun zel--literal-p (x)
  (or (numberp x)
      (stringp x)
      (booleanp x)
      (eq x 't)
      (eq x 'nil)))

(defconst zel--specials ())

(defun zel--special-p (s)
  (assoc (car-safe s) zel--specials))

(defun zel--special (s env)
  (let ((f (cdr (zel--special-p s)))
        (args (cons env (cdr s))))
    (apply f args)))

(defmacro zel--define-special (name args &rest body)
  (declare (indent 2))
  `(zel--add zel--specials (cons ',name (lambda ,args ,@body))))

(defun zel-begin ()
  (or lexical-binding
      (error "LEXICAL-BINDING was nil.

If you're in a scratch buffer, please run
\(setq-local lexical-binding t)

If you're working on a file, please add
;;; -*- lexical-binding: t -*-
to the top of it.

If you're calling EVAL, please pass T as the second parameter
to enable lexical evaluation.
")))

(defun zel-expand (body)
  (zel-begin)
  `(progn
     (eval-when-compile (zel-begin))
     ,@(mapcar 'zel-compile body)))

(defun zel-eval (expr &optional env)
  (eval (zel-compile expr env) t)) ; lexical eval

(provide 'zel-compile)
