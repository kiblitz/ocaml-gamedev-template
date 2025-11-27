open! Core

type t =
  | Continue
  | Finished
  | Finished_with_error of Error.t
