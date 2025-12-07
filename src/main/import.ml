include struct
  open Common
  module Bounds = Bounds
  module Game_object_intf = Game_object_intf
  module Input_manager = Input_manager
  module Resource_manager = Resource_manager
  module Util = Util
  module With_game_event = With_game_event
end

include struct
  open Scene_common
  module Scene_event = Event
  module Scene_intf = Scene_intf
end
