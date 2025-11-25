open! Core
open! Import

type t

val create
  :  ?rotation:float
  -> ?position_lerp_c:float
  -> ?zoom_lerp_c:float
  -> ?rotation_lerp_c:float
  -> Bounds.t
  -> t

val draw_with : t -> f:(unit -> unit) -> unit

include Game_object_intf.Updatable.S with type t := t and type event := unit
