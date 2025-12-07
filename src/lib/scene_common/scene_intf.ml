open! Core
open! Import

module type S = sig
  type t

  include Game_object_intf.Updatable.S with type t := t and type event := Event.t
  include Game_object_intf.Drawable.S with type t := t
end
