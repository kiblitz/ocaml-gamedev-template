open! Core
open Import

let name = "OCaml Gamedev Template"

module Setup = struct
  type t = { resource_manager : Resource_manager.t }

  let init_exn () =
    Raylib.init_window 0 0 name;
    Raylib.toggle_fullscreen ();
    Raylib.set_target_fps
      (let reasonable_starting_fps = 60 in
       reasonable_starting_fps);
    Raylib.set_exit_key Raylib.Key.Null;
    let resource_manager = Resource_manager.create_exn () in
    { resource_manager }
  ;;
end

let on_exit state = State.on_exit state

let run () =
  let { Setup.resource_manager } = Setup.init_exn () in
  let initial_state = State.create () in
  let rec loop state =
    let delta_time = Raylib.get_frame_time () |> Time_ns.Span.of_sec in
    let { With_game_event.value = state; game_event } = State.update ~delta_time state in
    Util.Draw.with_drawing (fun () -> State.draw state ~resource_manager);
    match (game_event : State.Event.t) with
    | Continue -> loop state
    | Finished -> on_exit state
    | Finished_with_error error -> [ on_exit state; Error error ] |> Or_error.all_unit
  in
  loop initial_state
;;
