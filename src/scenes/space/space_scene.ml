open! Core
open! Import

type t =
  { camera : Camera.t
  ; wait_ten : (unit, unit) Comms.t
  ; ten_passed : bool
  }

let create () ~wait_ten =
  { camera =
      Camera.create
        ~rotation:0.
        ~position_lerp_c:0.01
        ~zoom_lerp_c:0.01
        ~rotation_lerp_c:0.01
        { x = -200.; y = -150.; width = 1280.; height = 720. }
  ; wait_ten
  ; ten_passed = false
  }
;;

let update_result (result : (t, Scene_event.t) With_game_event.t) ~f = f result.value

let update t ~input_manager ~delta_time =
  let result = { With_game_event.value = t; game_event = Scene_event.Continue } in
  let result =
    update_result result ~f:(fun t ->
      let { With_game_event.value = new_camera; game_event = () } =
        Camera.update t.camera ~input_manager ~delta_time
      in
      { result with value = { t with camera = new_camera } })
  in
  let result =
    update_result result ~f:(fun t ->
      match Comms.recv_to_main t.wait_ten with
      | None -> result
      | Some () -> { result with value = { t with ten_passed = true } })
  in
  result
;;

let draw t ~resource_manager:_ =
  Camera.draw_with t.camera ~f:(fun () ->
    let text_color = if t.ten_passed then Raylib.Color.red else Raylib.Color.lightgray in
    Raylib.draw_text "Congrats! You created your first window!" 190 200 20 text_color)
;;
