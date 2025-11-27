include struct
  open Common
  module Bounds = Bounds
  module Game_object_intf = Game_object_intf
  module Util = Util
  module With_game_event = With_game_event
  module Resource_manager = Resource_manager
end

include struct
  open Scene_common
  module Scene_event = Event
end
