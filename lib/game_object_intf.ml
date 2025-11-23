open! Core

module Updatable = struct
  module type S = sig
    type t
    type event

    val update : t -> delta_time:Time_ns.Span.t -> (t, event) With_game_event.t
  end
end

module Drawable = struct
  module type S = sig
    type t

    val draw : t -> unit
  end
end
