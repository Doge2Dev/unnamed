options = {}

function options:init()
    Options = {
        {
            option = "Glow",
            value = true,
            description = "Enable glow FX on hud and tiles"
        },
        {
            option = "Glow",
            value = true,
            description = "Enable glow FX on hud and tiles"
        },
        {
            option = "Glow",
            value = true,
            description = "Enable glow FX on hud and tiles"
        },
    }

    cursor = love.graphics.newImage("resources/images/menu/cursor.png")

    quicksand = love.graphics.newFont("resources/fonts/quicksand-bold.ttf", 40)
    love.graphics.setFont(quicksand)
end

function options:draw()
    local y = 300
    effect(
        function()
            love.graphics.draw(cursor, 10,60)
            for optionItem = 1, #Options, 1 do
                    love.graphics.print(Options[optionItem].option .. " : " .. tostring(Options[optionItem].value), 
                    50 - (#Options[optionItem].option * 4), y, 0, 1, 1
                )
                y = y + 50
            end
        end
    )
end

function options:update(elapsed)
    
end

return options