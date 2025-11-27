open! Core
open! Import

module Event = struct
  type t =
    | Exit
    | None
    | Resume

  let merge t1 t2 =
    match t1, t2 with
    | Exit, Exit -> Exit
    | None, None -> None
    | Resume, Resume -> Resume
    | Exit, Resume | Resume, Exit -> Exit
    | None, event | event, None -> event
  ;;
end

type t =
  { camera : Camera.t
  ; exit_button : Button.t
  }

let create () =
  let camera = Camera.create { x = 0.; y = 0.; width = 1280.; height = 720. } in
  let exit_button =
    Button.create
      ~camera
      ~bounds:{ Bounds.x = 20.; y = 35.; width = 200.; height = 67. }
      ~images:
        (Button.Event.Total_map.create (fun (event : Button.Event.t) ->
           match event with
           | None -> Resource_manager.Resource.Image.Png ButtonLong_grey
           | Hover -> Resource_manager.Resource.Image.Png ButtonLong_beige
           | Held | Pressed ->
             Resource_manager.Resource.Image.Png ButtonLong_beige_pressed))
      ()
  in
  { camera; exit_button }
;;

let maybe_resume (_ : t) =
  if Raylib.is_key_pressed Raylib.Key.Escape then Event.Resume else None
;;

let update_result (result : (t, Event.t) With_game_event.t) ~f =
  let (updated_result : (t, Event.t) With_game_event.t) = f result.value in
  { updated_result with
    game_event = Event.merge result.game_event updated_result.game_event
  }
;;

let update t ~delta_time =
  let result = { With_game_event.value = t; game_event = Event.None } in
  let result =
    update_result result ~f:(fun t ->
      let { With_game_event.value = updated_camera; game_event = () } =
        Camera.update t.camera ~delta_time
      in
      { result with value = { t with camera = updated_camera } })
  in
  let result =
    update_result result ~f:(fun t ->
      let { With_game_event.value = updated_exit_button; game_event } =
        Button.update t.exit_button ~delta_time
      in
      let game_event =
        match (game_event : Button.Event.t) with
        | Pressed -> Event.Exit
        | None | Hover | Held -> Event.None
      in
      { With_game_event.value = { t with exit_button = updated_exit_button }; game_event })
  in
  update_result result ~f:(fun t ->
    { With_game_event.value = t; game_event = maybe_resume t })
;;

let draw t ~resource_manager =
  Camera.draw_with t.camera ~f:(fun () ->
    Raylib.draw_text "Menu" 20 20 20 Raylib.Color.black;
    Button.draw t.exit_button ~resource_manager;
    Raylib.draw_text "Exit" 108 67 20 Raylib.Color.black)
;;
