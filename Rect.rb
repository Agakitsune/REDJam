require 'ruby2d'

class Rect
    attr_accessor :x, :y, :height, :width

    def initialize(x, y, width, height)
        @x = x
        @y = y
        @height = height
        @width = width
        @color = 'red'
    end

    def setColor(color)
        @color = color
    end

    def draw
        Rectangle.new(x: @x, y: @y, width: @width, height: @height, color: @color)
    end
end