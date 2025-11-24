open! Core

module Updatable = struct
  module type S = sig
    type t
    type event

    val update : t -> delta_time:Time_ns.Span.t -> (t, event) With_game_event.t
  end
end

(* This is quite silly -- it exists because camera offset logic is entirely in
   Raylib so every update must take in that camera.
*)
module Updatable_with_raylib_camera = struct
  module type S = sig
    type t
    type event

    val update
      :  t
      -> camera:Raylib.Camera2D.t
      -> delta_time:Time_ns.Span.t
      -> (t, event) With_game_event.t
  end
end

module Drawable = struct
  module type S = sig
    type t

    val draw : t -> camera:Raylib.Camera2D.t -> unit
  end
end
