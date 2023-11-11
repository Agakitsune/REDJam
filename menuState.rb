class MenuState
    def initialize
        @Name = "Menu";
        @paralax = Image.new('./trees.png');
        @paralaxDir = 0

        title_text = Text.new('STALIN SHOOTER', size: 48, y: 40, font: './propaganda.ttf')
        title_text.x = (Window.width - title_text.width) / 2

        play_box = Rectangle.new(width: 200, height: 40, y: 150, color: 'yellow')
        play_box.x = (Window.width - play_box.width) / 2

        quit_box = Rectangle.new(width: 200, height: 40, y: 250, color: 'red')
        quit_box.x = (Window.width - quit_box.width) / 2

        play_text = Text.new('Start game', size: 24, y: (play_box.y + (play_box.height / 2) - 5), font: './propaganda.ttf')
        play_text.x = (Window.width - play_text.width) / 2

        quit_text = Text.new('Leave game', size: 24, y: (quit_box.y + (quit_box.height / 2) - 5), font: './propaganda.ttf')
        quit_text.x = (Window.width - quit_text.width) / 2

    end

    def update
        if Window.frames % 2 == 0
            if @paralaxDir == 0
                @paralax.x -= 2;
            end
            if @paralaxDir == 1
                @paralax.x += 2;
            end
            if @paralax.x < -1000
                @paralaxDir = 1
            end
            if @paralax.x > 0
                @paralaxDir = 0
            end
        end
    end
    def stateName
        @Name
    end
end