class GameOverState
    def initialize
        @Name = "GameOver";
    end

    def update
        Window.clear
        
        gameOver_text = Text.new('GAME OVER CYKA', size: 48, y: (Window.height / 2) - 20, font: './propaganda.ttf')
        gameOver_text.x = (Window.width - gameOver_text.width) / 2

        replay_box = Rectangle.new(width: 200, height: 40, y: (Window.height / 2) + 80, color: '#ff00bf')
        replay_box.x = ((Window.width - replay_box.width) / 2) - 200

        quit_box = Rectangle.new(width: 200, height: 40, y: (Window.height / 2) + 80, color: '#0030ff')
        quit_box.x = ((Window.width - quit_box.width) / 2) + 200

        replay_text = Text.new('Retry', size: 36, y: (replay_box.y + (replay_box.height / 2) - 10), font: './propaganda.ttf')
        replay_text.x = ((Window.width - replay_text.width) / 2) - 200

        quit_text = Text.new('Quit', size: 36, y: (quit_box.y + (quit_box.height / 2) - 10), font: './propaganda.ttf')
        quit_text.x = ((Window.width - quit_text.width) / 2) + 200
    end

    def stateName
        @Name
    end
end