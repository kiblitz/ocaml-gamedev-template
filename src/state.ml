open! Core

module Event = struct
  type t =
    | Continue
    | Finished
    | Finished_with_error of Error.t
end

type t = { camera : Camera.t }

let create () =
  { camera =
      Camera.create
        ~bounds:{ x = -200.; y = -150.; width = 1280.; height = 720. }
        ~rotation:0.
        ~position_lerp_c:0.01
        ~zoom_lerp_c:0.01
        ~rotation_lerp_c:0.01
  }
;;

let is_finished (_ : t) = Raylib.window_should_close ()

let update' t ~camera ~delta_time =
  let { With_game_event.value = new_camera; game_event = () } =
    Camera.update t.camera ~camera ~delta_time
  in
  let new_t = { camera = new_camera } in
  { With_game_event.value = new_t; game_event = Event.Continue }
;;

let update t ~camera ~delta_time =
  match is_finished t with
  | true -> { With_game_event.value = t; game_event = Event.Finished }
  | false -> update' ~camera ~delta_time t
;;

let draw (_ : t) ~camera =
  Raylib.clear_background Raylib.Color.raywhite;
  Util.Draw.with_2d_camera
    (fun () ->
       Raylib.draw_text
         "Congrats! You created your first window!"
         190
         200
         20
         Raylib.Color.lightgray)
    ~camera
;;

let on_exit (_ : t) = Ok ()
