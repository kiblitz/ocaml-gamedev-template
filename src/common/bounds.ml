open! Core

type t =
  { x : float
  ; y : float
  ; width : float
  ; height : float
  }
[@@deriving fields ~getters, sexp_of]

let to_rect { x; y; width; height } = Raylib.Rectangle.create x y width height

module Expert = struct
  let to_rect_account_for_origin { x; y; width; height } =
    Raylib.Rectangle.create (x +. (width /. 2.)) (y +. (height /. 2.)) width height
  ;;
end
