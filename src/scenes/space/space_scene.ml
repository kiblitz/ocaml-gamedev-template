open! Core
open! Import

type t = { camera : Camera.t }

let create () =
  { camera =
      Camera.create
        ~rotation:0.
        ~position_lerp_c:0.01
        ~zoom_lerp_c:0.01
        ~rotation_lerp_c:0.01
        { x = -200.; y = -150.; width = 1280.; height = 720. }
  }
;;

let update_result (result : (t, Scene_event.t) With_game_event.t) ~f = f result.value

let update t ~delta_time =
  let result = { With_game_event.value = t; game_event = Scene_event.Continue } in
  let result =
    update_result result ~f:(fun t ->
      let { With_game_event.value = new_camera; game_event = () } =
        Camera.update t.camera ~delta_time
      in
      { result with value = { camera = new_camera } })
  in
  result
;;

let draw t ~resource_manager:_ =
  Camera.draw_with t.camera ~f:(fun () ->
    Raylib.draw_text
      "Congrats! You created your first window!"
      190
      200
      20
      Raylib.Color.lightgray)
;;
