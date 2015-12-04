(defpackage #:rogalia-quest
  (:use :common-lisp :asdf)
  (:export :main))

(in-package :rogalia-quest)

(defsystem :sdl2-image
  :name "rogalia-quest"
  :description "Rogalia quest"
  :author "TatriX"
  :depends-on (:sdl2 :sdl2-image)
  :serial t

  :components
  ((:file "main")))
