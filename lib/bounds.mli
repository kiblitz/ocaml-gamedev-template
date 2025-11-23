open! Core

type t =
  { x : float
  ; y : float
  ; width : float
  ; height : float
  }

val to_rect : t -> Raylib.Rectangle.t
