open! Core

module With_status : sig
  type 'a t =
    | Continue of 'a
    | Finished_with_error of Error.t
    | Finished
end

type t

val create : unit -> t
val update : t -> t With_status.t
