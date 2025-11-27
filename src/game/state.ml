open! Core
open! Import

module Event = struct
  type t =
    | Continue
    | Finished
    | Finished_with_error of Error.t
end

type t =
  { camera : Camera.t
  ; menu : Menu.t option
  }

let create () =
  { camera =
      Camera.create
        ~rotation:0.
        ~position_lerp_c:0.01
        ~zoom_lerp_c:0.01
        ~rotation_lerp_c:0.01
        { x = -200.; y = -150.; width = 1280.; height = 720. }
  ; menu = None
  }
;;

let is_finished (_ : t) = Raylib.window_should_close ()
let is_paused t = Option.is_some t.menu

let update_result
      ?(update_when_paused = false)
      (result : (t, Event.t) With_game_event.t)
      ~f
  =
  if update_when_paused || not (is_paused result.value) then f result.value else result
;;

let update' t ~delta_time =
  let result = { With_game_event.value = t; game_event = Event.Continue } in
  let result =
    update_result result ~f:(fun t ->
      let { With_game_event.value = new_camera; game_event = () } =
        Camera.update t.camera ~delta_time
      in
      { result with value = { t with camera = new_camera } })
  in
  let result =
    update_result result ~update_when_paused:true ~f:(fun t ->
      match t.menu with
      | Some menu ->
        let { With_game_event.value = new_menu; game_event } =
          Menu.update menu ~delta_time
        in
        (match (game_event : Menu.Event.t) with
         | Resume -> { result with value = { t with menu = None } }
         | None -> { result with value = { t with menu = Some new_menu } }
         | Exit -> { result with game_event = Event.Finished })
      | None ->
        if Raylib.is_key_pressed Raylib.Key.Escape
        then { result with value = { t with menu = Some (Menu.create ()) } }
        else result)
  in
  result
;;

let update t ~delta_time =
  match is_finished t with
  | true -> { With_game_event.value = t; game_event = Event.Finished }
  | false -> update' ~delta_time t
;;

let draw t ~resource_manager =
  Raylib.clear_background Raylib.Color.raywhite;
  Camera.draw_with t.camera ~f:(fun () ->
    Raylib.draw_text
      "Congrats! You created your first window!"
      190
      200
      20
      Raylib.Color.lightgray);
  Option.iter t.menu ~f:(fun menu -> Menu.draw menu ~resource_manager)
;;

let on_exit (_ : t) = Ok ()
