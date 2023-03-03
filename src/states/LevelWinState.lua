win = {}

function win:enter()
    conductor = require 'src.components.Conductor'
    Math = require 'src.Math'
    playstate = require 'src.states.Playstate'

    conductor.stop()
    conductor.load("resources/sounds/abstraction")

    conductor.setBPM(122.0)

    isPlaying = conductor.play()

    warn = love.graphics.newImage("resources/images/GUI/missionPassed.png")
    replay = love.graphics.newImage("resources/images/GUI/replay_btn.png")
    tomenu = love.graphics.newImage("resources/images/GUI/tomenu_btn.png")
    gradientFX = love.graphics.newImage("resources/images/FX/gradient.png")
    bg = love.graphics.newImage("resources/images/bgs/game_bg5.png")

    warnBump = 1
    lastSavedBeat = conductor.songPositionInBeats

    CurrentItem = 1
end

function win:draw()
    effect(
        function()
            love.graphics.draw(bg, 0, 0, 0, 1.3, 1.3)
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
    love.graphics.setColor(1, 1, 1, 0.1)
    love.graphics.draw(gradientFX, 0, love.graphics.getHeight() - 256, 0, 2.5, 0.5)
    love.graphics.draw(gradientFX, 0, 256, 0, 2.5, -0.5)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(warn, love.graphics.getWidth() / 2, 200, 0, warnBump, warnBump, warn:getWidth() / 2, warn:getHeight() / 2)
end

function win:update(elapsed)
    conductor.update(elapsed)

    if not conductor.getAudio():isPlaying() then
        conductor.stop()
        conductor.play()
    end

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

function win:keypressed(k)
    if k == Controls.Keyboard.SELECT_LEFT then
        CurrentItem = CurrentItem - 1
    end
    if k == Controls.Keyboard.SELECT_RIGHT then
        CurrentItem = CurrentItem + 1
    end
    if k == Controls.Keyboard.ACCEPT then
        Switch(CurrentItem, {
            [1] = function()
                conductor.stop()
                playstate:init()
                gamestate.switch(states.Playstate)
            end,
            [2] = function()
                conductor.stop()
                menustate:init()
                gamestate.switch(states.Menu)
            end
        })
    end
end

function win:gamepadpressed(jstk, button)
    if joystick:isGamepadDown(Controls.Gamepad.SELECT_LEFT) then
        CurrentItem = CurrentItem - 1
    end
    if joystick:isGamepadDown(Controls.Gamepad.SELECT_RIGHT) then
        CurrentItem = CurrentItem + 1
    end
    if joystick:isGamepadDown(Controls.Gamepad.ACCEPT) then
        Switch(CurrentItem, {
            [1] = function()
                conductor.stop()
                playstate:init()
                gamestate.switch(states.Playstate)
            end,
            [2] = function()
                conductor.stop()
                menustate:init()
                gamestate.switch(states.Menu)
            end
        })
    end
end

function win:gamepadaxis(joystick, axis, value)
	if axis == "leftx" then
		if value == -1 then
            CurrentItem = CurrentItem - 1
        end
        if value == 1 then
            CurrentItem = CurrentItem + 1
        end
	end
end

return win