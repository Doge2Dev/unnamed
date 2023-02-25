menustate = {}

function menustate:init()
    atlasparser = require 'src.components.AtlasParser'
    transition = require 'src.Transition'
    menuFX = require 'src.states.resources.MenuStateFX'
    conductor = require 'src.components.Conductor'
    Math = require 'src.Math'
    utilities = require 'src.Utilities'
    tween = require 'libraries.tween'

    conductor.stop()
    conductor.load("abstraction")
    conductor.setBPM(122)
    conductor.play()

    MenuItemsIndex = {7,5,3,1}
    MenuItemsIndexSelected = {8,6,4,2}

    lastSavedBeat = conductor.songPositionInBeats

    LogoSize = 0.5

    gradientFX = love.graphics.newImage("resources/images/FX/gradient.png")

    CurrentItem = 1
    Selected = false

    menuItemsImage, MenuItemsQuads = atlasparser.getQuads("menu/menu_atlas")
    bg = love.graphics.newImage("resources/images/bgs/game_bg5.png")
    logo = love.graphics.newImage("resources/images/menu/logo.png")
    studioLogo = love.graphics.newImage("resources/images/logoTransparent.png")
end

function menustate:draw()
    love.graphics.draw(bg, 0, 0, 0, 1.3, 1.3)
    love.graphics.setColor(1, 1, 1, 0.3)
    love.graphics.draw(gradientFX, 0, love.graphics.getHeight() - 256, 0, 2.5, 0.5)
    love.graphics.draw(gradientFX, 0, 256, 0, 2.5, -0.5)
    love.graphics.setColor(1, 1, 1, 1)
    local yp = 100
    for i = 1, #MenuItemsIndex, 1 do
        love.graphics.draw(menuItemsImage, 
        MenuItemsQuads[MenuItemsIndex[i]], 30, yp, 0, 0.5, 0.5)
        yp = yp + 150
    end
    menuFX.render()
    love.graphics.draw(logo, 800, 280, 0, 
    LogoSize, LogoSize, 
    logo:getWidth() / 2, logo:getHeight() / 2)
    love.graphics.draw(studioLogo, 1090, 600, 0, 0.15, 0.15)
    conductor.render()
end

function menustate:update(elapsed)
    MenuItemsIndex = {7,5,3,1}
    MenuItemsIndex[CurrentItem] = MenuItemsIndexSelected[CurrentItem]

    if not conductor.getAudio():isPlaying() then
        conductor.stop()
        conductor.play()
    end

    if CurrentItem < 1 then
        CurrentItem = #MenuItemsIndex
    end
    if CurrentItem > #MenuItemsIndex then
        CurrentItem = 1
    end
    conductor.update()

    if conductor.songPositionInBeats ~= lastSavedBeat then
        lastSavedBeat = conductor.songPositionInBeats
        print("[EVENT] : On step")
        bumpLogo(0.55)
    end

    menuFX.update()
    LogoSize = Math.lerp(LogoSize, 0.5, 0.4)
end

function menustate:keypressed(k, code)
    if k == Controls.Keyboard.SELECT_UP then
        CurrentItem = CurrentItem - 1
    end
    if k == Controls.Keyboard.SELECT_DOWN then
        CurrentItem = CurrentItem + 1
    end
    if k == "7" then
        conductor.stop()
        gamestate.switch(states.LevelEditor)
    end
    if k == Controls.Keyboard.ACCEPT then
        Switch(CurrentItem, {
            [1] = function()
                gamestate.switch(states.LevelSelect)
            end,
            [2] = function()
                gamestate.switch(states.Playlist)
            end,
            [3] = function()
                gamestate.switch(states.OptionsState)
            end,
            [4] = function()
                gamestate.switch(states.Credits)
            end
        })
    end
end

function menustate:gamepadpressed(jstk, button)
    if joystick:isGamepadDown(Controls.Gamepad.SELECT_UP) then
        CurrentItem = CurrentItem - 1
    end
    if joystick:isGamepadDown(Controls.Gamepad.SELECT_DOWN) then
        CurrentItem = CurrentItem + 1
    end
    if joystick:isGamepadDown(Controls.Gamepad.ACCEPT) then
        Selected = true
    end
end

--------------------------------------------------

function bumpLogo(amount)
    LogoSize = amount
    menuFX.new(800, 280)
end

return menustate