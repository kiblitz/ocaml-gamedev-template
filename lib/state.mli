open! Core

module With_status : sig
  type 'a t =
    | Continue of 'a
    | Finished_with_error of
        { value : 'a
        ; error : Error.t
        }
    | Finished of 'a
end

type t

val create : unit -> t
val update : t -> t With_status.t
val on_exit : t -> unit Or_error.t
