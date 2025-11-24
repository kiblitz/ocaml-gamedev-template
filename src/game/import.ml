include struct
  open Ocaml_gamedev_template_common
  module Bounds = Bounds
  module Game_object_intf = Game_object_intf
  module Util = Util
  module With_game_event = With_game_event
end

include struct
  open Ocaml_gamedev_template_camera
  module Camera = Camera
end
