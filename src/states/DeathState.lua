death = {}

function death:init()
    conductor = require 'src.components.Conductor'
    Math = require 'src.Math'
    conductor.stop()
    conductor.load("Game_Over")

    conductor.setBPM(115.0)

    isPlaying = conductor.play()
    if not isPlaying then
        conductor.play()
    end

    warn = love.graphics.newImage("resources/images/GUI/warn.png")
    replay = love.graphics.newImage("resources/images/GUI/replay_btn.png")
    tomenu = love.graphics.newImage("resources/images/GUI/tomenu_btn.png")
    gradientFX = love.graphics.newImage("resources/images/FX/gradient.png")
    bg = love.graphics.newImage("resources/images/bgs/game_bg5.png")

    warnBump = 1
    lastSavedBeat = conductor.songPositionInBeats

    CurrentItem = 1
end

function death:draw()
    love.graphics.draw(bg, 0, 0, 0, 1.3, 1.3)
    love.graphics.setColor(1, 1, 1, 0.1)
    love.graphics.draw(gradientFX, 0, love.graphics.getHeight() - 256, 0, 2.5, 0.5)
    love.graphics.draw(gradientFX, 0, 256, 0, 2.5, -0.5)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(warn, love.graphics.getWidth() / 2, 200, 0, warnBump, warnBump, warn:getWidth() / 2, warn:getHeight() / 2)
    effect(
        function()
            if CurrentItem == 1 then
                love.graphics.draw(replay, 400, 600, 0, 0.7, 0.7, replay:getWidth() / 2, replay:getHeight() / 2)
            else
                love.graphics.draw(replay, 400, 600, 0, 0.5, 0.5, replay:getWidth() / 2, replay:getHeight() / 2)
            end
            if CurrentItem == 2 then
                love.graphics.draw(tomenu, 800, 600, 0, 0.7, 0.7, tomenu:getWidth() / 2, tomenu:getHeight() / 2)
            else
                love.graphics.draw(tomenu, 800, 600, 0, 0.5, 0.5, tomenu:getWidth() / 2, tomenu:getHeight() / 2)
            end
        end
    )
    conductor.render()
end

function death:update(elapsed)
    conductor.update(elapsed)

    if conductor.songPositionInBeats ~= lastSavedBeat then
        lastSavedBeat = conductor.songPositionInBeats
        warnBump = 1.2
    end

    if CurrentItem > 2 then
        CurrentItem = 2
    end
    if CurrentItem < 1 then
        CurrentItem = 1
    end

    warnBump = Math.lerp(warnBump, 1, 0.7)
end

function death:keypressed(k)
    if k == Controls.Keyboard.SELECT_LEFT then
        CurrentItem = CurrentItem - 1
    end
    if k == Controls.Keyboard.SELECT_RIGHT then
        CurrentItem = CurrentItem + 1
    end
end

function death:gamepadpressed(jstk, button)
    if joystick:isGamepadDown(Controls.Gamepad.SELECT_LEFT) then
        CurrentItem = CurrentItem - 1
    end
    if joystick:isGamepadDown(Controls.Gamepad.SELECT_RIGHT) then
        CurrentItem = CurrentItem + 1
    end
    if joystick:isGamepadDown(Controls.Gamepad.ACCEPT) then
        print("accetp")
    end
end

return death