open! Core

module With_status = struct
  type 'a t =
    | Continue of 'a
    | Finished_with_error of Error.t
    | Finished
end

type t = unit

let create () = ()

let update () =
  print_endline "hello world";
  With_status.Continue ()
;;
