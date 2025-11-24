open! Core

type ('a, 'b) t =
  { value : 'a
  ; game_event : 'b
  }
[@@deriving fields ~getters]
