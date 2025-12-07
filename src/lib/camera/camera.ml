open! Core
open! Import

type t =
  { raylib_camera : Raylib.Camera2D.t
  ; target_bounds : Bounds.t
  ; target_rotation : float
  ; position_lerp_c : float
  ; zoom_lerp_c : float
  ; rotation_lerp_c : float
  }

let create
      ?(rotation = 0.)
      ?(position_lerp_c = 0.)
      ?(zoom_lerp_c = 0.)
      ?(rotation_lerp_c = 0.)
      bounds
  =
  { raylib_camera =
      Raylib.Camera2D.create (Raylib.Vector2.zero ()) (Raylib.Vector2.zero ()) 0. 0.
  ; target_bounds = bounds
  ; target_rotation = rotation
  ; position_lerp_c
  ; zoom_lerp_c
  ; rotation_lerp_c
  }
;;

let transform_to_screen_position t ~x ~y =
  let position = Raylib.Vector2.create x y in
  let screen_position = Raylib.get_world_to_screen_2d position t.raylib_camera in
  Raylib.Vector2.x screen_position, Raylib.Vector2.y screen_position
;;

let transform_from_screen_position t ~x ~y =
  let position = Raylib.Vector2.create x y in
  let screen_position = Raylib.get_screen_to_world_2d position t.raylib_camera in
  Raylib.Vector2.x screen_position, Raylib.Vector2.y screen_position
;;

let draw_with t ~f =
  Raylib.begin_mode_2d t.raylib_camera;
  f ();
  Raylib.end_mode_2d ()
;;

let update t ~input_manager:_ ~delta_time =
  let lerp = Util.Smooth.lerp ~delta_time in
  let new_position =
    let x, y =
      let position = Raylib.Camera2D.target t.raylib_camera in
      Raylib.Vector2.x position, Raylib.Vector2.y position
    in
    let lerp = lerp ~c:t.position_lerp_c in
    let new_x = lerp ~current:x ~target:t.target_bounds.x in
    let new_y = lerp ~current:y ~target:t.target_bounds.y in
    Raylib.Vector2.create new_x new_y
  in
  Raylib.Camera2D.set_target t.raylib_camera new_position;
  let new_zoom =
    let target_zoom =
      let x_zoom = Float.of_int (Raylib.get_screen_width ()) /. t.target_bounds.width in
      let y_zoom = Float.of_int (Raylib.get_screen_height ()) /. t.target_bounds.height in
      Float.min x_zoom y_zoom
    in
    lerp
      ~current:(Raylib.Camera2D.zoom t.raylib_camera)
      ~target:target_zoom
      ~c:t.zoom_lerp_c
  in
  Raylib.Camera2D.set_zoom t.raylib_camera new_zoom;
  let new_rotation =
    lerp
      ~current:(Raylib.Camera2D.rotation t.raylib_camera)
      ~target:t.target_rotation
      ~c:t.rotation_lerp_c
  in
  Raylib.Camera2D.set_rotation t.raylib_camera new_rotation;
  { With_game_event.value = t; game_event = () }
;;
