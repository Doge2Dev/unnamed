playstate = {}

playstate.levelToLoad = "nip-trip"
playstate.bpm = 87.0

function playstate:enter()
    player = require 'src.Player'
    conductor = require 'src.components.Conductor'
    camera = require 'libraries.camera'
    eventhandler = require 'src.components.EventHandler'
    Math = require 'src.Math'
    shoot = require 'src.events.Shoot'
    saw = require 'src.events.Saw'
    laser = require 'src.events.Laser'
    timer = require 'libraries.timer'
    
    Camera = camera(love.graphics.getWidth() / 2 , love.graphics.getHeight() / 2)
    bg = love.graphics.newImage("resources/images/bgs/game_bg5.png")
    fadebg = love.graphics.newImage("resources/images/FX/fade.png")
    tileImage, tileQuads = atlasparser.getQuads("atlas_sheet1")

    noclip = false

    -- particle system
    fade = love.graphics.newImage("resources/images/FX/glow.png")
    psystem = love.graphics.newParticleSystem(fade, 1000)
    psystem:setParticleLifetime(2) -- Particles live at least 2s and at most 5s.
	psystem:setSizeVariation(0.5)
	psystem:setLinearAcceleration(-50, -100, 100, 100) -- Randomized movement towards the bottom of the screen.
	psystem:setColors(1, 1, 1, 1, 1, 1, 1, 0) -- Fade to transparency.
    
    player:set(0, love.graphics.getHeight() / 2)
    isPlayerAlive = true

    MapSettings = {
        Blocks = {},
    }

    camZoom = 0.5

    conductor.load("resources/data/maps/" .. playstate.levelToLoad .. "/song")
    raw = love.filesystem.read("resources/data/maps/" .. playstate.levelToLoad .. "/map.lvl")
    rawData = love.filesystem.read("resources/data/maps/" .. playstate.levelToLoad .. "/info.data")
    eventhandler.load(playstate.levelToLoad)
    MapSettings = json.decode(raw)
    MapData = json.decode(rawData)

    camera_x = 0
    camera_y = 0
    shakeDuration = 0
    shakeMagnitude = 0
    t = shakeDuration

    conductor.setBPM(MapData.bpm)

    editorOffset = 0
    conductor.play()
end

function playstate:draw()
    local px, py = player:position()
    effect(function() 
        love.graphics.draw(bg, 0, 0, 0, 1.2, 1.2)
        Camera:attach()
            love.graphics.draw(psystem, px, py)
            if isPlayerAlive then
                player:render() 
            end
            for k, Block in ipairs(MapSettings.Blocks) do
                love.graphics.draw(tileImage, tileQuads[Block.id], Block.x, Block.y)
            end
            shoot.render()
            saw.render()
        Camera:detach()
        love.graphics.draw(fadebg, 0, 0, 0, 1.2, 1.2)
        if noclip then
            love.graphics.print("noclip", 0, 0)
        end
    end)
    laser.render()
end

function playstate:update(elapsed)
    player:update(elapsed)

    conductor.update()

    editorOffset = (MapData.speed * 1.5) + (editorOffset + (conductor.dspSongTime * 1000) * 0.5) + elapsed

    Camera:lookAt(math.floor(editorOffset) + camera_x, love.graphics.getHeight() / 2 + camera_y)

    eventhandler.update(elapsed)

    camZoom = Math.lerp(camZoom, 1, 1.4)
    Camera:zoomTo(camZoom)

    if not noclip then
        for k, Block in pairs(MapSettings.Blocks) do
            if utilities.collision(player:getHitbox(), Block) and isPlayerAlive then
                psystem:emit(10)
                isPlayerAlive = false
                deathTimer = timer.new()
                print("[COLLISION] block")
            end
        end
    
        for k, projectile in pairs(shoot.Shoots) do
            if utilities.collision(player:getHitbox(), projectile) and isPlayerAlive then
                psystem:emit(10)
                isPlayerAlive = false
                deathTimer = timer.new()
                print("[COLLISION] projectile")
            end
        end
    
        for k, saw in pairs(saw.Saws) do
            if utilities.collision(player:getHitbox(), saw.hitbox) and isPlayerAlive then
                psystem:emit(10)
                isPlayerAlive = false
                deathTimer = timer.new()
                print("[COLLISION] saw")
            end
        end
    
        for k, laser in pairs(laser.Lasers) do
            if utilities.collision(player:getHitbox(), laser.hitbox) and isPlayerAlive and laser.allowCollision then
                psystem:emit(10)
                isPlayerAlive = false
                deathTimer = timer.new()
                print("[COLLISION] laser")
            end
        end
    end

    if not isPlayerAlive then
        deathTimer:update(elapsed)
        deathTimer:after(3, function()
            gamestate.switch(states.DeathState)
        end)
    end

    psystem:update(elapsed)
    shoot.update(elapsed)
    saw.update(elapsed)
    laser.update(elapsed)
end

--[[
function playstate:keypressed(k)
    if k == "1" then
        if noclip then
            noclip = false
        else
            noclip = true
        end
    end
end
]]--

-------------------------------

function cameraBump(amount)
    camZoom = amount
end

function newBullet(amount)
    for a = 1, amount, 1 do
        shoot.new(
            love.graphics.getWidth() + editorOffset, 
            math.random(1, love.graphics.getHeight()), 
            math.random(1, 4), math.random(-3, 3)
        )
    end
end

function newSaw()
    saw.new(
        love.graphics.getWidth() + editorOffset, 
        math.random(1, love.graphics.getHeight()), 
        math.random(1,3), 1
    )
end

function newLaser(time)
    laser.new(math.random(64, love.graphics.getHeight() - 64), time)
end

function levelEnd()
    eventhandler.levelEnds()
    gamestate.switch(states.LevelWinState)
end

return playstate