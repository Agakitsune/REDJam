class GameplayState
    def initialize
        @Name = "Gameplay";
        @Square = Square.new(
            x: 200, y: 200,
            size: 125,
            color: 'green',
            z: 10
        )
    end

    def update
    end

    def stateName
        @Name
    end
end