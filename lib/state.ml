open! Core

module With_status = struct
  type 'a t =
    | Continue of 'a
    | Finished_with_error of
        { value : 'a
        ; error : Error.t
        }
    | Finished of 'a
end

type t = unit

let create () = ()
let is_finished () = Raylib.window_should_close ()

let update' t =
  Raylib.begin_drawing ();
  Raylib.clear_background Raylib.Color.raywhite;
  Raylib.draw_text
    "Congrats! You created your first window!"
    190
    200
    20
    Raylib.Color.lightgray;
  Raylib.end_drawing ();
  With_status.Continue t
;;

let update t =
  match is_finished t with
  | true -> With_status.Finished t
  | false -> update' t
;;

let on_exit () = Ok ()
