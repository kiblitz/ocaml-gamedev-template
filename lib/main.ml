open! Core

let name = "OCaml Gamedev Template"

let setup () =
  Raylib.init_window 0 0 name;
  Raylib.toggle_fullscreen ();
  Raylib.set_target_fps
    (let reasonable_starting_fps = 60 in
     reasonable_starting_fps);
  Raylib.set_exit_key Raylib.Key.Null;
  ()
;;

let on_exit state = State.on_exit state

let run () =
  setup ();
  let initial_state = State.create () in
  let rec loop state =
    let delta_time = Raylib.get_frame_time () |> Time_ns.Span.of_sec in
    let { With_game_event.value = state; game_event } = State.update ~delta_time state in
    Util.Draw.with_drawing (fun () -> State.draw state);
    match (game_event : State.Event.t) with
    | Continue -> loop state
    | Finished -> on_exit state
    | Finished_with_error error -> [ on_exit state; Error error ] |> Or_error.all_unit
  in
  loop initial_state
;;
