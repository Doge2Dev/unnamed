options = {}

function options:enter()
    Controls = require 'src.components.Controls'

    Options = {
        {
            option = "Glow",
            type = "bool",
            description = "Enable glow FX on hud and tiles"
        },
        {
            option = "Controller mode",
            type = "bool",
            description = "Enable controller support (Require restart)"
        },
        {
            option = "Antialiasing",
            type = "bool",
            description = "Allow Antialiasing"
        },
        {
            option = "Volume",
            type = "numeric",
            description = "Change the game volume"
        },
    }

    cursor = love.graphics.newImage("resources/images/menu/cursor.png")
    bg = love.graphics.newImage("resources/images/bgs/game_bg5.png")
    maxY = 0
    cursorY = 300
    currentOption = 1

    quicksand = love.graphics.newFont("resources/fonts/quicksand-bold.ttf", 40)
    quicksand_light = love.graphics.newFont("resources/fonts/quicksand-light.ttf", 28)
    love.graphics.setFont(quicksand)
end

function options:draw()
    local y = 300
    effect(
        function()
            love.graphics.draw(bg, 0, 0, 0, 1.3, 1.3)
            love.graphics.print("Options", quicksand, 30, 30)
            love.graphics.draw(cursor, 10, cursorY + 7)
            for optionItem = 1, #Options, 1 do
                    love.graphics.print(
                        Options[optionItem].option .. " : [" .. tostring(Settings[optionItem]) .. "]", 
                        80, y, 0, 1, 1
                    )
                y = y + 50
            end
            love.graphics.print(Options[currentOption].description, quicksand_light, 20, 650)
            maxY = y - 50
        end
    )
end

function options:update(elapsed)
    if cursorY < 300 then
        cursorY = 300
    end
    if cursorY > maxY then
        cursorY = maxY
    end

    if currentOption < 1 then
        currentOption = 1
    end
    if currentOption > #Options then
        currentOption = #Options
    end
    if Settings[1] then
        effect.enable("glow")
    else
        effect.disable("glow")
    end
    if Settings[3] then
        love.graphics.setDefaultFilter("linear", "linear")
    else
        love.graphics.setDefaultFilter("nearest", "nearest")
    end
end

function options:keypressed(k)
    if k == Controls.Keyboard.SELECT_DOWN then
        cursorY = cursorY + 50
        currentOption = currentOption + 1
    end
    if k == Controls.Keyboard.SELECT_UP then
        cursorY = cursorY - 50
        currentOption = currentOption - 1
    end
    if k == Controls.Keyboard.SELECT_RIGHT then
        if Options[currentOption].type == "numeric" then
            Settings[currentOption] = Settings[currentOption] + 1
        end
    end
    if k == Controls.Keyboard.SELECT_LEFT then
        if Options[currentOption].type == "numeric" then
            Settings[currentOption] = Settings[currentOption] - 1
        end
    end
    if k == Controls.Keyboard.ACCEPT then
        if Options[currentOption].type == "bool" then
            if Settings[currentOption] then
                Settings[currentOption] = false
            else
                Settings[currentOption] = true
            end
        end
    end
    if k == Controls.Keyboard.BACK then
        love.filesystem.write("options.json", json.encode(Settings))
        gamestate.switch(states.Menu)
    end
end

function options:gamepadpressed(jstk, button)
    if joystick ~= nil then
        if joystick:isGamepadDown(Controls.Gamepad.SELECT_UP) then
            cursorY = cursorY - 50
            currentOption = currentOption - 1
        end
        if joystick:isGamepadDown(Controls.Gamepad.SELECT_DOWN) then
            cursorY = cursorY + 50
            currentOption = currentOption + 1
        end
        if joystick:isGamepadDown(Controls.Gamepad.ACCEPT) then
            if Options[currentOption].type == "bool" then
                if Settings[currentOption] then
                    Settings[currentOption] = false
                else
                    Settings[currentOption] = true
                end
            end
        end
        if joystick:isGamepadDown(Controls.Gamepad.SELECT_RIGHT) then
            if Options[currentOption].type == "numeric" then
                Settings[currentOption] = Settings[currentOption] + 1
            end
        end
        if joystick:isGamepadDown(Controls.Gamepad.SELECT_LEFT) then
            if Options[currentOption].type == "numeric" then
                Settings[currentOption] = Settings[currentOption] - 1
            end
        end
        if joystick:isGamepadDown(Controls.Gamepad.BACK) then
            love.filesystem.write("options.json", json.encode(Settings))
            gamestate.switch(states.Menu)
        end
    end
end

function options:gamepadaxis(joystick, axis, value)
	if axis == "lefty" then
		if value == -1 then
            cursorY = cursorY - 50
            currentOption = currentOption - 1
        end
        if value == 1 then
            cursorY = cursorY + 50
            currentOption = currentOption + 1
        end
	end
    if axis == "leftx" then
		if value == -1 then
            if Options[currentOption].type == "numeric" then
                Settings[currentOption] = Settings[currentOption] - 1
            end
        end
        if value == 1 then
            if Options[currentOption].type == "numeric" then
                Settings[currentOption] = Settings[currentOption] + 1
            end
        end
	end
end

return options