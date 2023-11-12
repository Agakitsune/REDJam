class MenuState
    def initialize
        @Name = "Menu";
        @bg = Image.new('./image.png', y: -250);
        @bgDir = 0

        title_text = Text.new('STALIN SHOOTER', size: 48, y: 40, font: './propaganda.ttf')
        title_text.x = (Window.width - title_text.width) / 2

        play_box = Rectangle.new(width: 200, height: 40, y: 350, color: '#ff00bf')
        play_box.x = (Window.width - play_box.width) / 2

        quit_box = Rectangle.new(width: 200, height: 40, y: 450, color: '#0030ff')
        quit_box.x = (Window.width - quit_box.width) / 2

        play_text = Text.new('Start game', size: 24, y: (play_box.y + (play_box.height / 2) - 5), font: './propaganda.ttf')
        play_text.x = (Window.width - play_text.width) / 2

        quit_text = Text.new('Leave game', size: 24, y: (quit_box.y + (quit_box.height / 2) - 5), font: './propaganda.ttf')
        quit_text.x = (Window.width - quit_text.width) / 2

    end

    def update
        if Window.frames % 2 == 0
            if @bgDir == 0
                @bg.x -= 2;
            end
            if @bgDir == 1
                @bg.x += 2;
            end
            if @bg.x < -1000
                @bgDir = 1
            end
            if @bg.x > 0
                @bgDir = 0
            end
        end
    end
    def stateName
        @Name
    end
end