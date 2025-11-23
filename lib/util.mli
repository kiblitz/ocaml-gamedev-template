open! Core

val lerp : current:float -> target:float -> c:float -> delta_time:Time_ns.Span.t -> float
val drag : current:float -> c:float -> delta_time:Time_ns.Span.t -> float
