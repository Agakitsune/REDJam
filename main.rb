require 'ruby2d'

# Define a square shape.
@square = Square.new(x: 10, y: 10, size: 50, color: 'blue')
@wall = Square.new(x: 0, y: 100, size: 2, color: 'red')

# Define the initial speed (and direction).
@x_speed = 0
@y_speed = 0

@speed = 2

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
    end
end

update do
    if @square.x + @x_speed < 0
        @square.x = 0
        @x_speed = 0
    elsif @square.x + @x_speed > (Window.width - @square.size)
        @square.x = Window.width - @square.size
        @x_speed = 0
    end

    if @square.y + @y_speed < 0
        @square.y = 0
        @y_speed = 0
    elsif @square.y + @y_speed > (Window.height - @square.size)
        @square.y = Window.height - @square.size
        @y_speed = 0
    end

    checkY = @square.y + @square.height > @wall.y && @square.y < @wall.y + @wall.height
    checkX = @square.x + @square.width > @wall.x && @square.x < @wall.x + @wall.width

    above = @square.y + @square.height <= @wall.y
    below = @square.y >= @wall.y + @wall.height
    left = @square.x + @square.width <= @wall.x
    right = @square.x >= @wall.x + @wall.width

    if checkX || checkY
        if above
            if @square.y + @square.height + @y_speed > @wall.y
                @square.color = 'purple'
                @square.y = @wall.y - @square.height
                @y_speed = 0
            else
                @square.color = 'yellow'
            end
        elsif below
            if @square.y + @y_speed < @wall.y + @wall.height
                @square.color = 'purple'
                @square.y = @wall.y + @wall.height
                @y_speed = 0
            else
                @square.color = 'green'
            end
        elsif left
            if @square.x + @square.width + @x_speed > @wall.x
                @square.color = 'purple'
                @square.x = @wall.x - @square.width
                @x_speed = 0
            else
                @square.color = 'red'
            end
        elsif right
            if @square.x + @x_speed < @wall.x + @wall.width
                @square.color = 'purple'
                @square.x = @wall.x + @wall.width
                @x_speed = 0
            else
                @square.color = 'orange'
            end
        end
    else
        @square.color = 'blue'
    end

    @square.x += @x_speed
    @square.y += @y_speed
    @x_speed = 0
    @y_speed = 0

end

show
