open! Core
open! Import

module Event : sig
  type t =
    | Exit
    | None
    | Resume
end

type t

val create : unit -> t

include Game_object_intf.Updatable.S with type t := t and type event := Event.t
include Game_object_intf.Drawable.S with type t := t
