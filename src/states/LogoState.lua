logostate = {}

function logostate:init()
    Timer = require 'libraries.timer'
    studioLogo = love.graphics.newImage("resources/images/logo.png")
    studioLogoSize = 0.6

    quicksand = love.graphics.newFont("resources/fonts/quicksand-light.ttf", 20)
    love.graphics.setFont(quicksand)

    logoTimer = Timer.new()
    logoTimer:after(2, function()
        gamestate.switch(states.Menu)
    end)
end

function logostate:draw()
    love.graphics.draw(
        studioLogo, 
        love.graphics.getWidth() / 2, 
        love.graphics.getHeight() / 2, 0, 
        studioLogoSize, 
        studioLogoSize, 
        studioLogo:getWidth() / 2,
        studioLogo:getHeight() / 2
    )
end

function logostate:update(elapsed)
    logoTimer:update(elapsed)
    studioLogoSize = studioLogoSize + 0.0005
end

return logostate