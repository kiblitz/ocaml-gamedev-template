open! Core

module Action : sig
  type t =
    | Select
    | Toggle_menu
end

type t

val create : unit -> t
val is_pressed : t -> action:Action.t -> bool
val is_released : t -> action:Action.t -> bool
val is_down : t -> action:Action.t -> bool
val is_up : t -> action:Action.t -> bool
