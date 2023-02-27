-- simple gamepad driver --
gamepad = {}

function gamepad.getAxis(axis)
    local valueX = joystick:getGamepadAxis("leftx")
    local valueY = joystick:getGamepadAxis("leftx")
    if axis == "x" then
        if valueX < 0 then
            return "left"
        end
        if valueX > 0 then
            return "right"
        end
    end
    if axis == "x" then
        if valueY < 0 then
            return "down"
        end
        if valueY > 0 then
            return "up"
        end
    end
end

return gamepad