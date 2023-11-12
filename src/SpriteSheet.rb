require 'ruby2d'

def SpriteSheet(path, width: nil, height: nil, frame_width: nil, frame_height: nil, animations: {})
    anime = {}
    animations.each do |key, value|
        lst = []
        y = value[:y] * frame_height

        offset = value[:offset] || 0

        for i in 0..value[:length] - 1
            x = (i + offset) * frame_width
            if value[:time].is_a?(Array)
                time = value[:time][i]
            else
                time = value[:time] || 100
            end
            lst << {
                x: x, y: y,
                width: frame_width, height: frame_height,
                time: time
            }
        end

        anime[key] = lst
    end

    sprite = Sprite.new(path, width: width, height: height, animations: anime)
    return sprite
end
