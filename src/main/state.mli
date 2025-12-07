open! Core
open! Import

type t

val create : unit -> wait_ten:(unit, unit) Comms.t -> t
val on_exit : t -> unit Or_error.t

include Game_object_intf.Updatable.S with type t := t and type event := Scene_event.t
include Game_object_intf.Drawable.S with type t := t
