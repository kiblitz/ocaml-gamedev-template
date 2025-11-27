open! Core
open! Import

module Event = struct
  type t =
    | Exit
    | None
    | Resume
end

type t = { camera : Camera.t }

let create () =
  { camera = Camera.create { x = 0.; y = 0.; width = 1280.; height = 720. } }
;;

let game_event (_ : t) =
  if Raylib.is_key_pressed Raylib.Key.Escape then Event.Resume else None
;;

let update t ~delta_time =
  let updated_t =
    let { With_game_event.value = updated_camera; game_event = () } =
      Camera.update t.camera ~delta_time
    in
    { camera = updated_camera }
  in
  { With_game_event.value = updated_t; game_event = game_event t }
;;

let draw t ~resource_manager =
  Camera.draw_with t.camera ~f:(fun () ->
    Raylib.draw_text "Menu" 20 20 20 Raylib.Color.black;
    Util.Draw.draw_image
      (Png ButtonLong_beige)
      ~dest:{ Bounds.x = 120.; y = 100.; width = 200.; height = 67. }
      ~resource_manager)
;;
