open! Core

let name = "OCaml Gamedev Template"

let setup () =
  Raylib.init_window 0 0 name;
  Raylib.toggle_fullscreen ();
  Raylib.set_target_fps
    (let reasonable_starting_fps = 60 in
     reasonable_starting_fps);
  ()
;;

let on_exit state = State.on_exit state

let run () =
  setup ();
  let initial_state = State.create () in
  let rec loop state =
    match (State.update state : State.t State.With_status.t) with
    | Continue state -> loop state
    | Finished state -> on_exit state
    | Finished_with_error { value = state; error } ->
      [ on_exit state; Error error ] |> Or_error.all_unit
  in
  loop initial_state
;;
