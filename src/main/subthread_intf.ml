open! Core

module type Subthread = sig
  type from_main
  type to_main

  val run : (from_main, to_main) Comms.t -> unit Or_error.t
end

module type Subthread_loop = sig
  type t
  type from_main
  type to_main

  val create_exn : unit -> t
  val on_kill : t -> unit Or_error.t
  val loop : t -> msg_from_main:from_main option -> send_to_main:(to_main -> unit) -> t
end

module type S = sig
  module Make : functor (M : Subthread_loop) ->
    Subthread with type from_main := M.from_main and type to_main := M.to_main
end
