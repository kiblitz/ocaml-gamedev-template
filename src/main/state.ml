open! Core
open! Import

type t =
  { space_scene : Space_scene.t
  ; menu : Menu.t option
  }

let create () = { space_scene = Space_scene.create (); menu = None }
let is_finished (_ : t) = Raylib.window_should_close ()
let is_paused t = Option.is_some t.menu

let update_result
      ?(update_when_paused = false)
      (result : (t, Scene_event.t) With_game_event.t)
      ~f
  =
  if update_when_paused || not (is_paused result.value) then f result.value else result
;;

let update' t ~delta_time =
  let result = { With_game_event.value = t; game_event = Scene_event.Continue } in
  let result =
    update_result result ~f:(fun t ->
      let { With_game_event.value = space_scene; game_event } =
        Space_scene.update t.space_scene ~delta_time
      in
      { value = { t with space_scene }; game_event })
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
         | Exit -> { result with game_event = Scene_event.Finished })
      | None ->
        if Raylib.is_key_pressed Raylib.Key.Escape
        then { result with value = { t with menu = Some (Menu.create ()) } }
        else result)
  in
  result
;;

let update t ~delta_time =
  match is_finished t with
  | true -> { With_game_event.value = t; game_event = Scene_event.Finished }
  | false -> update' ~delta_time t
;;

let draw t ~resource_manager =
  Raylib.clear_background Raylib.Color.raywhite;
  Space_scene.draw t.space_scene ~resource_manager;
  Option.iter t.menu ~f:(fun menu -> Menu.draw menu ~resource_manager)
;;

let on_exit (_ : t) = Ok ()
