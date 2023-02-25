-- simple gamepad driver --
gamepad = {}

function gamepad.getAxis()
    local valueX = joystick:getGamepadAxis(axis)
    local valueY = joystick:getGamepadAxis(axis)
    if value < 0 then
        return "left"
    end
    if value > 0 then
        return "right"
    end
end

return gamepad