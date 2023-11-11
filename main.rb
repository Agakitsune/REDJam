require 'ruby2d'

set width: 960
set height: 540

# Define the initial speed (and direction).
@x_speed = 0
@y_speed = 0

@speed = 2.6

tileset = Tileset.new(
    './assets/sandbox.png',
    tile_width: 16,
    tile_height: 16,
    padding: 0,
    spacing: 0,
    scale: 2
)

# TILESET DE 80x45

tileset.define_tile('white', 0, 0)
tileset.define_tile('black', 0, 1)
tileset.define_tile('white_wall_top', 1, 0)
tileset.define_tile('black_wall_top', 1, 1)
tileset.define_tile('white_wall_left', 1, 0, rotate: -90)
tileset.define_tile('black_wall_left', 1, 1, rotate: -90)
tileset.define_tile('white_wall_down', 1, 0, rotate: 180)
tileset.define_tile('black_wall_down', 1, 1, rotate: 180)
tileset.define_tile('white_wall_right', 1, 0, rotate: 90)
tileset.define_tile('black_wall_right', 1, 1, rotate: 90)
tileset.define_tile('white_corner_topleft', 2, 0)
tileset.define_tile('black_corner_topleft', 2, 1)
tileset.define_tile('white_corner_topright', 2, 0, rotate: 90)
tileset.define_tile('black_corner_topright', 2, 1, rotate: 90)
tileset.define_tile('white_corner_bottomright', 2, 0, rotate: 180)
tileset.define_tile('black_corner_bottomright', 2, 1, rotate: 180)
tileset.define_tile('white_corner_bottomleft', 2, 0, rotate: -90)
tileset.define_tile('black_corner_bottomleft', 2, 1, rotate: -90)

tileset.set_tile('white_corner_topleft', [
    {x: 0, y: 0}
])

tileset.set_tile('black_wall_top', [
    {x: 32, y: 0}
])

tileset.set_tile('black_wall_left', [
    {x: 0, y: 32}
])

tileset.set_tile('white', [
    {x: 32, y: 32}
])

@square = Square.new(x: 10, y: 10, size: 32, color: 'blue')
@walls = [
    Rectangle.new(x: 0, y: 96, width: 64, height: 32, color: 'red'),
    Rectangle.new(x: 32, y: 144, width: 64, height: 64, color: 'red'),
]

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

    @walls.each do |wall|

        checkY = @square.y + @square.height > wall.y && @square.y < wall.y + wall.height
        checkX = @square.x + @square.width > wall.x && @square.x < wall.x + wall.width

        above = @square.y + @square.height <= wall.y
        below = @square.y >= wall.y + wall.height
        left = @square.x + @square.width <= wall.x
        right = @square.x >= wall.x + wall.width

        if checkX || checkY
            if above
                if @square.y + @square.height + @y_speed > wall.y
                    @square.color = 'purple'
                    @square.y = wall.y - @square.height
                    @y_speed = 0
                else
                    @square.color = 'yellow'
                end
            elsif below
                if @square.y + @y_speed < wall.y + wall.height
                    @square.color = 'purple'
                    @square.y = wall.y + wall.height
                    @y_speed = 0
                else
                    @square.color = 'green'
                end
            elsif left
                if @square.x + @square.width + @x_speed > wall.x
                    @square.color = 'purple'
                    @square.x = wall.x - @square.width
                    @x_speed = 0
                else
                    @square.color = 'red'
                end
            elsif right
                if @square.x + @x_speed < wall.x + wall.width
                    @square.color = 'purple'
                    @square.x = wall.x + wall.width
                    @x_speed = 0
                else
                    @square.color = 'orange'
                end
            end
        else
            @square.color = 'blue'
        end
    end

    @square.x += @x_speed
    @square.y += @y_speed
    @x_speed = 0
    @y_speed = 0

end

show
