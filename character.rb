require 'ruby2d'

# class Character
#     attr_accessor :current_animation, :current_direction, :clip_height, :clip_width, :x, :y,
#         :width, :height, :texture, :sprite, :time

#     def initialize
#         @width = 100
#         @height = 100
#         @x = 0
#         @y = 0
#         @clip_width = 0
#         @clip_height = 0
#         @texture = nil
#         @current_animation = AnimationType::IDLE
#         @current_direction = AnimationDirection::FORWARD
#     end

#     def set_sprite
#         @sprite = Sprite.new(
#             @texture,
#             width: @width, height: @height,
#             x: @x, y: @y,
#             clip_width: @clip_width, clip_height: @clip_height,
#             time: @time,
#             loop: true,
#         )
#     end

#     def play
#         @sprite.play
#     end
#     def set_time(new_time)
#         @time = new_time
#     end

#     def set_position(new_x, new_y)
#         @x = new_x
#         @y = new_y
#     end

#     def set_clip(new_width, new_height)
#         @clip_width = new_width
#         @clip_height = new_height
#     end

#     def set_size(new_width, new_height)
#         @width = new_width
#         @height = new_height
#     end

#     def set_texture(new_texture)
#         @texture = new_texture
#     end

#     def update_animation(new_animation, new_direction)
#         @current_animation = new_animation if AnimationType.constants.include?(new_animation)
#         @current_direction = new_direction if AnimationDirection.constants.include?(new_direction)
#     end
# end
