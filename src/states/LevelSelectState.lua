levelselect = {}

function levelselect:init()
    atlasparser = require 'src.components.AtlasParser'

    arrowImg, arrowQuads = atlasparser.getQuads("levelselect/arrows")
    --levelImg, levelQuads = atlasparser.getQuads("levelselect/levelselect")
    bg = love.graphics.newImage("resources/images/bgs/game_bg5.png")
    currentLevel = 1

    quicksand = love.graphics.newFont("resources/fonts/quicksand-light.ttf", 40)
    love.graphics.setFont(quicksand)

    isTransitioning = false

    levels = {
        "Tutorial",
        "Prision Dome",
        "Carbon Planet",
        "Nitrobase prism"
    }
    tutoicon = love.graphics.newImage("resources/images/levelselect/tutorial.png")
    pdicon = love.graphics.newImage("resources/images/levelselect/prision_dome.png")
    cpicon = love.graphics.newImage("resources/images/levelselect/carbon_planet.png")
    npicon = love.graphics.newImage("resources/images/levelselect/nitrobase_prism.png")
    levelIconsIndex = {4, 3, 1, 2}

end

function levelselect:draw()
    love.graphics.draw(bg, 0, 0, 0, 1.3, 1.3)
    love.graphics.draw(arrowImg, arrowQuads[2], 300, 90)
    love.graphics.draw(arrowImg, arrowQuads[1], 880, 90)
    love.graphics.setLineWidth(5)
    love.graphics.rectangle("line", 380, 90, 480, 64)
    love.graphics.setLineWidth(1)
    love.graphics.print(levels[currentLevel], 390 + (#levels[currentLevel] * 2), 90)
    Switch(currentLevel, {
        [1] = function()
            love.graphics.draw(tutoicon, 790, 700, 0, 1, 1, tutoicon:getWidth(), tutoicon:getHeight())
        end,
        [2] = function()
            love.graphics.draw(pdicon, 990, 700, 0, 1, 1, pdicon:getWidth(), pdicon:getHeight())
        end,
        [3] = function()
            love.graphics.draw(cpicon, 990, 700, 0, 1, 1, cpicon:getWidth(), cpicon:getHeight())
        end,
        [4] = function()
            love.graphics.draw(npicon, 1190, 790, 0, 1, 1, npicon:getWidth(), npicon:getHeight())
        end,
    })
end

function levelselect:update(elapsed)
    if currentLevel < 1 then
        currentLevel = #levels
    end
    if currentLevel > #levels then
        currentLevel = 1
    end

    if onComplete and isTransitioning then
        gamestate.switch(states.Menu)
    end
end

function levelselect:keypressed(k, code)
    if k == Controls.Keyboard.SELECT_LEFT then
        currentLevel = currentLevel - 1
    end
    if k == Controls.Keyboard.SELECT_RIGHT then
            currentLevel = currentLevel + 1
    end
    if k == Controls.Keyboard.BACK then
        gamestate.switch(states.Menu)
    end
end


function levelselect:gamepadpressed(jstk, button)
    if joystick:isGamepadDown(Controls.Gamepad.SELECT_LEFT) then
        currentLevel = currentLevel - 1
    end
    if joystick:isGamepadDown(Controls.Gamepad.SELECT_RIGHT) then
        currentLevel = currentLevel + 1
    end
    if joystick:isGamepadDown(Controls.Gamepad.BACK) then
        gamestate.switch(states.Menu)
    end
end

function levelselect:gamepadaxis(joystick, axis, value)
	if axis == "leftx" then
		if value == -1 then
            currentLevel = currentLevel - 1
        end
        if value == 1 then
            currentLevel = currentLevel + 1
        end
	end
end

return levelselect