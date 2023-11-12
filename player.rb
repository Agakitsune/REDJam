require 'ruby2d'
require './Rect.rb'

class Player
    attr_accessor :square, :inventory, :size

    def initialize(x, y, size)
        @square = Rect.new(x, y, size, size)
        @size = size
        @inventory = {}
    end

    def draw
        @square.draw
    end
end
