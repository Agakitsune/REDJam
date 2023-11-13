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
require './src/Map.rb'

set title: 'ruby2dGame'
# set width: 800
# set height: 600

$currentState = MenuState.new

$velocity = Vector2.new(0, 0)
$rollVelocity = Vector2.new(0, 0)

music = Sound.new('./music.wav')
music.play

set width: 1200, height: 720

update do
   $currentState.update
end

show
