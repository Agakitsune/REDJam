require 'ruby2d'
require './menuState'
require './gameplayState'
require './gameOverState'
require './character.rb'
require './src/SpriteSheet.rb'
require './src/Vector.rb'
require './src/OriginSprite.rb'
require './src/Bullet.rb'
require './src/Weapon.rb'

set title: 'ruby2dGame'
set width: 800
set height: 600

currentState = MenuState.new

update do
    currentState.update
end

on :key_down do |event|
    case event.key
        when 'left'
            if currentState.stateName == 'Menu'
                puts 'u wot m8 1'
            else
                Window.clear    
                currentState = MenuState.new
            end
        when 'right'
            if currentState.stateName == 'Gameplay'
                puts 'u wot m8 2'
            else
                Window.clear    
                currentState = GameplayState.new
            end
        when 'up'
            if currentState.stateName == 'GameOver'
                puts 'u wot m8 3'
            else
                Window.clear    
                currentState = GameOverState.new
            end

# Define a square shape.
@square = Square.new(x: 0, y: 0, size: 64, color: 'blue')
@square.color.opacity = 0

@wall = Square.new(x: 0, y: 100, size: 100, color: 'red')

set width: 1200, height: 720

d = Vector2.down().mul(100)
r = Vector2.right().mul(100)

@scaleX = 3
@scaleY = 3

@random = Random.new()

def rotate(x, y, angle)
    return Vector2.new(x * Math.cos(angle) - y * Math.sin(angle), x * Math.sin(angle) + y * Math.cos(angle))
end

def rotateOrigin(x, y, angle, originX, originY)
    return rotate(x - originX, y - originY, angle)
end

@player = SpriteSheet("./assets/Stalin.png", width: 32 * @scaleX, height: 32 * @scaleY, frame_width: 32, frame_height: 32, animations: {
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
    roll_front_A: {
        y: 8,
        length: 4,
        time: [50, 50, 50, 120]
    },
    roll_front_B: {
        y: 8,
        offset: 4,
        length: 5,
        time: 80
    },
    roll_sidefront_A: {
        y: 9,
        length: 4,
        time: [50, 50, 50, 120]
    },
    roll_sidefront_B: {
        y: 9,
        offset: 4,
        length: 5,
        time: 80
    },
    roll_back_A: {
        y: 10,
        length: 4,
        time: [50, 50, 50, 120]
    },
    roll_back_B: {
        y: 10,
        offset: 4,
        length: 5,
        time: 80
    },
    roll_sideback_A: {
        y: 11,
        length: 4,
        time: [50, 50, 50, 120]
    },
    roll_sideback_B: {
        y: 11,
        offset: 4,
        length: 5,
        time: 80
    },
    idle_light_front: {
        y: 12,
        length: 6
    },
    idle_light_sidefront: {
        y: 13,
        length: 4,
        time: 150
    },
    idle_light_back: {
        y: 14,
        length: 6
    },
    idle_light_sideback: {
        y: 15,
        length: 4,
        time: 150
    },
    walk_light_front: {
        y: 16,
        length: 6
    },
    walk_light_sidefront: {
        y: 17,
        length: 6
    },
    walk_light_back: {
        y: 18,
        length: 6
    },
    walk_light_sideback: {
        y: 19,
        length: 6
    },
})

@revolver = OriginSprite.new(
    "./assets/weapon/revolver.png",
    clip_width: 24,
    clip_height: 16,
    width: 24 * @scaleX, height: 16 * @scaleY,
    animations: {
        idle_left: [
            {
                x: 0,
                y: 0,
                width: 24,
                height: 16
            }
        ],
        idle_right: [
            {
                x: 0,
                y: 16,
                width: 24,
                height: 16
            }
        ],
        reload: [
            {
                x: 0,
                y: 32,
                width: 24,
                height: 16,
                time: 70
            },
            {
                x: 0,
                y: 48,
                width: 24,
                height: 16,
                time: 70
            },
            {
                x: 0,
                y: 64,
                width: 24,
                height: 16,
                time: 70
            },
        ]
    }
)

