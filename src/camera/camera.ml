open! Core
open! Import

type t =
  { target_bounds : Bounds.t
  ; target_rotation : float
  ; position_lerp_c : float
  ; zoom_lerp_c : float
  ; rotation_lerp_c : float
  }

let create ~bounds ~rotation ~position_lerp_c ~zoom_lerp_c ~rotation_lerp_c =
  { target_bounds = bounds
  ; target_rotation = rotation
  ; position_lerp_c
  ; zoom_lerp_c
  ; rotation_lerp_c
  }
;;

let update t ~camera ~delta_time =
  let lerp = Util.Smooth.lerp ~delta_time in
  let new_position =
    let x, y =
      let position = Raylib.Camera2D.target camera in
      Raylib.Vector2.x position, Raylib.Vector2.y position
    in
    let lerp = lerp ~c:t.position_lerp_c in
    let new_x = lerp ~current:x ~target:t.target_bounds.x in
    let new_y = lerp ~current:y ~target:t.target_bounds.y in
    Raylib.Vector2.create new_x new_y
  in
  Raylib.Camera2D.set_target camera new_position;
  let new_zoom =
    let target_zoom =
      let x_zoom = Float.of_int (Raylib.get_screen_width ()) /. t.target_bounds.width in
      let y_zoom = Float.of_int (Raylib.get_screen_height ()) /. t.target_bounds.height in
      Float.min x_zoom y_zoom
    in
    lerp ~current:(Raylib.Camera2D.zoom camera) ~target:target_zoom ~c:t.zoom_lerp_c
  in
  Raylib.Camera2D.set_zoom camera new_zoom;
  let new_rotation =
    lerp
      ~current:(Raylib.Camera2D.rotation camera)
      ~target:t.target_rotation
      ~c:t.rotation_lerp_c
  in
  Raylib.Camera2D.set_rotation camera new_rotation;
  { With_game_event.value = t; game_event = () }
;;
