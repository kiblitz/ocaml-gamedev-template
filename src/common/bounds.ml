open! Core

type t =
  { x : float
  ; y : float
  ; width : float
  ; height : float
  }
[@@deriving fields ~getters]

let to_rect { x; y; width; height } = Raylib.Rectangle.create x y width height
