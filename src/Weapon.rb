
require './src/Vector.rb'

class Weapon
    attr_accessor :sprite, :originY

    def initialize(sprite, originY: 0, hand1: Vector2.new(0, 0), hand2: nil, cooldown: 0)
        @sprite = sprite
        @originY = originY

        @hand1 = hand1
        @hand2 = hand2

        @onShoot = nil

        @timer = 0
        @cooldown = cooldown
        @onCooldown = false
    end

    def onShoot(&shoot_proc)
        @onShoot = shoot_proc
    end

    def shoot()
        if not @onCooldown
            @onCooldown = true
            @onShoot.call unless @onShoot.nil?
        end
    end

    def isLight?
        return @hand2.nil?
    end

    def firstHand()
        return @hand1
    end

    def secondHand()
        return @hand2
    end

    def width()
        return @sprite.clip_width
    end

    def update
        if @onCooldown
            @timer += 1
            if @timer >= @cooldown
                @onCooldown = false
                @timer = 0
            end
        end
    end

    def play(animation: :default, loop: nil, flip: nil, &done_proc)
        @sprite.play(animation: animation, loop: loop, flip: flip, &done_proc)
    end

    def draw(x: 0, y: 0, angle: 0, originX: 0, originY: 0, scaleX: 1, scaleY: 1)
        @sprite.draw(x: x, y: y, rotate: angle, originX: originX * scaleX, originY: originY * scaleY)
    end
end