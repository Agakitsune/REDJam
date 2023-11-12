require './src/SceneManager.rb'
require './src/Weapon.rb'
require './src/SpriteSheet.rb'
require './src/Vector.rb'
require './src/OriginSprite.rb'
require './src/Bullet.rb'

$scenes = SceneManager.new

def GameDefault
    $square = Square.new(x: 0, y: 0, size: 64, color: 'blue')
    # $square.color.opacity = 0
    
    $wall = Square.new(x: 0, y: 100, size: 100, color: 'red')
    
    $d = Vector2.down().mul(100)
    $r = Vector2.right().mul(100)
    
    $scaleX = 3
    $scaleY = 3
    
    $random = Random.new()
    
    def rotate(x, y, angle)
        return Vector2.new(x * Math.cos(angle) - y * Math.sin(angle), x * Math.sin(angle) + y * Math.cos(angle))
    end
    
    def rotateOrigin(x, y, angle, originX, originY)
        return rotate(x - originX, y - originY, angle)
    end
    
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
    
    $revolver = OriginSprite.new(
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
    
    $weapon = Weapon.new($revolver, originY: 10, hand1: Vector2.new(4, 0), cooldown: 10)
    
    $hand = Image.new(
        "./assets/hand.png",
        width: 4 * $scaleX, height: 4 * $scaleY
    )
    
    $bullet = Image.new(
        "./assets/ally_bullet.png",
        width: 8 * $scaleX, height: 8 * $scaleX
    )
    
    $bullets = []
    
    # Define the initial speed (and direction).
    $velocity = Vector2.new(0, 0)
    
    $walk = false
    $roll = false
    $rollVelocity = Vector2.new(0, 0)
    $rollInvicible = false
    $rollMouse = Vector2.new(0, 0)
    
    $light_weapon = false
    $heavy_weapon = false
    
    $idle_anim = [
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
    
    $light_anim = [
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
    
    $walk_light_anim = [
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
    
    $walk_anim = [
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
    
    $roll_anim = [
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
        shoot = Vector2.vectorize($player.x + 16 * $scaleX, $player.y + 26 * $scaleY, Window.mouse_x, Window.mouse_y)
        angle = Math.acos(shoot.normalize().dot($r.normalize()))
        if Window.mouse_y < ($player.y + 26 * $scaleY)
            angle *= -1
        end
        if Window.mouse_x < ($player.x + 16 * $scaleX)
            out = rotateOrigin(20 * $scaleX, 5 * $scaleY, angle, 0, 0)
        else
            out = rotateOrigin(20 * $scaleX, -5 * $scaleY, angle, 0, 0)
        end
        angle *= 180 / Math::PI
        angle += $random.rand(17) - 9
        angle *= Math::PI / 180
        $bullets.append(Bullet.new($bullet, $player.x + 16 * $scaleX + out.x, $player.y + 26 * $scaleY + out.y, angle, 10))
    end
end

