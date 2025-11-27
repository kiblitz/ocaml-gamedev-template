open! Core
open Import

module Event : sig
  type t =
    | None
    | Hover
    | Held
    | Pressed

  module Total_map : Total_map.S_plain with type Key.t := t
end

type t

val create
  :  ?camera:Camera.t
  -> ?image_source_bounds:Bounds.t option Event.Total_map.t
  -> ?image_color_tints:Raylib.Color.t option Event.Total_map.t
  -> bounds:Bounds.t
  -> images:Resource_manager.Resource.Image.t Event.Total_map.t
  -> unit
  -> t

include Game_object_intf.Updatable.S with type t := t and type event := Event.t
include Game_object_intf.Drawable.S with type t := t
