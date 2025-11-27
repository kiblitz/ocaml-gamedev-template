open! Core

module Resource : sig
  module Image : sig
    module Png : sig
      type t =
        | ButtonLong_beige
        | ButtonLong_beige_pressed
        | ButtonLong_grey
        | ButtonLong_grey_pressed
    end

    type t = Png of Png.t
  end

  type (_, _) t = Image : Image.t -> (Raylib.Image.t, Raylib.Texture.t) t
end

type t

val create_exn : unit -> t
val get : t -> resource:(_, 'a) Resource.t -> 'a
