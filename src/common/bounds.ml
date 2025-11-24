open! Core

type t =
  { x : float
  ; y : float
  ; width : float
  ; height : float
  }

let to_rect { x; y; width; height } =
  Raylib.Rectangle.create (x /. 2.) (y /. 2.) width height
;;
