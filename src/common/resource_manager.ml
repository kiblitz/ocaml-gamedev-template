open! Core

module Resource = struct
  module type S = sig
    type t

    module Variants : sig
      val to_name : t -> string
    end

    val file_type : string
  end

  module Make (M : S) = struct
    let filename t =
      let name = M.Variants.to_name t |> String.uncapitalize in
      [%string "%{name}%{M.file_type}"]
    ;;
  end

  module Image = struct
    module Png = struct
      module T = struct
        type t =
          | ButtonLong_beige
          | ButtonLong_beige_pressed
          | ButtonLong_grey
          | ButtonLong_grey_pressed
        [@@deriving bin_io, compare, enumerate, sexp, variants]

        let file_type = ".png"
      end

      include T
      include Make (T)
    end

    module T = struct
      type t = Png of Png.t [@@deriving bin_io, compare, enumerate, sexp, variants]
    end

    include T
    module Total_map = Total_map.Make (T)

    let filename = function
      | Png png -> Png.filename png
    ;;

    let file_type = function
      | Png _ -> Png.file_type
    ;;
  end

  type (_, _) t = Image : Image.t -> (Raylib.Image.t, Raylib.Texture.t) t

  let contents (type a) (t : (a, _) t) : a option =
    match t with
    | Image image ->
      let%map.Option raw_contents = Resources.read (Image.filename image) in
      Raylib.load_image_from_memory
        (Image.file_type image)
        raw_contents
        (String.length raw_contents)
  ;;
end

type t =
  { images : Raylib.Image.t Resource.Image.Total_map.t
  ; mutable textures_cache : Raylib.Texture.t option Resource.Image.Total_map.t
  }

let create_exn () =
  let images =
    Resource.Image.Total_map.create (fun image_resource ->
      Resource.contents (Image image_resource) |> Option.value_exn)
  in
  let textures_cache = Resource.Image.Total_map.create_const None in
  { images; textures_cache }
;;

let get_raw (type a b) (t : t) ~(resource : (a, b) Resource.t) : a =
  match resource with
  | Image image -> Total_map.find t.images image
;;

let get (type a b) (t : t) ~(resource : (a, b) Resource.t) : b =
  match resource with
  | Image image ->
    (match Total_map.find t.textures_cache image with
     | Some texture -> texture
     | None ->
       let texture =
         let raylib_image = get_raw t ~resource in
         Raylib.load_texture_from_image raylib_image
       in
       let updated_textures_cache = Total_map.set t.textures_cache image (Some texture) in
       t.textures_cache <- updated_textures_cache;
       texture)
;;
