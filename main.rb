require 'ruby2d'

require './src/Map.rb'

set width: 960
set height: 540

# Define the initial speed (and direction).
@x_speed = 0
@y_speed = 0

@speed = 3.0

@square = Rectangle.new(x: 100, y: 100, width: 15 * 1.5, height: 5 * 1.5, color: 'blue')
# @walls = [
#     Rectangle.new(x: 0, y: 1, width: 1, height: 9, color: 'red'),
#     Rectangle.new(x: 1, y: 3, width: 7, height: 1, color: 'red'),
#     Rectangle.new(x: 8, y: 2, width: 1, height: 4, color: 'red'),
#     Rectangle.new(x: 8, y: 6, width: 4, height: 1, color: 'red'),
#     Rectangle.new(x: 12, y: 7, width: 3, height: 1, color: 'red'),
#     Rectangle.new(x: 15, y: 0, width: 1, height: 7, color: 'red'),
#     # Rectangle.new(x: 32, y: 144, width: 64, height: 64, color: 'red'),
# ]

@walls = Map('./assets/Collide.csv')

@walls.each do |wall|
    wall.x *= 18 * 1.5
    wall.y *= 18 * 1.5
    wall.width *= 18 * 1.5
    wall.height *= 18 * 1.5
end

@map = Image.new('./assets/Map.png',
    width: 1800 * 1.5, height: 1800 * 1.5
)

@mapOver = Image.new('./assets/MapOver.png',
    width: 1800 * 1.5, height: 1800 * 1.5
)

@shadow = Image.new('./assets/shadow.png',
    width: 15 * 1.5, height: 5 * 1.5
)

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

@shadow.x = Window.width / 2
@shadow.y = Window.height / 2
@square.x = Window.width / 2
@square.y = Window.height / 2

@offsetX = 0
@offsetY = 0

update do
    clear

    # if @square.x + @offsetX + @x_speed < 0
    #     @square.x + @offsetX = 0
    #     @x_speed = 0
    # elsif @square.x + @offsetX + @x_speed > (Window.width - @square.width)
    #     @square.x + @offsetX = Window.width - @square.width
    #     @x_speed = 0
    # end

    # if @square.y + @offsetY + @y_speed < 0
    #     @square.y + @offsetY = 0
    #     @y_speed = 0
    # elsif @square.y + @offsetY + @y_speed > (Window.height - @square.height)
    #     @square.y + @offsetY = Window.height - @square.height
    #     @y_speed = 0
    # end

    playerX = (@square.x + @offsetX)
    playerY = (@square.y + @offsetY)
    playerHeight = @square.height
    playerWidth = @square.width

    # puts playerX
    # puts playerY

    @walls.each do |wall|

        checkY = playerY + playerHeight > wall.y && playerY < wall.y + wall.height
        checkX = playerX + playerWidth > wall.x && playerX < wall.x + wall.width

        above = playerY + playerHeight <= wall.y
        below = playerY >= wall.y + wall.height
        left = playerX + playerWidth <= wall.x
        right = playerX >= wall.x + wall.width

        if checkX || checkY
            if above
                if playerY + playerHeight + @y_speed > wall.y
                    @square.color = 'purple'
                    playerY = wall.y - playerHeight
                    @y_speed = 0
                else
                    @square.color = 'yellow'
                end
            elsif below
                if playerY + @y_speed < wall.y + wall.height
                    @square.color = 'purple'
                    playerY = wall.y + wall.height
                    @y_speed = 0
                else
                    @square.color = 'green'
                end
            elsif left
                if playerX + playerWidth + @x_speed > wall.x
                    @square.color = 'purple'
                    playerX = wall.x - playerWidth
                    @x_speed = 0
                else
                    @square.color = 'red'
                end
            elsif right
                if playerX + @x_speed < wall.x + wall.width
                    @square.color = 'purple'
                    playerX = wall.x + wall.width
                    @x_speed = 0
                else
                    @square.color = 'orange'
                end
            end
        else
            @square.color = 'blue'
        end
    end

    @map.x -= @x_speed
    @map.y -= @y_speed
    @mapOver.x -= @x_speed
    @mapOver.y -= @y_speed

    @offsetX += @x_speed
    @offsetY += @y_speed

    @x_speed = 0
    @y_speed = 0

    @map.draw(x: @map.x, y: @map.y)

    @shadow.draw(x: @square.x, y: @square.y)

    @mapOver.draw(x: @map.x, y: @map.y)

    Rectangle.draw(x: @square.x, y: @square.y, width: @square.width, height: @square.height, color: [@square.color] * 4)

    @walls.each do |wall|
        Rectangle.draw(x: @map.x + wall.x, y: @map.y + wall.y, width: wall.width, height: wall.height, color: [wall.color] * 4)
    end

end

show
