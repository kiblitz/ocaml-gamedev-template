open! Core

module Event = struct
  type t =
    | Continue
    | Finished
    | Finished_with_error of Error.t
end

type t = unit

let create () = ()
let is_finished () = Raylib.window_should_close ()
let update' t ~delta_time:_ = { With_game_event.value = t; game_event = Event.Continue }

let update t ~delta_time =
  match is_finished t with
  | true -> { With_game_event.value = t; game_event = Event.Finished }
  | false -> update' ~delta_time t
;;

let draw (_ : t) =
  Raylib.begin_drawing ();
  Raylib.clear_background Raylib.Color.raywhite;
  Raylib.draw_text
    "Congrats! You created your first window!"
    190
    200
    20
    Raylib.Color.lightgray;
  Raylib.end_drawing ()
;;

let on_exit () = Ok ()
