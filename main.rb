require 'ruby2d'
require './character.rb'
require './src/SpriteSheet.rb'
require './src/Vector.rb'

# Define a square shape.
@square = Square.new(x: 0, y: 0, size: 64, color: 'blue')
@square.color.opacity = 0

@wall = Square.new(x: 0, y: 100, size: 100, color: 'red')

set width: 1200, height: 720

@player = SpriteSheet("./assets/Stalin.png", width: 128, height: 128, frame_width: 32, frame_height: 32, animations: {
    idle_front: {
        y: 0,
        length: 6
    },
    idle_sidefront: {
        y: 1,
        length: 4,
        time: 150
    },
    idle_back: {
        y: 2,
        length: 6
    },
    idle_sideback: {
        y: 3,
        length: 4,
        time: 150
    },
    walk_front: {
        y: 4,
        length: 6
    },
    walk_sidefront: {
        y: 5,
        length: 6
    },
    walk_back: {
        y: 6,
        length: 6
    },
    walk_sideback: {
        y: 7,
        length: 6
    },
    roll_front: {
        y: 8,
        length: 9
    },
    roll_sidefront: {
        y: 9,
        length: 9
    },
    roll_back: {
        y: 10,
        length: 9
    },
    roll_sideback: {
        y: 11,
        length: 9
    }
})

# @player.play animation: :roll_front, loop: true
# Define the initial speed (and direction).
@velocity = Vector2.new(0, 0)

@walk = false
@roll = false
@rollVelocity = Vector2.new(0, 0)
@rollMouse = Vector2.new(0, 0)

# Define what happens when a specific key is pressed.
# Each keypress influences on the  movement along the x and y axis.
on :key_held do |event|
    if not @roll
        case event.key
            when 'a'
                @velocity.x = -1
                @rollVelocity.x = -1
                @walk = true
            when 'd'
                @velocity.x = 1
                @rollVelocity.x = 1
                @walk = true
            when 'w'
                @velocity.y = -1
                @rollVelocity.y = -1
                @walk = true
            when 's'
                @velocity.y = 1
                @rollVelocity.y = 1
                @walk = true
        end
    end
end

on :mouse_down do |event|
    case event.button
        when :right
            @roll = true
            @rollMouse = Vector2.vectorize(@player.x + 64, @player.y + 64, Window.mouse_x, Window.mouse_y)
    end
end

idle_anim = [
    {
        animation: :idle_front,
    },
    {
        animation: :idle_sidefront,
    },
    {
        animation: :idle_sideback,
    },
    {
        animation: :idle_back,
    },
    {
        animation: :idle_sideback,
        flip: :horizontal
    },
    {
        animation: :idle_sidefront,
        flip: :horizontal
    },
]

walk_anim = [
    {
        animation: :walk_front,
    },
    {
        animation: :walk_sidefront,
    },
    {
        animation: :walk_sideback,
    },
    {
        animation: :walk_back,
    },
    {
        animation: :walk_sideback,
        flip: :horizontal
    },
    {
        animation: :walk_sidefront,
        flip: :horizontal
    },
]

roll_anim = [
    {
        animation: :roll_front,
    },
    {
        animation: :roll_sidefront,
    },
    {
        animation: :roll_sideback,
    },
    {
        animation: :roll_back,
    },
    {
        animation: :roll_sideback,
        flip: :horizontal
    },
    {
        animation: :roll_sidefront,
        flip: :horizontal
    },
]

d = Vector2.down().mul(100)

update do
    clear
    vec = Vector2.vectorize(@player.x + 64, @player.y + 64, Window.mouse_x, Window.mouse_y)
    rollVec = Vector2.vectorize(@player.x + 64, @player.y + 64, @player.x + 64 + @rollVelocity.x * 100, @player.y + 64 + @rollVelocity.y * 100)

    vec.drawAt(@player.x + 64, @player.y + 64, color: 'red')
    d.drawAt(@player.x + 64, @player.y + 64, color: 'blue')
    rollVec.drawAt(@player.x + 64, @player.y + 64, color: 'green')

    index = 0
    if @roll
        dot = @rollVelocity.normalize().dot(d.normalize())
    else
        dot = vec.normalize().dot(d.normalize())
    end
    if (dot > 0.71)
        index = 0
    elsif (dot >= 0)
        if @roll
            if @rollVelocity.x > 0
                index = 1
            else
                index = 5
            end
        else
            if Window.mouse_x > (@player.x + 64)
                index = 1
            else
                index = 5
            end
        end
    elsif (dot > -0.71)
        if @roll
            if @rollVelocity.x > 0
                index = 2
            else
                index = 4
            end
        else
            if Window.mouse_x > (@player.x + 64)
                index = 2
            else
                index = 4
            end
        end
    elsif (dot >= -1)
        index = 3
    end

    if @roll
        @velocity = @rollVelocity
        @player.play animation: roll_anim[index][:animation], loop: false, flip: roll_anim[index][:flip] || :none do
            @roll = false
        end
    elsif @walk
        @player.play animation: walk_anim[index][:animation], loop: true, flip: walk_anim[index][:flip] || :none
    else
        @player.play animation: idle_anim[index][:animation], loop: true, flip: idle_anim[index][:flip] || :none
    end

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
            if @square.y + @square.height + @velocity.y > @wall.y
                @square.y = @wall.y - @square.height
                @velocity.y = 0
            end
        elsif below
            if @square.y + @velocity.y < @wall.y + @wall.height
                @square.y = @wall.y + @wall.height
                @velocity.y = 0
            end
        elsif left
            if @square.x + @square.width + @velocity.x > @wall.x
                @square.x = @wall.x - @square.width
                @velocity.x = 0
            end
        elsif right
            if @square.x + @velocity.x < @wall.x + @wall.width
                @square.x = @wall.x + @wall.width
                @velocity.x = 0
            end
        end
    end

    @velocity = @velocity.normalize().mul(3.5)

    if @roll
        @velocity = @velocity.mul(1.5)
    end

    @square.x += @velocity.x
    @square.y += @velocity.y
    @player.x += @velocity.x
    @player.y += @velocity.y

    if @velocity.x == 0 && @velocity.y == 0
        @walk = false
    end

    if not @roll
        @rollVelocity.x = @velocity.x
        @rollVelocity.y = @velocity.y
    end

    @velocity.x = 0
    @velocity.y = 0

    @player.add
end

show
