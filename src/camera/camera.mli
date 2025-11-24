open! Core
open! Import

type t =
  { target_bounds : Bounds.t
  ; target_rotation : float
  ; position_lerp_c : float
  ; zoom_lerp_c : float
  ; rotation_lerp_c : float
  }

val create
  :  bounds:Bounds.t
  -> rotation:float
  -> position_lerp_c:float
  -> zoom_lerp_c:float
  -> rotation_lerp_c:float
  -> t

include
  Game_object_intf.Updatable_with_raylib_camera.S with type t := t and type event := unit
