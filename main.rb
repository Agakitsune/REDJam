require 'ruby2d'

require './menuState'
require './gameplayState'
require './gameOverState'

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
    end
end

show
