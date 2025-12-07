open! Core
open! Import

module Make (M : Subthread_intf.Subthread_loop) = struct
  let run comms =
    let thread_loop =
      M.loop ~send_to_main:(fun value -> Comms.send_to_main comms ~value)
    in
    let rec loop t =
      match (Comms.recv_from_main comms : M.from_main Comms.From_main.t option) with
      | Some Kill -> M.on_kill t
      | None ->
        let t = thread_loop t ~msg_from_main:None in
        loop t
      | Some (Value from_main) ->
        let t = thread_loop t ~msg_from_main:(Some from_main) in
        loop t
    in
    let t = M.create_exn () in
    loop t
  ;;
end
