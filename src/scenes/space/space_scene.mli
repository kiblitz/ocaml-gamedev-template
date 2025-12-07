open! Core
open Import

type t

val create : unit -> wait_ten:(unit, unit) Comms.t -> t

include Scene_intf.S with type t := t
