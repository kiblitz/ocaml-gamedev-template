open! Core

module Draw : sig
  val with_drawing : (unit -> unit) -> unit
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
