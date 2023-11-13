
class Bullet

    def initialize(img, x, y, angle, speed)
        @img = img
        @x = x
        @y = y
        @angle = angle
        @speed = speed
    end

    def x
        @x - @img.width / 2
    end

    def y
        @y - @img.height / 2
    end

    def update
        @x += Math.cos(@angle) * @speed
        @y += Math.sin(@angle) * @speed
    end

    def draw
        x = @x - @img.width / 2
        y = @y - @img.height / 2
        @img.draw(x: x, y: y)
    end

    def out_of_bounds?
        if @x < 0 || @x > Window.width || @y < 0 || @y > Window.height
            return true
        end
        return false
    end
end