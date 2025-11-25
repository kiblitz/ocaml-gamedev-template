open! Core

module Draw = struct
  let with_drawing f =
    Raylib.begin_drawing ();
    f ();
    Raylib.end_drawing ()
  ;;
end

module Smooth = struct
  let float_of_time_span = Time_ns.Span.to_sec

  let lerp ~current ~target ~c ~delta_time =
    let delta_time = float_of_time_span delta_time in
    let pct = 1. -. Float.(c ** delta_time) in
    current +. ((target -. current) *. pct)
  ;;

  let drag ~current ~c ~delta_time =
    let delta_time = float_of_time_span delta_time in
    current *. Float.(c ** delta_time)
  ;;
end
