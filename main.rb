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

tileset.define_tile('black', 0, 1)
tileset.define_tile('white', 0, 0)

tileset.define_tile('black_wall_down', 1, 1)
tileset.define_tile('white_wall_down', 1, 0)

tileset.define_tile('black_wall_top', 2, 1)
tileset.define_tile('white_wall_top', 2, 0)

tileset.define_tile('black_wall_bottom', 2, 1, rotate: 180)
tileset.define_tile('white_wall_bottom', 2, 0, rotate: 180)

tileset.define_tile('black_wall_left', 2, 1, rotate: 90)
tileset.define_tile('white_wall_left', 2, 0, rotate: 90)

tileset.define_tile('black_wall_right', 2, 1, rotate: -90)
tileset.define_tile('white_wall_right', 2, 0, rotate: -90)

tileset.define_tile('black_corner_bottomleft', 3, 1)
tileset.define_tile('white_corner_bottomleft', 3, 0)

tileset.define_tile('black_corner_bottomright', 3, 1, rotate: -90)
tileset.define_tile('white_corner_bottomright', 3, 0, rotate: -90)

tileset.define_tile('black_corner_topright', 3, 1, rotate: 180)
tileset.define_tile('white_corner_topright', 3, 0, rotate: 180)

tileset.define_tile('black_corner_topleft', 3, 1, rotate: 90)
tileset.define_tile('white_corner_topleft', 3, 0, rotate: 90)

tileset.define_tile('black_border_bottomleft', 4, 1)
tileset.define_tile('white_border_bottomleft', 4, 0)

tileset.define_tile('black_border_bottomright', 4, 1, rotate: -90)
tileset.define_tile('white_border_bottomright', 4, 0, rotate: -90)

tileset.define_tile('black_border_topleft', 4, 1, rotate: 90)
tileset.define_tile('white_border_topleft', 4, 0, rotate: 90)

tileset.define_tile('black_border_topright', 4, 1, rotate: 180)
tileset.define_tile('white_border_topright', 4, 0, rotate: 180)

tileset.set_tile('black', [
    {x: 0, y: 0}
])

tileset.set_tile('white', [
    {x: 0, y: 32}
])

tileset.set_tile('black_wall_down', [
    {x: 32, y: 0}
])

tileset.set_tile('white_wall_down', [
    {x: 32, y: 32}
])

tileset.set_tile('black_wall_top', [
    {x: 64, y: 0}
])

tileset.set_tile('white_wall_top', [
    {x: 64, y: 32}
])

tileset.set_tile('black_wall_bottom', [
    {x: 98, y: 0}
])

tileset.set_tile('white_wall_bottom', [
    {x: 98, y: 32}
])

tileset.set_tile('black_wall_left', [
    {x: 130, y: 0}
])

tileset.set_tile('white_wall_left', [
    {x: 130, y: 32}
])

tileset.set_tile('black_wall_right', [
    {x: 162, y: 0}
])

tileset.set_tile('white_wall_right', [
    {x: 162, y: 32}
])

tileset.set_tile('black_corner_bottomleft', [
    {x: 194, y: 0}
])

tileset.set_tile('white_corner_bottomleft', [
    {x: 194, y: 32}
])

tileset.set_tile('black_corner_bottomright', [
    {x: 226, y: 0}
])

tileset.set_tile('white_corner_bottomright', [
    {x: 226, y: 32}
])

tileset.set_tile('black_corner_topright', [
    {x: 258, y: 0}
])

tileset.set_tile('white_corner_topright', [
    {x: 258, y: 32}
])

tileset.set_tile('black_corner_topleft', [
    {x: 290, y: 0}
])

tileset.set_tile('white_corner_topleft', [
    {x: 290, y: 32}
])

tileset.set_tile('black_border_bottomleft', [
    {x: 322, y: 0}
])

tileset.set_tile('white_border_bottomleft', [
    {x: 322, y: 32}
])

tileset.set_tile('black_border_bottomright', [
    {x: 354, y: 0}
])

tileset.set_tile('white_border_bottomright', [
    {x: 354, y: 32}
])

tileset.set_tile('black_border_topleft', [
    {x: 386, y: 0}
])

tileset.set_tile('white_border_topleft', [
    {x: 386, y: 32}
])

tileset.set_tile('black_border_topright', [
    {x: 418, y: 0}
])

tileset.set_tile('white_border_topright', [
    {x: 418, y: 32}
])

@square = Square.new(x: 100, y: 100, size: 32, color: 'blue')
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
