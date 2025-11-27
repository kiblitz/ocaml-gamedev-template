open! Core

module Draw : sig
  val with_drawing : (unit -> unit) -> unit

  val draw_image
    :  ?color_tint:Raylib.Color.t
    -> ?rotation:float
    -> ?origin:float * float
    -> ?source:Bounds.t
    -> Resource_manager.Resource.Image.t
    -> dest:Bounds.t
    -> resource_manager:Resource_manager.t
    -> unit
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
