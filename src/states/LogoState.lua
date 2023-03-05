logostate = {}

function logostate:enter()
    Timer = require 'libraries.timer'
    studioLogo = love.graphics.newImage("resources/images/logoTransparent.png")
    studioLogoSize = 0.6
    gamepadIcon = love.graphics.newImage("resources/images/GUI/gamepadicon.png")

    quicksand = love.graphics.newFont("resources/fonts/quicksand-light.ttf", 30)
    love.graphics.setFont(quicksand)

    logoTimer = Timer.new()
    logoTimer:after(2, function()
        gamestate.switch(states.Menu)
    end)
end

function logostate:draw()
    effect(
        function()
            love.graphics.draw(
                studioLogo, 
                love.graphics.getWidth() / 2, 
                love.graphics.getHeight() / 2, 0, 
                studioLogoSize, studioLogoSize, 
                studioLogo:getWidth() / 2,
                studioLogo:getHeight() / 2
            )
            love.graphics.draw(gamepadIcon, 10, 680, 0, 0.3, 0.3)
            love.graphics.print("This game have gamepad support", 150, 690)
        end
    )
end

function logostate:update(elapsed)
    logoTimer:update(elapsed)
    studioLogoSize = studioLogoSize + 0.0005
end

return logostate