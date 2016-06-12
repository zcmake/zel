;;; -*- lexical-binding: t -*-

(eval-and-compile
  (require 'zel-compile))

(eval-and-compile
  (defmacro zel-scheme (&rest body)
    (zel-expand body)))

(provide 'zel)
