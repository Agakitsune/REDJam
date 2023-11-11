require 'ruby2d'
require './character.rb'

# Define a square shape.
@square = Square.new(x: 10, y: 10, size: 50, color: 'blue')
@wall = Square.new(x: 0, y: 100, size: 2, color: 'red')

set width: 1200, height: 720

@player = Sprite.new(
    'assets/PilotIdle.png',
    # x: 550, y: 450,
    # loop: true,
    # time: 300,
    width: 15, height: 22,
    clip_width: 15,
    clip_height: 22,
    animations: {
        # idle: [
        #     {
        #         x: 0, y: 0,
        #         width: 15, height: 22,
        #     },
        #     {
        #         x: 15, y: 0,
        #         width: 15, height: 22,
        #     },
        #     {
        #         x: 30, y: 0,
        #         width: 15, height: 22,
        #     },
        #     {
        #         x: 45, y: 0,
        #         width: 15, height: 22,
        #     },
        #     {
        #         x: 60, y: 0,
        #         width: 15, height: 22,
        #     },
        #     {
        #         x: 75, y: 0,
        #         width: 15, height: 22,
        #     },
        # ],
        idle_left: [
            {
                x: 0, y: 22,
                width: 15, height: 22,
                time: 300
            },
            {
                x: 15, y: 22,
                width: 15, height: 22,
                time: 300,
            },
            {
                x: 30, y: 22,
                width: 15, height: 22,
                time: 300
            },
            {
                x: 45, y: 22,
                width: 15, height: 22,
                time: 300
            }
        ]
    }
)

FORWARD_IDLE = 0..5
LEFT_IDLE = 6..9

@player.play(animation: :idle_left, loop: true)
# Define the initial speed (and direction).
@x_speed = 0
@y_speed = 0

@speed = 2

# Define what happens when a specific key is pressed.
# Each keypress influences on the  movement along the x and y axis.
on :key_held do |event|
    case event.key
    when 'a'
        @x_speed = -@speed
    when 'd'
        @x_speed = @speed
    when 'w'
        @y_speed = -@speed
    when 's'
        @y_speed = @speed
    end
end

update do
    if @square.x < 0
        @square.x = 0
    elsif @square.x > (Window.width - @square.size)
        @square.x = Window.width - @square.size
    end

    if @square.y < 0
        @square.y = 0
    elsif @square.y > (Window.height - @square.size)
        @square.y = Window.height - @square.size
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
    @player.x += @x_speed
    @player.y += @y_speed
    @x_speed = 0
    @y_speed = 0
    @player.play
end

show

# @path="assets/PilotIdle.png",
# @x=550,
# @y=250,
# @z=0,
# @rotate=0,
# @color=#<Ruby2D::Color:0x00007f3a463c3070 @r=1.0, @g=1.0, @b=1.0, @a=1.0>,
# @width=50,
# @height=100,
# @flip=nil,
# @loop=true,
# @frame_time=400,
# @animations={:default=>0..4},
# @current_frame=0,
# @texture=#<Ruby2D::Texture:0x00007f3a463c2f30 @pixel_data=#<Object:0x00007f3a463ea990>,
# @width=100,
# @height=104,
# @texture_id=0>,
# @img_width=100,
# @img_height=104,
# @clip_x=0, @clip_y=0, @clip_width=17, @clip_height=23,
# @start_time=0.0,
# @playing=false,
# @last_frame=0,
# @done_proc=nil,
# @defaults={:animation=>:default, :frame=>0, :frame_time=>400,
# :clip_x=>0, :clip_y=>0, :clip_width=>17, :clip_height=>23, :loop=>true}>