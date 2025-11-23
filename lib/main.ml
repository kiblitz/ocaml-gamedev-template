open! Core

let run () =
  let rec loop state =
    match (State.update state : State.t State.With_status.t) with
    | Continue state -> loop state
    | Finished -> Ok ()
    | Finished_with_error error -> Error error
  in
  let initial_state = State.create () in
  loop initial_state
;;
