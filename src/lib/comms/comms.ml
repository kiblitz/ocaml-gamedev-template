open! Core

module From_main = struct
  type 'a t =
    | Kill
    | Value of 'a
end

type ('a, 'b) t =
  { from_main : 'a From_main.t Domainslib.Chan.t
  ; to_main : 'b Domainslib.Chan.t
  }

let create () =
  { from_main = Domainslib.Chan.make_unbounded ()
  ; to_main = Domainslib.Chan.make_unbounded ()
  }
;;

let send_from_main t ~value = Domainslib.Chan.send t.from_main (From_main.Value value)
let recv_from_main t = Domainslib.Chan.recv_poll t.from_main
let send_to_main t ~value = Domainslib.Chan.send t.to_main value
let recv_to_main t = Domainslib.Chan.recv_poll t.to_main
let kill t = Domainslib.Chan.send t.from_main Kill
