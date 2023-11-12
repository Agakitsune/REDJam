class GameplayState
    def initialize
        @Name = "Gameplay";
        @positions = [10, 70, 130]
        # @heart = Image.new('./heart.png', width : 50, height : 50, y : 20);
        # @emptyHeart = Image.new('./eheart.png', width : 50, height : 50, y : 20);
        @hp = 2
        @hearts = [
            Image.new('./eheart.png', width: 50, height: 50, y: 20, x: @positions[0]),
            Image.new('./eheart.png', width: 50, height: 50, y: 20, x: @positions[1]),
            Image.new('./eheart.png', width: 50, height: 50, y: 20, x: @positions[2]),
        ]
    end

    def update
        i = 0
        while i < @hp
            @hearts[i] = Image.new('./heart.png', width: 50, height: 50, y: 20, x: @positions[i])
            i = i + 1
        end
        while i < 3
            @hearts[i] = Image.new('./eheart.png', width: 50, height: 50, y: 20, x: @positions[i])
            i = i + 1
        end
    end

    def stateName
        @Name
    end
end