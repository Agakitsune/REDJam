
require 'ruby2d'

def Map(file)
    
    boxes = []

    x = 0
    y = 0
    w = 0
    s = false
    sx = 0

    f = File.open(file, "r").each_line do |line|
        line.split(",").each do |i|
            tile = nil
            if i.to_i != -1
                if s
                    w += 1
                else
                    boxes << Rectangle.new(x: sx, y: y, width: w, height: 1, color: 'red')
                    s = true
                    sx = x
                    w = 1
                end
            else
                s = false
            end
            x += 1
        end
        x = 0
        y += 1
    end

    return boxes
end
