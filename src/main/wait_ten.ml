open! Core

module T = struct
  type from_main = unit
  type to_main = unit

  type t =
    { start : Time_ns.t
    ; ten_passed : bool
    }

  let create_exn () =
    let start = Time_ns.now () in
    { start; ten_passed = false }
  ;;

  let on_kill (_ : t) = Ok ()

  let loop t ~msg_from_main ~send_to_main =
    match msg_from_main with
    | None | Some () ->
      let now = Time_ns.now () in
      let diff = Time_ns.diff now t.start in
      if (not t.ten_passed) && Time_ns.Span.(diff >= of_int_sec 10)
      then (
        send_to_main ();
        { t with ten_passed = true })
      else t
  ;;
end

include T
include Subthread.Make (T)
