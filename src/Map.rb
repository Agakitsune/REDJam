
require 'ruby2d'

def Map(file)
    
    boxes = []

    x = 0
    y = 0

    f = File.open(file, "r").each_line do |line|
        line.split(",").each do |i|
            tile = nil
            if i.to_i != -1
                boxes << Rectangle.new(x: x, y: y, width: 1, height: 1, color: 'red')
            end
            x += 1
        end
        x = 0
        y += 1
    end

    return boxes
end
