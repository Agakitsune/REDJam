require 'ruby2d'
require './player.rb'
require './item.rb'

# Define a square shape.

@player = Player.new(10, 10, 50)
@player.square.setColor('blue')
@wall = Square.new(x: 0, y: 100, size: 2, color: 'red')

# Handle all items on the maps
@items = [
    Item.new('apple', 100, 100, 30, 30),
    Item.new('apple', 200, 200, 20, 20),
    Item.new('apple', 300, 300, 10, 10)
]

# Define the initial speed (and direction).
@x_speed = 0
@y_speed = 0

@collect = false
@drop = false

@speed = 2

# add an Item in player's inventory
def addItem(item)
    if @player.inventory.key?(item.name) == true
        @player.inventory[item.name].append(item)
    else
        @player.inventory[item.name] = [item]
    end
end

# remove an Item in player's inventory
def removeElement(key)
    if @player.inventory.key?(key) == true
        if @player.inventory[key].empty?
            @player.inventory.delete(key)
        else
            @items.append(@player.inventory[key].pop)
        end
    end
end

# Define what happens when a specific key is pressed.
# Each keypress influences on the  movement along the x and y axis.
on :key_held do |event|
    
    if event.key == 'a'
        @x_speed = -@speed
    elsif event.key == 'd'
        @x_speed = @speed
    elsif event.key == 'w'
        @y_speed = -@speed
    elsif event.key == 's'
        @y_speed = @speed
    elsif event.key == 'e'
        @collect = true
    elsif event.key == 'r' && !@drop
        removeElement('apple')
        @drop = true
    end
end

on :key_up do |event|
    if event.key == 'r'
        @drop = false
    end
end

update do
    @player.inventory.each do |key, value|
        value.each do |myItem|
            myItem.rect.x = @player.square.x
            myItem.rect.y = @player.square.y
        end
    end

    if @player.square.x + @x_speed < 0
        @player.square.x = 0
        @x_speed = 0
    elsif @player.square.x + @x_speed > (Window.width - @player.size)
        @player.square.x = Window.width - @player.size
        @x_speed = 0
    end

    if @player.square.y + @y_speed < 0
        @player.square.y = 0
        @y_speed = 0
    elsif @player.square.y + @y_speed > (Window.height - @player.size)
        @player.square.y = Window.height - @player.size
        @y_speed = 0
    end

    checkY = @player.square.y + @player.square.height > @wall.y && @player.square.y < @wall.y + @wall.height
    checkX = @player.square.x + @player.square.width > @wall.x && @player.square.x < @wall.x + @wall.width

    @items.each do |item|
        checkItemX = @player.square.x + @player.square.width > item.rect.x && @player.square.x < item.rect.x + item.rect.width
        checkItemY = @player.square.y + @player.square.height > item.rect.y && @player.square.y < item.rect.y + item.rect.height
        if checkItemX && checkItemY && @collect
            addItem(item)
            @items.delete(item)
        end
    end

    above = @player.square.y + @player.square.height <= @wall.y
    below = @player.square.y >= @wall.y + @wall.height
    left = @player.square.x + @player.square.width <= @wall.x
    right = @player.square.x >= @wall.x + @wall.width

    if checkX || checkY
        if above
            if @player.square.y + @player.square.height + @y_speed > @wall.y
                @player.square.y = @wall.y - @player.square.height
                @y_speed = 0
            end
        elsif below
            if @player.square.y + @y_speed < @wall.y + @wall.height
                @player.square.y = @wall.y + @wall.height
                @y_speed = 0
            end
        elsif left
            if @player.square.x + @player.square.width + @x_speed > @wall.x
                @player.square.x = @wall.x - @player.square.width
                @x_speed = 0
            end
        elsif right
            if @player.square.x + @x_speed < @wall.x + @wall.width
                @player.square.x = @wall.x + @wall.width
                @x_speed = 0
            end
        end
    end

    Window.clear
    @player.draw
    @items.each do |item|
        item.draw
    end
    @player.square.x += @x_speed
    @player.square.y += @y_speed
    @x_speed = 0
    @y_speed = 0
    @collect = false
end

show
