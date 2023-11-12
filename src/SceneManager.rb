require './src/menuState'
require './src/gameplayState'
require './src/gameOverState'

class SceneManager
    attr_accessor :menu, :game, :gameOver, :currentState

    def initialize
        @menu = MenuState.new
        @game = GameplayState.new
        @gameOver = GameOverState.new
        @currentState = @menu
    end

    def switch(scene)
        if scene == 'Menu'
            @currentState = @menu
        elsif scene == 'Game'
            @currentState = @game
        elsif scene == 'Over'
            @currentState = @gameOver
        end
    end

    def update
        @currentState.update
    end
end