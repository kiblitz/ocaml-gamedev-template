open! Core

module Collision = struct
  let point_in_bounds ~x ~y ~bounds =
    let point = Raylib.Vector2.create x y in
    let rect = Bounds.to_rect bounds in
    Raylib.check_collision_point_rec point rect
  ;;
end

module Draw = struct
  let with_drawing f =
    Raylib.begin_drawing ();
    f ();
    Raylib.end_drawing ()
  ;;

  let draw_image
        ?(color_tint = Raylib.Color.white)
        ?(rotation = 0.)
        ?origin
        ?source
        image
        ~dest
        ~resource_manager
    =
    let texture =
      Resource_manager.get
        resource_manager
        ~resource:(Resource_manager.Resource.Image image)
    in
    let source =
      match source with
      | Some source -> source
      | None ->
        { Bounds.x = 0.
        ; y = 0.
        ; width = Raylib.Texture.width texture |> Int.to_float
        ; height = Raylib.Texture.height texture |> Int.to_float
        }
    in
    let origin =
      let x, y =
        match origin with
        | Some origin -> origin
        | None ->
          let x = Bounds.x source +. (Bounds.width source /. 2.) in
          let y = Bounds.y source +. (Bounds.height source /. 2.) in
          x, y
      in
      Raylib.Vector2.create x y
    in
    let dest = Bounds.Expert.to_rect_account_for_origin dest in
    Raylib.draw_texture_pro
      texture
      (Bounds.to_rect source)
      dest
      origin
      rotation
      color_tint
  ;;
end

module Smooth = struct
  let float_of_time_span = Time_ns.Span.to_sec

  let lerp ~current ~target ~c ~delta_time =
    let delta_time = float_of_time_span delta_time in
    let pct = 1. -. Float.(c ** delta_time) in
    current +. ((target -. current) *. pct)
  ;;

  let drag ~current ~c ~delta_time =
    let delta_time = float_of_time_span delta_time in
    current *. Float.(c ** delta_time)
  ;;
end
