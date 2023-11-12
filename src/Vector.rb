require 'ruby2d'

class Vector2
    attr_accessor :x, :y

    def initialize(x, y)
        @x = x
        @y = y
    end

    def self.vectorize(x1, y1, x2, y2)
        return Vector2.new(x2 - x1, y2 - y1)
    end

    def self.zero()
        return Vector2.new(0, 0)
    end

    def self.one()
        return Vector2.new(1, 1)
    end

    def self.up()
        return Vector2.new(0, -1)
    end

    def self.down()
        return Vector2.new(0, 1)
    end

    def self.left()
        return Vector2.new(-1, 0)
    end

    def self.right()
        return Vector2.new(1, 0)
    end

    def self.add(a, b)
        return Vector2.new(a.x + b.x, a.y + b.y)
    end

    def self.sub(a, b)
        return Vector2.new(a.x - b.x, a.y - b.y)
    end

    def self.mul(a, b)
        return Vector2.new(a.x * b.x, a.y * b.y)
    end

    def self.div(a, b)
        return Vector2.new(a.x / b.x, a.y / b.y)
    end

    def self.scale(a, b)
        return Vector2.new(a.x * b, a.y * b)
    end

    def self.distance(a, b)
        return Math.sqrt((b.x - a.x) * (b.x - a.x) + (b.y - a.y) * (b.y - a.y))
    end

    def self.dot(a, b)
        return a.x * b.x + a.y * b.y
    end

    def self.normalize(a)
        len = a.length()
        return Vector2.new(a.x / len, a.y / len)
    end

    def self.angle(a, b)
        return Math.atan2(b.y - a.y, b.x - a.x)
    end

    def add(other)
        return Vector2.new(@x + other.x, @y + other.y)
    end

    def sub(other)
        return Vector2.new(@x - other.x, @y - other.y)
    end

    def mul(other)
        if other.is_a?(Numeric)
            return Vector2.new(@x * other, @y * other)
        end
        return Vector2.new(@x * other.x, @y * other.y)
    end

    def div(other)
        return Vector2.new(@x / other.x, @y / other.y)
    end

    def length()
        return Math.sqrt(@x * @x + @y * @y)
    end

    def normalize()
        len = self.length()
        if len == 0
            return Vector2.zero()
        end
        return Vector2.new(@x / len, @y / len)
    end

    def dot(other)
        return @x * other.x + @y * other.y
    end

    def to_s()
        return "(#{@x}, #{@y})"
    end

    def drawAt(x, y, color: 'white')
        Line.new(
            x1: x, y1: y,
            x2: x + @x, y2: y + @y,
            width: 2,
            color: color
        )
    end
end