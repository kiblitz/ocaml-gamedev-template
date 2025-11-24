open! Core

module Event : sig
  type t =
    | Continue
    | Finished
    | Finished_with_error of Error.t
end

type t

val create : unit -> t
val on_exit : t -> unit Or_error.t

include
  Game_object_intf.Updatable_with_raylib_camera.S
  with type t := t
   and type event := Event.t

include Game_object_intf.Drawable.S with type t := t
