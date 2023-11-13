
$scaleX = 2.0
$scaleY = 2.0

def rotate(x, y, angle)
    return Vector2.new(x * Math.cos(angle) - y * Math.sin(angle), x * Math.sin(angle) + y * Math.cos(angle))
end

def rotateOrigin(x, y, angle, originX, originY)
    return rotate(x - originX, y - originY, angle)
end

on :key_held do |event|
    $controller = false
    if $currentState.stateName == "Gameplay" and not $roll
        case event.key
            when 'a'
                $velocity.x = -1
                $rollVelocity.x = -1
                $walk = true
            when 'd'
                $velocity.x = 1
                $rollVelocity.x = 1
                $walk = true
            when 'w'
                $velocity.y = -1
                $rollVelocity.y = -1
                $walk = true
            when 's'
                $velocity.y = 1
                $rollVelocity.y = 1
                $walk = true
        end
    end
end

on :mouse_down do |event|
    $controller = false
    if not $roll
        case event.button
            when :right
                if $walk
                    $roll = true
                    $rollInvicible = true
                    $rollMouse = Vector2.vectorize($player.x + 16 * $scaleX, $player.y + 16 * $scaleY, Window.mouse_x, Window.mouse_y)
                end
            when :left
                $weapon.shoot() if not $weapon.nil?
        end
    end
end

on :controller_button_down do |event|
    $controller = true
    if $currentState.stateName == "Gameplay"
        case event.button
            when :a
                if $walk
                    $roll = true
                    $rollInvicible = true
                    $rollMouse = Vector2.vectorize($player.x + 16 * $scaleX, $player.y + 16 * $scaleY, Window.mouse_x, Window.mouse_y)
                end
            when :right_shoulder
                $weapon.shoot() if not $weapon.nil?
        end
    end
end

$axis = {
    left_x: 0,
    left_y: 0,
    right_x: 0,
    right_y: 0
}

$controller = false

on :controller_axis do |event|
    $controller = true
    if $currentState.stateName == "Gameplay"
        case event.axis
            when :left_x
                if event.value.abs() > 0.1
                    $axis[:left_x] = event.value
                else
                    $axis[:left_x] = 0
                end
            when :left_y
                if event.value.abs() > 0.1
                    $axis[:left_y] = event.value
                else
                    $axis[:left_y] = 0
                end
            when :right_x
                if event.value.abs() > 0.1
                    $axis[:right_x] = event.value
                end
            when :right_y
                if event.value.abs() > 0.1
                    $axis[:right_y] = event.value
                end
        end
    end
end