@weapon = Weapon.new(@revolver, originY: 10, hand1: Vector2.new(4, 0), cooldown: 10)

@hand = Image.new(
    "./assets/hand.png",
    width: 4 * @scaleX, height: 4 * @scaleY
)

@bullet = Image.new(
    "./assets/ally_bullet.png",
    width: 8 * @scaleX, height: 8 * @scaleX
)

@bullets = []

# Define the initial speed (and direction).
@velocity = Vector2.new(0, 0)

@walk = false
@roll = false
@rollVelocity = Vector2.new(0, 0)
@rollInvicible = false
@rollMouse = Vector2.new(0, 0)

@light_weapon = false
@heavy_weapon = false

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
    if not @roll
        case event.button
            when :right
                @roll = true
                @rollInvicible = true
                @rollMouse = Vector2.vectorize(@player.x + 16 * @scaleX, @player.y + 16 * @scaleY, Window.mouse_x, Window.mouse_y)
            when :left
                @weapon.shoot()            
        end
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

light_anim = [
    {
        animation: :idle_light_front,
    },
    {
        animation: :idle_light_sidefront,
    },
    {
        animation: :idle_light_sideback,
    },
    {
        animation: :idle_light_back,
    },
    {
        animation: :idle_light_sideback,
        flip: :horizontal
    },
    {
        animation: :idle_light_sidefront,
        flip: :horizontal
    },
    {
        animation: :idle_light_front,
        flip: :horizontal
    },
    {
        animation: :idle_light_back,
        flip: :horizontal
    },
]

walk_light_anim = [
    {
        animation: :walk_light_front,
    },
    {
        animation: :walk_light_sidefront,
    },
    {
        animation: :walk_light_sideback,
    },
    {
        animation: :walk_light_back,
    },
    {
        animation: :walk_light_sideback,
        flip: :horizontal
    },
    {
        animation: :walk_light_sidefront,
        flip: :horizontal
    },
    {
        animation: :walk_light_front,
        flip: :horizontal
    },
    {
        animation: :walk_light_back,
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
        animation: :roll_front_A
    },
    {
        animation: :roll_sidefront_A
    },
    {
        animation: :roll_sideback_A
    },
    {
        animation: :roll_back_A
    },
    {
        animation: :roll_sideback_A,
        flip: :horizontal
    },
    {
        animation: :roll_sidefront_A,
        flip: :horizontal
    },
]

@weapon.onShoot do
    shoot = Vector2.vectorize(@player.x + 16 * @scaleX, @player.y + 26 * @scaleY, Window.mouse_x, Window.mouse_y)
    angle = Math.acos(shoot.normalize().dot(r.normalize()))
    if Window.mouse_y < (@player.y + 26 * @scaleY)
        angle *= -1
    end
    if Window.mouse_x < (@player.x + 16 * @scaleX)
        out = rotateOrigin(20 * @scaleX, 5 * @scaleY, angle, 0, 0)
    else
        out = rotateOrigin(20 * @scaleX, -5 * @scaleY, angle, 0, 0)
    end
    angle *= 180 / Math::PI
    angle += @random.rand(17) - 9
    angle *= Math::PI / 180
    @bullets.append(Bullet.new(@bullet, @player.x + 16 * @scaleX + out.x, @player.y + 26 * @scaleY + out.y, angle, 10))
end

