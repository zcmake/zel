;;; -*- lexical-binding: t -*-

(eval-and-compile

(defun zel-compile (expr &optional _env)
  expr)

(defun zel-eval (expr &optional env)
  (eval (zel-compile expr env) t)) ; lexical eval

(defun zel-error (msg &optional x)
  (error (if x
             (format "zel error: %s %S" msg x)
           (format "zel error: %s" msg))))

(defun zel-begin ()
    (or lexical-binding (zel-error "LEXICAL-BINDING was nil.

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

(defmacro zel-scheme (&rest body)
  (zel-expand body))

)

(provide 'zel)
