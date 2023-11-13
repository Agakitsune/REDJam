require 'ruby2d'
require 'matrix'

controllerKeyPressed = {rX: 0, rY: 0, lX: 0, lY: 0,
yKey: false, bKey: false, aKey: false, xKey: false,
upKey: false, rightKey: false, downKey: false, leftKey: false,
lb: false, rb: false, lt: false, rt: false,
back: false, start: false}

on :controller_button_up do |event|
    case event.button
        when :y
            controllerKeyPressed[:yKey] = false
        when :b
            controllerKeyPressed[:bKey] = false
        when :a
            controllerKeyPressed[:aKey] = false
        when :x
            controllerKeyPressed[:xKey] = false
        when :up
            controllerKeyPressed[:upKey] = false
        when :right
            controllerKeyPressed[:rightKey] = false
        when :down
            controllerKeyPressed[:downKey] = false
        when :left
            controllerKeyPressed[:leftKey] = false
        when :back
            controllerKeyPressed[:back] = false
        when :start
            controllerKeyPressed[:start] = false
        when :left_shoulder
            controllerKeyPressed[:lb] = false
        when :right_shoulder
            controllerKeyPressed[:rb] = false
        end
    end


on :controller_button_down do |event|
    case event.button
        when :y
            controllerKeyPressed[:yKey] = true
        when :b
            controllerKeyPressed[:bKey] = true
        when :a
            controllerKeyPressed[:aKey] = true
        when :x
            controllerKeyPressed[:xKey] = true
        when :up
            controllerKeyPressed[:upKey] = true
        when :right
            controllerKeyPressed[:rightKey] = true
        when :down
            controllerKeyPressed[:downKey] = true
        when :left
            controllerKeyPressed[:leftKey] = true
        when :back
            controllerKeyPressed[:back] = true
        when :start
            controllerKeyPressed[:start] = true
        when :left_shoulder
            controllerKeyPressed[:lb] = true
        when :right_shoulder
            controllerKeyPressed[:rb] = true
        end
        puts controllerKeyPressed
    end

on :controller_axis do |event|
    case event.axis
        when :left_x
            controllerKeyPressed[:lX] = event.value
        when :left_y
            controllerKeyPressed[:lY] = event.value
        when :right_x
            controllerKeyPressed[:rX] = event.value
        when :right_y
            controllerKeyPressed[:rY] = event.value
        when :trigger_right
            if event.value < 0.2
                controllerKeyPressed[:rt] = true
            else
                controllerKeyPressed[:rt] = true
            end
        when :trigger_left
            if event.value < 0.2
                controllerKeyPressed[:lt] = true
            else
                controllerKeyPressed[:lt] = false
            end
        end
    end

def getLeftVelocity
    v = Vector[controllerKeyPressed[:lX], controllerKeyPressed[:lY]]
    return v.normalize
end

def getRightVelocity(controllerKeyPressed)
    v = Vector[controllerKeyPressed[:rX], controllerKeyPressed[:rY]]
    return v.normalize
end

show