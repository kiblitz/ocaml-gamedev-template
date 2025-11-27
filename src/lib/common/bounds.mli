open! Core

type t =
  { x : float
  ; y : float
  ; width : float
  ; height : float
  }
[@@deriving fields ~getters, sexp_of]

val to_rect : t -> Raylib.Rectangle.t

module Expert : sig
  (* This is pretty sad but it's because we need to sometimes set [origin] for
     rotation purposes which offsets the rectangle. Ideally, everything has
     [origin] set to the center but some [Raylib] constructs don't support it. *)
  val to_rect_account_for_origin : t -> Raylib.Rectangle.t
end
