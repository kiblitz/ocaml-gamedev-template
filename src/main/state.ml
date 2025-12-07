open! Core
open! Import

module Scene = struct
  type ('scene, 'config) unpacked =
    { module_ : (module Scene_intf.S with type t = 'scene and type config = 'config)
    ; scene : 'scene
    }

  type t = T : _ unpacked -> t
end

type t =
  { scene : Scene.t
  ; menu : Menu.t option
  }

let create () =
  { scene = T { module_ = (module Space_scene); scene = Space_scene.create () }
  ; menu = None
  }
;;

let is_finished (_ : t) = Raylib.window_should_close ()
let is_paused t = Option.is_some t.menu

let update_result
      ?(update_when_paused = false)
      (result : (t, Scene_event.t) With_game_event.t)
      ~f
  =
  if update_when_paused || not (is_paused result.value) then f result.value else result
;;

let update' t ~input_manager ~delta_time =
  let result = { With_game_event.value = t; game_event = Scene_event.Continue } in
  let result =
    update_result result ~f:(fun t ->
      let (T { Scene.module_ = (module M); scene }) = t.scene in
      let { With_game_event.value = updated_scene; game_event } =
        M.update scene ~input_manager ~delta_time
      in
      let updated_scene = Scene.T { module_ = (module M); scene = updated_scene } in
      { value = { t with scene = updated_scene }; game_event })
  in
  let result =
    update_result result ~update_when_paused:true ~f:(fun t ->
      match t.menu with
      | Some menu ->
        let { With_game_event.value = new_menu; game_event } =
          Menu.update menu ~input_manager ~delta_time
        in
        (match (game_event : Menu.Event.t) with
         | Resume -> { result with value = { t with menu = None } }
         | None -> { result with value = { t with menu = Some new_menu } }
         | Exit -> { result with game_event = Scene_event.Finished })
      | None ->
        if Input_manager.is_pressed input_manager ~action:Toggle_menu
        then { result with value = { t with menu = Some (Menu.create ()) } }
        else result)
  in
  result
;;

let update t ~input_manager ~delta_time =
  match is_finished t with
  | true -> { With_game_event.value = t; game_event = Scene_event.Finished }
  | false -> update' ~input_manager ~delta_time t
;;

let draw t ~resource_manager =
  let (T { Scene.module_ = (module M); scene }) = t.scene in
  Raylib.clear_background Raylib.Color.raywhite;
  M.draw scene ~resource_manager;
  Option.iter t.menu ~f:(fun menu -> Menu.draw menu ~resource_manager)
;;

let on_exit (_ : t) = Ok ()
