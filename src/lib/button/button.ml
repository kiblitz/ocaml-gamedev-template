open! Core
open Import

module Event = struct
  module T = struct
    type t =
      | None
      | Hover
      | Held
      | Pressed
    [@@deriving compare, enumerate, sexp_of]
  end

  include T
  include Total_map.Make_for_include_functor_plain (T)
end

type t =
  { camera : Camera.t option
  ; bounds : Bounds.t
  ; state : Event.t
  ; images : Resource_manager.Resource.Image.t Event.Total_map.t
  ; image_source_bounds : Bounds.t option Event.Total_map.t
  ; image_color_tints : Raylib.Color.t option Event.Total_map.t
  }

let create
      ?camera
      ?(image_source_bounds = Event.Total_map.create_const None)
      ?(image_color_tints = Event.Total_map.create_const None)
      ~bounds
      ~images
      ()
  =
  { camera; bounds; state = None; images; image_source_bounds; image_color_tints }
;;

let update t ~input_manager ~delta_time:_ =
  let new_state =
    let x, y =
      let x = Raylib.get_mouse_x () |> Int.to_float in
      let y = Raylib.get_mouse_y () |> Int.to_float in
      match t.camera with
      | None -> x, y
      | Some camera -> Camera.transform_from_screen_position camera ~x ~y
    in
    match Util.Collision.point_in_bounds ~x ~y ~bounds:t.bounds with
    | false -> Event.None
    | true ->
      if Input_manager.is_down input_manager ~action:Select
      then Event.Held
      else if Input_manager.is_released input_manager ~action:Select
      then Event.Pressed
      else Event.Hover
  in
  let new_t = { t with state = new_state } in
  { With_game_event.value = new_t; game_event = new_t.state }
;;

let draw t ~resource_manager =
  let image = Total_map.find t.images t.state in
  let image_source = Total_map.find t.image_source_bounds t.state in
  let image_color_tint = Total_map.find t.image_color_tints t.state in
  Util.Draw.draw_image
    ?color_tint:image_color_tint
    ?source:image_source
    image
    ~dest:t.bounds
    ~resource_manager
;;
