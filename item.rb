require 'ruby2d'
require './Rect.rb'

class Item
    attr_reader :name, :rect

    def initialize(name, x, y, width, height)
        @rect = Rect.new(x, y, width, height)
        @name = name
    end

    def draw
        @rect.draw
    end
end