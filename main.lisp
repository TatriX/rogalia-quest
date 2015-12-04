(in-package :rogalia-quest)

(require :sdl2)
(require :sdl2-image)

(defun make-texture (renderer filename)
  (sdl2:create-texture-from-surface renderer (sdl2-image:load-image filename)))

(defun main ()
  (sdl2:with-init
      (:everything)
    (format t "Using SDL Library Version: ~D.~D.~D~%"
            sdl2-ffi:+sdl-major-version+
            sdl2-ffi:+sdl-minor-version+
            sdl2-ffi:+sdl-patchlevel+)
    (finish-output)
    (sdl2-image:init '(:png))
    (sdl2:with-window (win :w 766 :h 720 :flags '(:shown :opengl)) ;:fullscreen-desktop
      (sdl2:with-renderer (ren win :flags '())
        (let* ((state 0)
               (basement-surf (sdl2-image:load-image "assets/basement.png"))
               (basement-width (sdl2:surface-width basement-surf))
               (basement-height (sdl2:surface-height basement-surf))
               (basement (sdl2:create-texture-from-surface ren basement-surf))
               (hell (make-texture ren "assets/hell.png"))
               (door (make-texture ren "assets/door.png"))
               (door-rect (sdl2:make-rect 838 979 436 572)))
          (sdl2:with-event-loop (:method :poll)
            (:keydown
             (:keysym keysym)
             (let ((scancode (sdl2:scancode-value keysym))
                   (sym (sdl2:sym-value keysym))
                   (mod-value (sdl2:mod-value keysym)))
               (cond
                 ((sdl2:scancode= scancode :scancode-w) (format t "~a~%" "WALK"))
                 ((sdl2:scancode= scancode :scancode-s) (sdl2:show-cursor))
                 ((sdl2:scancode= scancode :scancode-h) (sdl2:hide-cursor)))
               (format t "Key sym: ~a, code: ~a, mod: ~a~%"
                       sym
                       scancode
                       mod-value)))
            (:keyup
             (:keysym keysym)
             (when (sdl2:scancode= (sdl2:scancode-value keysym) :scancode-escape)
               (sdl2:push-event :quit)))

            (:mousebuttonup
             (:x x :y y)
             (when (= state 0)
               (multiple-value-bind (w h) (sdl2:get-window-size win)
                 (setf x (ceiling (* x (float (/ basement-width w)))))
                 (setf y (ceiling (* y (float (/ basement-height h)))))
                 (format t "Mouse button up: (~a ~a)~%" x y)
                 (when (sdl2:has-intersect door-rect (sdl2:make-rect x y 1 1))
                   (format t "Intersect! ~%")
                   (setf state 1)))))

            (:mousemotion
             (:x x :y y :xrel xrel :yrel yrel :state state)
             (format t "Mouse motion abs(rel): ~a (~a), ~a (~a)~%Mouse state: ~a~%"
                     x xrel y yrel state))
            (:idle
             ()
             (sdl2:set-render-draw-color ren 0 0 0 255)
             (sdl2:render-clear ren)
             (ecase state
               (0
                (sdl2:render-copy ren basement)
                (sdl2:render-copy ren door :dest-rect door-rect))
               (1
                (sdl2:render-copy ren hell)))
             (sdl2:render-present ren))
            (:quit () t))))))))
