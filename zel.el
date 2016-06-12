;;; -*- lexical-binding: t -*-

(eval-and-compile
  (require 'zel-runtime)
  (require 'zel-macros)
  (require 'zel-compile)
  (defun zel-reload ()
    (load "zel-runtime.elc")
    (load "zel-macros.elc")
    (load "zel-compile.elc")))

(defmacro zel-scheme (&rest body)
  (zel-expand body))

(provide 'zel)
