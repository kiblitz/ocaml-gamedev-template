open! Core

module Action = struct
  module T = struct
    type t =
      | Select
      | Toggle_menu
    [@@deriving compare, enumerate, sexp]
  end

  include T
  include Total_map.Make_for_include_functor_plain (T)
end

module Input = struct
  type _ unpacked =
    | Key : Raylib.Key.t -> Raylib.Key.t unpacked
    | Mouse_button : Raylib.MouseButton.t -> Raylib.MouseButton.t unpacked

  type t = T : _ unpacked -> t
end

type t = { mapping : Input.t Action.Total_map.t }

let create () =
  let mapping =
    Action.Total_map.create (function
      | Select -> Input.T (Mouse_button Raylib.MouseButton.Left)
      | Toggle_menu -> Input.T (Key Raylib.Key.Escape))
  in
  { mapping }
;;

let check_action t ~action ~key_check ~mouse_button_check =
  match Total_map.find t.mapping action with
  | T (Key key) -> key_check key
  | T (Mouse_button mouse_button) -> mouse_button_check mouse_button
;;

let is_pressed =
  check_action
    ~key_check:Raylib.is_key_pressed
    ~mouse_button_check:Raylib.is_mouse_button_pressed
;;

let is_released =
  check_action
    ~key_check:Raylib.is_key_released
    ~mouse_button_check:Raylib.is_mouse_button_released
;;

let is_down =
  check_action
    ~key_check:Raylib.is_key_down
    ~mouse_button_check:Raylib.is_mouse_button_down
;;

let is_up =
  check_action ~key_check:Raylib.is_key_up ~mouse_button_check:Raylib.is_mouse_button_up
;;
