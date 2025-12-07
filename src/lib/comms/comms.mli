open! Core

module From_main : sig
  type 'a t =
    | Kill
    | Value of 'a
end

type ('a, 'b) t

val create : unit -> (_, _) t
val send_from_main : ('a, _) t -> value:'a -> unit
val recv_from_main : ('a, _) t -> 'a From_main.t option
val send_to_main : (_, 'a) t -> value:'a -> unit
val recv_to_main : (_, 'a) t -> 'a option
val kill : (_, _) t -> unit
