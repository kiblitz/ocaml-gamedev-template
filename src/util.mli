open! Core

module Draw : sig
  val with_drawing : (unit -> unit) -> unit
  val with_2d_camera : (unit -> unit) -> camera:Raylib.Camera2D.t -> unit
end

module Smooth : sig
  val lerp
    :  current:float
    -> target:float
    -> c:float
    -> delta_time:Time_ns.Span.t
    -> float

  val drag : current:float -> c:float -> delta_time:Time_ns.Span.t -> float
end
