

class GameplayState
    def initialize
        @Name = "Gameplay";
        @positions = [10, 70, 130]
        # @heart = Image.new('./heart.png', width : 50, height : 50, y : 20);
        # @emptyHeart = Image.new('./eheart.png', width : 50, height : 50, y : 20);
        @hp = 2
        @hearts = [
            Image.new('./assets/eheart.png', width: 50, height: 50, y: 20, x: @positions[0]),
            Image.new('./assets/eheart.png', width: 50, height: 50, y: 20, x: @positions[1]),
            Image.new('./assets/eheart.png', width: 50, height: 50, y: 20, x: @positions[2]),
        ]
    end

    def update
        Window.clear
        
        $light_weapon = $weapon.isLight?

        if Window.mouse_x < ($player.x + 16 * $scaleX)
            anchorX = 11 * $scaleX
        else
            anchorX = 20 * $scaleX
        end

        vec = Vector2.vectorize($player.x + 16 * $scaleX, $player.y + 16 * $scaleY, Window.mouse_x, Window.mouse_y)
        shoot = Vector2.vectorize($player.x + 16 * $scaleX, $player.y + 26 * $scaleY, Window.mouse_x, Window.mouse_y)
        rollVec = Vector2.vectorize($player.x + 16 * $scaleX, $player.y + 16 * $scaleY, $player.x + 16 * $scaleX + $rollVelocity.x * 100, $player.y + 16 * $scaleY + $rollVelocity.y * 100)

        vec.drawAt($player.x + 16 * $scaleX, $player.y + 16 * $scaleY, color: 'red')
        $d.drawAt($player.x + 16 * $scaleX, $player.y + 16 * $scaleY, color: 'blue')
        rollVec.drawAt($player.x + 16 * $scaleX, $player.y + 16 * $scaleY, color: 'green')

        angle = Math.acos(shoot.normalize().dot($r.normalize())) * 180 / Math::PI
        if Window.mouse_y < ($player.y + 26 * $scaleY)
            angle *= -1
        end

        if Window.mouse_x < ($player.x + 16 * $scaleX)
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

        $hand.x = $player.x + anchorX - 2 * $scaleX + Math.cos(angle * Math::PI / 180) * $weapon.firstHand().x * $scaleX
        $hand.y = $player.y + 26 * $scaleY - 2 * $scaleY + Math.sin(angle * Math::PI / 180) * $weapon.firstHand().x * $scaleX

        index = 0
        if $roll
            dot = $rollVelocity.normalize().dot($d.normalize())
        else
            dot = vec.normalize().dot($d.normalize())
        end
        if (dot > 0.71)
            if Window.mouse_x > ($player.x + 16 * $scaleX) and $light_weapon and not $roll
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
                if Window.mouse_x > ($player.x + 16 * $scaleX)
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
                if Window.mouse_x > ($player.x + 16 * $scaleX)
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
            $player.play animation: $roll_anim[index][:animation], loop: false, flip: $roll_anim[index][:flip] || :none do
                nextSym = ($roll_anim[index][:animation].to_s.chop() + "B").to_sym
                puts "PhaseB"
                $rollInvicible = false
                $player.play animation: nextSym, loop: false, flip: $roll_anim[index][:flip] || :none do
                    puts "done"
                    $roll = false
                end
            end
        elsif $walk and not $roll
            if $light_weapon
                $player.play animation: $walk_light_anim[index][:animation], loop: true, flip: :none
            else
                $player.play animation: $walk_anim[index][:animation], loop: true, flip: $walk_anim[index][:flip] || :none
            end
        elsif not $roll
            if $light_weapon
                if Window.mouse_x > ($player.x + 16 * $scaleX)
                    $player.play animation: $light_anim[index][:animation], loop: true, flip: :none
                else
                    $player.play animation: $light_anim[index][:animation], loop: true, flip: :horizontal
                end
            else
                $player.play animation: $idle_anim[index][:animation], loop: true, flip: $idle_anim[index][:flip] || :none
            end
        else
            $velocity = $rollVelocity
        end
        if $square.x < 0
            $square.x = 0
        elsif $square.x > (Window.width - $square.size)
            $square.x = Window.width - $square.size
        end
    
        if $square.y < 0
            $square.y = 0
        elsif $square.y > (Window.height - $square.size)
            $square.y = Window.height - $square.size
        end
    
        checkY = $square.y + $square.height > $wall.y && $square.y < $wall.y + $wall.height
        checkX = $square.x + $square.width > $wall.x && $square.x < $wall.x + $wall.width
    
        above = $square.y + $square.height <= $wall.y
        below = $square.y >= $wall.y + $wall.height
        left = $square.x + $square.width <= $wall.x
        right = $square.x >= $wall.x + $wall.width
    
        if checkX || checkY
            if above
                if $square.y + $square.height + $velocity.y > $wall.y
                    $square.y = $wall.y - $square.height
                    $velocity.y = 0
                end
            elsif below
                if $square.y + $velocity.y < $wall.y + $wall.height
                    $square.y = $wall.y + $wall.height
                    $velocity.y = 0
                end
            elsif left
                if $square.x + $square.width + $velocity.x > $wall.x
                    $square.x = $wall.x - $square.width
                    $velocity.x = 0
                end
            elsif right
                if $square.x + $velocity.x < $wall.x + $wall.width
                    $square.x = $wall.x + $wall.width
                    $velocity.x = 0
                end
            end
        end
    
        $velocity = $velocity.normalize().mul(4.0)
    
        if $roll and $rollInvicible
            $velocity = $velocity.mul(2)
        elsif not $rollInvicible and $roll
            $velocity = $velocity.mul(0.95)
        end
    
        $square.x += $velocity.x
        $square.y += $velocity.y
        $player.x += $velocity.x
        $player.y += $velocity.y
    
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
        $bullets.each do |bullet|
            bullet.update
            bullet.draw
        end
    
        $player.add
    
        if $light_weapon and not $roll
            $weapon.play animation: weaponSymbol, loop: weaponLoop
            $weapon.draw(x: weaponX, y: weaponY, originX: weaponOrigin.x, originY: weaponOrigin.y, angle: weaponAngle, scaleX: $scaleX, scaleY: $scaleY)
            $hand.add
        end
        # i = 0
        # while i < @hp
        #     @hearts[i] = Image.new('./assets/heart.png', width: 50, height: 50, y: 20, x: @positions[i])
        #     i = i + 1
        # end
        # while i < 3
        #     @hearts[i] = Image.new('./assets/eheart.png', width: 50, height: 50, y: 20, x: @positions[i])
        #     i = i + 1
        # end
    end

    def stateName
        @Name
    end
end