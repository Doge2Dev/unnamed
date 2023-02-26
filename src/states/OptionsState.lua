options = {}

function options:init()
    Controls = require 'src.components.Controls'

    Options = {
        {
            option = "Glow",
            value = true,
            description = "Enable glow FX on hud and tiles"
        },
        {
            option = "Controller mode",
            value = true,
            description = "Enable controller support"
        },
        {
            option = "Sound Effects",
            value = true,
            description = "Enable Sound effects"
        },
        {
            option = "Antialiasing",
            value = true,
            description = "Allow Antialiasing"
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
    love.graphics.draw(bg, 0, 0, 0, 1.3, 1.3)
    effect(
        function()
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
    if k == Controls.Keyboard.ACCEPT then
        if Settings[currentOption] then
            Settings[currentOption] = false
        else
            Settings[currentOption] = true
        end
    end
    if k == Controls.Keyboard.BACK then
        love.filesystem.write("options.json", json.encode(Settings))
        gamestate.switch(states.Menu)
    end
end

return options