update do
    clear

    @light_weapon = @weapon.isLight?

    if Window.mouse_x < (@player.x + 16 * @scaleX)
        anchorX = 11 * @scaleX
    else
        anchorX = 20 * @scaleX
    end

    vec = Vector2.vectorize(@player.x + 16 * @scaleX, @player.y + 16 * @scaleY, Window.mouse_x, Window.mouse_y)
    shoot = Vector2.vectorize(@player.x + 16 * @scaleX, @player.y + 26 * @scaleY, Window.mouse_x, Window.mouse_y)
    rollVec = Vector2.vectorize(@player.x + 16 * @scaleX, @player.y + 16 * @scaleY, @player.x + 16 * @scaleX + @rollVelocity.x * 100, @player.y + 16 * @scaleY + @rollVelocity.y * 100)

    vec.drawAt(@player.x + 16 * @scaleX, @player.y + 16 * @scaleY, color: 'red')
    d.drawAt(@player.x + 16 * @scaleX, @player.y + 16 * @scaleY, color: 'blue')
    rollVec.drawAt(@player.x + 16 * @scaleX, @player.y + 16 * @scaleY, color: 'green')

    angle = Math.acos(shoot.normalize().dot(r.normalize())) * 180 / Math::PI
    if Window.mouse_y < (@player.y + 26 * @scaleY)
        angle *= -1
    end

    if Window.mouse_x < (@player.x + 16 * @scaleX)
        weaponSymbol = :idle_left
        weaponLoop = true
        weaponOrigin = Vector2.new(@weapon.width, @weapon.originY)
        weaponAngle = angle - 180
    else
        weaponSymbol = :idle_right
        weaponLoop = true
        weaponOrigin = Vector2.new(0, @weapon.originY)
        weaponAngle = angle
    end
    
    weaponX = @player.x + anchorX
    weaponY = @player.y + 26 * @scaleY

    @hand.x = @player.x + anchorX - 2 * @scaleX + Math.cos(angle * Math::PI / 180) * @weapon.firstHand().x * @scaleX
    @hand.y = @player.y + 26 * @scaleY - 2 * @scaleY + Math.sin(angle * Math::PI / 180) * @weapon.firstHand().x * @scaleX

    index = 0
    if @roll
        dot = @rollVelocity.normalize().dot(d.normalize())
    else
        dot = vec.normalize().dot(d.normalize())
    end
    if (dot > 0.71)
        if Window.mouse_x > (@player.x + 16 * @scaleX) and @light_weapon and not @roll
            index = 6
        else
            index = 0
        end
    elsif (dot >= 0)
        if @roll
            if @rollVelocity.x > 0
                index = 1
            else
                index = 5
            end
        else
            if Window.mouse_x > (@player.x + 16 * @scaleX)
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
            if Window.mouse_x > (@player.x + 16 * @scaleX)
                index = 2
            else
                index = 4
            end
        end
    elsif (dot >= -1)
        index = 3
    end

    if @roll and @rollInvicible
        @velocity = @rollVelocity
        @player.play animation: roll_anim[index][:animation], loop: false, flip: roll_anim[index][:flip] || :none do
            nextSym = (roll_anim[index][:animation].to_s.chop() + "B").to_sym
            puts "PhaseB"
            @rollInvicible = false
            @player.play animation: nextSym, loop: false, flip: roll_anim[index][:flip] || :none do
                puts "done"
                @roll = false
            end
        end
    elsif @walk and not @roll
        if @light_weapon
            @player.play animation: walk_light_anim[index][:animation], loop: true, flip: :none
        else
            @player.play animation: walk_anim[index][:animation], loop: true, flip: walk_anim[index][:flip] || :none
        end
    elsif not @roll
        if @light_weapon
            if Window.mouse_x > (@player.x + 16 * @scaleX)
                @player.play animation: light_anim[index][:animation], loop: true, flip: :none
            else
                @player.play animation: light_anim[index][:animation], loop: true, flip: :horizontal
            end
        else
            @player.play animation: idle_anim[index][:animation], loop: true, flip: idle_anim[index][:flip] || :none
        end
    else
        @velocity = @rollVelocity
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

    @velocity = @velocity.normalize().mul(4.0)

    if @roll and @rollInvicible
        @velocity = @velocity.mul(2)
    elsif not @rollInvicible and @roll
        @velocity = @velocity.mul(0.95)
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

    @weapon.update
    @bullets.each do |bullet|
        bullet.update
        bullet.draw
    end

    @player.add

    if @light_weapon and not @roll
        @weapon.play animation: weaponSymbol, loop: weaponLoop
        @weapon.draw(x: weaponX, y: weaponY, originX: weaponOrigin.x, originY: weaponOrigin.y, angle: weaponAngle, scaleX: @scaleX, scaleY: @scaleY)
        @hand.add
    end
end

show