class GameplayState
    def initialize
        @Name = "Gameplay";
        @uiScale = 6

        @positions = [10, 10 + 10 * @uiScale, 10 + 20 * @uiScale]

        @heart = Sprite.new('./assets/heart.png',
        width: 9 * @uiScale, height: 9 * @uiScale,
        clip_width: 9, clip_height: 9,
        animations: {
            full: [{
                x: 0,
                y: 0,
                width: 9,
                height: 9
            }],
            half: [{
                x: 0,
                y: 9,
                width: 9,
                height: 9
            }],
            empty: [{
                x: 0,
                y: 18,
                width: 9,
                height: 9
            }]
        },
        y: 20, x: @positions[2])

        @bar = Sprite.new('./assets/bar.png',
        width: 3 * @uiScale, height: 3 * @uiScale,
        clip_width: 3, clip_height: 3,
        animations: {
            begin: [{
                x: 0,
                y: 0,
                width: 3,
                height: 4
            }],
            filled: [{
                x: 3,
                y: 0,
                width: 3,
                height: 4
            }],
            empty: [{
                x: 6,
                y: 0,
                width: 3,
                height: 4
            }],
            end: [{
                x: 9,
                y: 0,
                width: 3,
                height: 4
            }]
        },
        y: 0, x: 0)

        @d = Vector2.down().mul(100)
        @r = Vector2.right().mul(100)

        @square = Rectangle.new(x: 100, y: 100, width: 15 * $scaleX, height: 5 * $scaleY, color: 'blue')

        @random = Random.new()

        $player = SpriteSheet("./assets/Stalin.png", width: 32 * $scaleX, height: 32 * $scaleY, frame_width: 32, frame_height: 32, animations: {
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

        @marin = SpriteSheet("./assets/Marin.png", width: 32 * $scaleX, height: 32 * $scaleY, frame_width: 32, frame_height: 32, animations: {
            idle_front: {
                y: 0,
                length: 4,
                time: 150
            },
            idle_sidefront: {
                y: 1,
                length: 4,
                time: 150
            },
            idle_back: {
                y: 2,
                length: 4,
                time: 150
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
            }
        })

        @revolver = OriginSprite.new(
            "./assets/weapon/revolver.png",
            clip_width: 24,
            clip_height: 16,
            width: 24 * $scaleX, height: 16 * $scaleY,
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

        $weapon = Weapon.new(@revolver, originY: 10, hand1: Vector2.new(4, 0), cooldown: 10)

        @hand = Image.new(
            "./assets/hand.png",
            width: 4 * $scaleX, height: 4 * $scaleY
        )

        @bullet = Image.new(
            "./assets/ally_bullet.png",
            width: 8 * $scaleX, height: 8 * $scaleX
        )

        @bullets = []

        # Define the initial speed (and direction).
        $velocity = Vector2.new(0, 0)

        @speed = 3.0

        @walls = Map('./assets/Collide.csv')

        # @walls = [@walls[0]]

        @walls.each do |wall|
            wall.x *= 18 * $scaleX
            wall.y *= 18 * $scaleY
            wall.width *= 18 * $scaleX
            wall.height *= 18 * $scaleY
        end

        @map = Image.new('./assets/Map.png',
            width: 1800 * $scaleX, height: 1800 * $scaleY
        )

        @mapOver = Image.new('./assets/MapOver.png',
            width: 1800 * $scaleX, height: 1800 * $scaleY
        )

        @shadow = Image.new('./assets/shadow.png',
            width: 15 * $scaleX, height: 5 * $scaleY
        )

        $walk = false
        $roll = false
        $rollVelocity = Vector2.new(0, 0)
        $rollInvicible = false
        $rollMouse = Vector2.new(0, 0)

        @light_weapon = false
        @heavy_weapon = false

        # Define what happens when a specific key is pressed.
        # Each keypress influences on the  movement along the x and y axis.
        

        @idle_anim = [
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

        @light_anim = [
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

        @walk_light_anim = [
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

        @walk_anim = [
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

        @roll_anim = [
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

        $weapon.onShoot do
            if $controller
                shoot = Vector2.vectorize($player.x + 16 * $scaleX, $player.y + 26 * $scaleY, $player.x + 16 * $scaleX + $axis[:right_x] * 100, $player.y + 16 * $scaleY + $axis[:right_y] * 100)
            else
                shoot = Vector2.vectorize($player.x + 16 * $scaleX, $player.y + 26 * $scaleY, Window.mouse_x, Window.mouse_y)
            end
            angle = Math.acos(shoot.normalize().dot(@r.normalize()))

            if $controller
                flipY = $axis[:right_y] < 0
                flipX = $axis[:right_x] < 0
            else
                flipY = Window.mouse_y < ($player.y + 26 * $scaleY)
                flipX = Window.mouse_x < ($player.x + 16 * $scaleX)
            end

            if flipY
                angle *= -1
            end
            if flipX
                out = rotateOrigin(20 * $scaleX, 5 * $scaleY, angle, 0, 0)
            else
                out = rotateOrigin(20 * $scaleX, -5 * $scaleY, angle, 0, 0)
            end
            angle *= 180 / Math::PI
            angle += @random.rand(17) - 9
            angle *= Math::PI / 180
            @bullets.append(Bullet.new(@bullet, $player.x + 16 * $scaleX + out.x, $player.y + 26 * $scaleY + out.y, angle, 6))
        end

        @shadow.x = Window.width / 2
        @shadow.y = Window.height / 2
        @square.x = Window.width / 2
        @square.y = Window.height / 2

        $player.x = Window.width / 2 - 8 * $scaleX
        $player.y = Window.height / 2 - 29 * $scaleY

        @offsetX = 0
        @offsetY = 0

        @enemySprite = []
        @enemy = []

        x = 0
        y = 0
        f = File.open('./assets/spawn.csv', "r").each_line do |line|
            line.split(",").each do |i|
                tile = nil
                if i.to_i != -1
                    @enemySprite << @marin.clone()
                    @enemy << {
                        x: x * 18 * $scaleX,
                        y: y * 18 * $scaleY,
                        hp: 5,
                        angle: 0
                }
                end
                x += 1
            end
            x = 0
            y += 1
        end

        @xp = 0
        @level = 0
        @xpToLevel = 10
        @xpBar = []

        (0...12).each do |i|
            @xpBar << @bar.clone
        end

        @xpBar[0].play animation: :begin, loop: false, flip: :none
        @xpBar[11].play animation: :end, loop: false, flip: :none
        (1...11).each do |i|
            @xpBar[i].play animation: :empty, loop: false, flip: :none
        end

        @atk = 1
        @speed = 1
        @hp = 6
        @hpMax = 6

        @atk_icon = Image.new('./assets/atk.png', width: 16 * @uiScale / 2, height: 16 * @uiScale / 2, x: 10, y: 10)
        @speed_icon = Image.new('./assets/speed.png', width: 16 * @uiScale / 2, height: 16 * @uiScale / 2, x: 10, y: 10 + 16 * $scaleY)
        @hp_icon = Image.new('./assets/hp.png', width: 16 * @uiScale / 2, height: 16 * @uiScale / 2, x: 10, y: 10 + 32 * $scaleY)
    end

    def update
        i = 0
        # while i < @hp
        #     @hearts[i] = Image.new('./heart.png', width: 50, height: 50, y: 20, x: @positions[i])
        #     i = i + 1
        # end
        # while i < 3
        #     @hearts[i] = Image.new('./eheart.png', width: 50, height: 50, y: 20, x: @positions[i])
        #     i = i + 1
        # end

        

        Window.clear

        @light_weapon = $weapon.isLight?

        if $controller
            anchor = $axis[:right_x] < 0
        else
            anchor = Window.mouse_x < ($player.x + 16 * $scaleX)
        end

        if anchor
            anchorX = 11 * $scaleX
        else
            anchorX = 20 * $scaleX
        end

        if $controller
            $velocity.x = $axis[:left_x]
            $velocity.y = $axis[:left_y]
            $rollVelocity.x = $axis[:left_x]
            $rollVelocity.y = $axis[:left_y]
            if $axis[:left_x] != 0 or $axis[:left_y] != 0
                $walk = true
            end
            vec = Vector2.vectorize($player.x + 16 * $scaleX, $player.y + 16 * $scaleY, $player.x + 16 * $scaleX + $axis[:right_x] * 100, $player.y + 16 * $scaleY + $axis[:right_y] * 100)
            shoot = Vector2.vectorize($player.x + 16 * $scaleX, $player.y + 26 * $scaleY, $player.x + 16 * $scaleX + $axis[:right_x] * 100, $player.y + 16 * $scaleY + $axis[:right_y] * 100)
            rollVec = Vector2.vectorize($player.x + 16 * $scaleX, $player.y + 16 * $scaleY, $player.x + 16 * $scaleX + $rollVelocity.x * 100, $player.y + 16 * $scaleY + $rollVelocity.y * 100)
        else
            vec = Vector2.vectorize($player.x + 16 * $scaleX, $player.y + 16 * $scaleY, Window.mouse_x, Window.mouse_y)
            shoot = Vector2.vectorize($player.x + 16 * $scaleX, $player.y + 26 * $scaleY, Window.mouse_x, Window.mouse_y)
            rollVec = Vector2.vectorize($player.x + 16 * $scaleX, $player.y + 16 * $scaleY, $player.x + 16 * $scaleX + $rollVelocity.x * 100, $player.y + 16 * $scaleY + $rollVelocity.y * 100)
        end

        angle = Math.acos(shoot.normalize().dot(@r.normalize())) * 180 / Math::PI
        if $controller
            if $axis[:right_y] < 0
                angle *= -1
            end
        else
            if Window.mouse_y < ($player.y + 26 * $scaleY)
                angle *= -1
            end
        end

        if $controller
            flip = $axis[:right_x] < 0
        else
            flip = Window.mouse_x < ($player.x + 16 * $scaleX)
        end

        if flip
            weaponSymbol = :idle_left
            weaponLoop = true
            weaponOrigin = Vector2.new($weapon.width, $weapon.originY)
            weaponAngle = angle - 180
        else
            weaponSymbol = :idle_right
            weaponLoop = true
            weaponOrigin = Vector2.new(0, $weapon.originY)
            weaponAngle = angle
        end
        
        weaponX = $player.x + anchorX
        weaponY = $player.y + 26 * $scaleY

        @hand.x = $player.x + anchorX - 2 * $scaleX + Math.cos(angle * Math::PI / 180) * $weapon.firstHand().x * $scaleX
        @hand.y = $player.y + 26 * $scaleY - 2 * $scaleY + Math.sin(angle * Math::PI / 180) * $weapon.firstHand().x * $scaleX

        index = 0
        if $roll
            dot = $rollVelocity.normalize().dot(@d.normalize())
        else
            dot = vec.normalize().dot(@d.normalize())
        end

        if $controller
            flip = $axis[:right_x] > 0
        else
            flip = Window.mouse_x > ($player.x + 16 * $scaleX)
        end

        if (dot > 0.71)
            if flip and @light_weapon and not $roll
                index = 6
            else
                index = 0
            end
        elsif (dot >= 0)
            if $roll
                if $rollVelocity.x > 0
                    index = 1
                else
                    index = 5
                end
            else
                if flip
                    index = 1
                else
                    index = 5
                end
            end
        elsif (dot > -0.71)
            if $roll
                if $rollVelocity.x > 0
                    index = 2
                else
                    index = 4
                end
            else
                if flip
                    index = 2
                else
                    index = 4
                end
            end
        elsif (dot >= -1)
            index = 3
        end

        if $roll and $rollInvicible
            $velocity = $rollVelocity
            $player.play animation: @roll_anim[index][:animation], loop: false, flip: @roll_anim[index][:flip] || :none do
                nextSym = (@roll_anim[index][:animation].to_s.chop() + "B").to_sym
                $rollInvicible = false
                $player.play animation: nextSym, loop: false, flip: @roll_anim[index][:flip] || :none do
                    $roll = false
                end
            end
        elsif $walk and not $roll
            if @light_weapon
                if flip
                    $player.play animation: @walk_light_anim[index][:animation], loop: true, flip: :none
                else
                    $player.play animation: @walk_light_anim[index][:animation], loop: true, flip: :horizontal
                end
            else
                $player.play animation: @walk_anim[index][:animation], loop: true, flip: @walk_anim[index][:flip] || :none
            end
        elsif not $roll
            if @light_weapon
                if flip
                    $player.play animation: @light_anim[index][:animation], loop: true, flip: :none
                else
                    $player.play animation: @light_anim[index][:animation], loop: true, flip: :horizontal
                end
            else
                $player.play animation: @idle_anim[index][:animation], loop: true, flip: @idle_anim[index][:flip] || :none
            end
        else
            $velocity = $rollVelocity
        end

        playerX = (@square.x + @offsetX)
        playerY = (@square.y + @offsetY)
        playerHeight = @square.height
        playerWidth = @square.width

        $velocity = $velocity.normalize().mul(4.0)

        if $roll and $rollInvicible
            $velocity = $velocity.mul(2)
        elsif not $rollInvicible and $roll
            $velocity = $velocity.mul(0.95)
        end

        $velocity = $velocity.mul(@speed)

        @walls.each do |wall|
            checkY = playerY + playerHeight > wall.y && playerY < wall.y + wall.height
            checkX = playerX + playerWidth > wall.x && playerX < wall.x + wall.width

            above = playerY + playerHeight <= wall.y
            below = playerY >= wall.y + wall.height
            left = playerX + playerWidth <= wall.x
            right = playerX >= wall.x + wall.width

            if checkX || checkY
                if above
                    if playerY + playerHeight + $velocity.y > wall.y
                        @square.color = 'purple'
                        playerY = wall.y - playerHeight
                        $velocity.y = 0
                    else
                        @square.color = 'yellow'
                    end
                elsif below
                    if (playerY + $velocity.y) < (wall.y + wall.height)
                        @square.color = 'purple'
                        playerY = wall.y + wall.height
                        $velocity.y = 0
                    else
                        @square.color = 'green'
                    end
                elsif left
                    if playerX + playerWidth + $velocity.x > wall.x
                        @square.color = 'purple'
                        playerX = wall.x - playerWidth
                        $velocity.x = 0
                    else
                        @square.color = 'red'
                    end
                elsif right
                    if playerX + $velocity.x < (wall.x + wall.width)
                        @square.color = 'purple'
                        playerX = wall.x + wall.width
                        $velocity.x = 0
                    else
                        @square.color = 'orange'
                    end
                end
            else
                @square.color = 'blue'
            end
        end

        @bullets.each do |bullet|
            bullet.update
            @walls.each do |wall|
                if wall.contains?(bullet.x + @offsetX, bullet.y + @offsetY)
                    @bullets.delete(bullet)
                end
            end
            @enemy.each_with_index do |enemy, index|
                box = Rectangle.new(x: enemy[:x] - 11 * $scaleX, y: enemy[:y] - 11 * $scaleY, width: 22 * $scaleX, height: 22 * $scaleY)
                box.remove
                if box.contains?(bullet.x + @offsetX, bullet.y + @offsetY)
                    @bullets.delete(bullet)
                    enemy[:hp] -= @atk
                    if enemy[:hp] <= 0
                        @enemy.delete(enemy)
                        @enemySprite.delete_at(index)
                        @xp += @random.rand(3) + 1
                        if @xp >= @xpToLevel
                            @xp -= @xpToLevel
                            @level += 1
                            @xpToLevel += 10
                            @atk += 1
                            @speed += 0.25
                            @hpMax += 2
                            @hp = @hpMax
                        end
                    end
                end
            end
        end

        @map.draw(x: @map.x, y: @map.y)

        @shadow.draw(x: @square.x, y: @square.y)
        if @light_weapon and not $roll
            $weapon.play animation: weaponSymbol, loop: weaponLoop
            $weapon.draw(x: weaponX, y: weaponY, originX: weaponOrigin.x, originY: weaponOrigin.y, angle: weaponAngle, scaleX: $scaleX, scaleY: $scaleY)
            @hand.draw(x: @hand.x, y: @hand.y)
        end
        $player.draw(x: $player.x, y: $player.y)

        @enemy.each_with_index do |e, index|
            pos = Vector2.new(e[:x] - @offsetX, e[:y] - @offsetY)
            toward = Vector2.vectorize(pos.x, pos.y, Window.width / 2, Window.height / 2)
            len = toward.length()
            
            enemyX = e[:x]
            enemyY = e[:y]
            enemyHeight = 22 * $scaleY
            enemyWidth = 22 * $scaleX

            dot = 0
            walk = false
            if (len < 600)
                walk = true
                toward = toward.normalize().mul(2)
                @walls.each do |wall|
                    checkY = enemyY + enemyHeight > wall.y && enemyY < wall.y + wall.height
                    checkX = enemyX + enemyWidth > wall.x && enemyX < wall.x + wall.width
        
                    above = enemyY + enemyHeight <= wall.y
                    below = enemyY >= wall.y + wall.height
                    left = enemyX + enemyWidth <= wall.x
                    right = enemyX >= wall.x + wall.width
        
                    if checkX || checkY
                        if above
                            if enemyY + enemyHeight + toward.y > wall.y
                                @square.color = 'purple'
                                enemyY = wall.y - enemyHeight
                                toward.y = 0
                            else
                                @square.color = 'yellow'
                            end
                        elsif below
                            if (enemyY + toward.y) < (wall.y + wall.height)
                                @square.color = 'purple'
                                enemyY = wall.y + wall.height
                                toward.y = 0
                            else
                                @square.color = 'green'
                            end
                        elsif left
                            if enemyX + enemyWidth + toward.x > wall.x
                                @square.color = 'purple'
                                enemyX = wall.x - enemyWidth
                                toward.x = 0
                            else
                                @square.color = 'red'
                            end
                        elsif right
                            if enemyX + toward.x < (wall.x + wall.width)
                                @square.color = 'purple'
                                enemyX = wall.x + wall.width
                                toward.x = 0
                            else
                                @square.color = 'orange'
                            end
                        end
                    else
                        @square.color = 'blue'
                    end
                end
                dot = toward.normalize().dot(@d.normalize())
                e[:angle] = Math.acos(toward.normalize().dot(@d.normalize())) * 180 / Math::PI
                pos = pos.add(toward)
            end

            sprite = @enemySprite[index]

            if walk
                if (dot > 0.71)
                    sprite.play animation: :walk_front, loop: true, flip: :none
                elsif (dot >= 0)
                    if toward.x > 0
                        sprite.play animation: :walk_sidefront, loop: true, flip: :none
                    else
                        sprite.play animation: :walk_sidefront, loop: true, flip: :horizontal
                    end
                elsif (dot > -0.71)
                    if toward.x > 0
                        sprite.play animation: :walk_sideback, loop: true, flip: :none
                    else
                        sprite.play animation: :walk_sideback, loop: true, flip: :horizontal
                    end
                elsif (dot >= -1)
                    sprite.play animation: :walk_back, loop: true, flip: :none
                end
            else
                sprite.play animation: :idle_front, loop: true, flip: :none
            end

            sprite.draw(x: pos.x - 5 * $scaleX, y: pos.y - 10 * $scaleY)

            e[:x] = pos.x + @offsetX
            e[:y] = pos.y + @offsetY
        end

        @bullets.each do |bullet|
            bullet.update
            bullet.draw
        end

        @mapOver.draw(x: @map.x, y: @map.y)

        n = @hpMax / 2

        tmp = @hp
        (0...n).each do |i|
            if tmp > 1
                @heart.play animation: :full, loop: false
                tmp -= 2
            elsif tmp > 0
                @heart.play animation: :half, loop: false
                tmp -= 1
            else
                @heart.play animation: :empty, loop: false
            end
            @heart.draw(x: 10 + i * 10 * @uiScale, y: @heart.y)
        end

        @xpBar.each_with_index do |bar, index|
            if index > 0 and index < 11
                if (index - 1) < ((@xp.to_f / @xpToLevel) * 10)
                    bar.play animation: :filled, loop: false
                else
                    bar.play animation: :empty, loop: false
                end
            end
            bar.draw(x: 10 + index * 3 * @uiScale, y: 20 + 9 * @uiScale + 6)
        end

        @atk_icon.draw(x: 10, y: 20 + 9 * @uiScale + 6 + 3 * @uiScale)
        @speed_icon.draw(x: 10, y: 20 + 9 * @uiScale + 6 + 3 * @uiScale + 16 * @uiScale / 2)
        @hp_icon.draw(x: 10, y: 20 + 9 * @uiScale + 6 + 3 * @uiScale + 32 * @uiScale / 2)

        Text.new(
            @atk.to_s,
            x: 20 + 16 * @uiScale / 2, y: 20 + 9 * @uiScale + 6 + 3 * @uiScale + 10,
            font: './propaganda.ttf',
            size: 40,
            color: 'white'
        )

        Text.new(
            @speed.to_s,
            x: 20 + 16 * @uiScale / 2, y: 20 + 9 * @uiScale + 6 + 3 * @uiScale + 16 * @uiScale / 2 + 10,
            font: './propaganda.ttf',
            size: 40,
            color: 'white'
        )

        Text.new(
            @hp.to_s,
            x: 20 + 16 * @uiScale / 2, y: 20 + 9 * @uiScale + 6 + 3 * @uiScale + 32 * @uiScale / 2 + 10,
            font: './propaganda.ttf',
            size: 40,
            color: 'white'
        )

        # Rectangle.draw(x: @square.x, y: @square.y, width: @square.width, height: @square.height, color: [@square.color] * 4)

        # @walls.each do |wall|
        #    Rectangle.draw(x: @map.x + wall.x, y: @map.y + wall.y, width: wall.width, height: wall.height, color: [wall.color] * 4)
        # end

        @map.x -= $velocity.x
        @map.y -= $velocity.y
        @mapOver.x -= $velocity.x
        @mapOver.y -= $velocity.y
    
        @offsetX += $velocity.x
        @offsetY += $velocity.y

        if $velocity.x == 0 && $velocity.y == 0
            $walk = false
        end

        if not $roll
            $rollVelocity.x = $velocity.x
            $rollVelocity.y = $velocity.y
        end

        $velocity.x = 0
        $velocity.y = 0

        $weapon.update
    end

    def stateName
        @Name
    end
end