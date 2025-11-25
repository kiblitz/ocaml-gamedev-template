open! Core
open! Import

module Event = struct
  type t =
    | Exit
    | None
    | Resume
end

type t = { camera : Camera.t }

let create () =
  { camera = Camera.create { x = 640.; y = 360.; width = 1280.; height = 720. } }
;;

let update t ~delta_time:_ = { With_game_event.value = t; game_event = Event.Exit }
let draw t = Camera.draw_with t.camera ~f:(fun () -> ())
