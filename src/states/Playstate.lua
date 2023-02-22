playstate = {}

playstate.levelToLoad = "nip-trip"

function playstate:init()
    player = require 'src.Player'
    conductor = require 'src.components.Conductor'
    camera = require 'libraries.camera'
    eventhandler = require 'src.components.EventHandler'
    Math = require 'src.Math'
    shoot = require 'src.events.Shoot'
    timer = require 'libraries.timer'
    
    Camera = camera(love.graphics.getWidth() / 2 , love.graphics.getHeight() / 2)
    bg = love.graphics.newImage("resources/images/bgs/game_bg5.png")
    tileImage, tileQuads = atlasparser.getQuads("atlas_sheet1")

    -- particle system
    fade = love.graphics.newImage("resources/images/FX/glow.png")
    psystem = love.graphics.newParticleSystem(fade, 1000)
    psystem:setParticleLifetime(2, 5) -- Particles live at least 2s and at most 5s.
	psystem:setSizeVariation(1)
	psystem:setLinearAcceleration(50, 50, 50, 100) -- Randomized movement towards the bottom of the screen.
	psystem:setColors(1, 1, 1, 1, 1, 1, 1, 0) -- Fade to transparency.
    
    player:set(0, love.graphics.getHeight() / 2)
    isPlayerAlive = true

    MapSettings = {
        Blocks = {},
    }

    camZoom = 0.5

    conductor.load(playstate.levelToLoad)
    raw = love.filesystem.read("resources/data/maps/" .. playstate.levelToLoad .. "/map.lvl")
    rawData = love.filesystem.read("resources/data/maps/" .. playstate.levelToLoad .. "/info.data")
    eventhandler.load(playstate.levelToLoad)
    MapSettings = json.decode(raw)
    MapData = json.decode(rawData)

    conductor.bpm = MapData.bpm


    editorOffset = 0
    conductor.play()
end

function playstate:draw()
    love.graphics.draw(bg, 0, 0, 0, 1.2, 1.2)
    local px, py = player:position()
    effect(function() 
        Camera:attach()
            love.graphics.draw(psystem, px, py)
            if isPlayerAlive then
                player:render() 
            end
            for k, Block in ipairs(MapSettings.Blocks) do
                love.graphics.draw(tileImage, tileQuads[Block.id], Block.x, Block.y)
            end
        Camera:detach()
    end)
    conductor.render()
end

function playstate:update(elapsed)
    player:update(elapsed)

    conductor.update()

    editorOffset = (MapData.speed * 1.5) + (editorOffset + (conductor.dspSongTime * 1000) * 0.5) + elapsed

    Camera:lookAt(math.floor(editorOffset), love.graphics.getHeight() / 2)

    eventhandler.update(elapsed)

    camZoom = Math.lerp(camZoom, 1, 1.4)
    Camera:zoomTo(camZoom)

    for k, Block in pairs(MapSettings.Blocks) do
        if Block.x < 0 then
            table.remove(MapSettings.Blocks, k)
        end
        if utilities.collision(player:getHitbox(), Block) and isPlayerAlive then
            psystem:emit(50)
            isPlayerAlive = false
            deathTimer = timer.new()
            print("[COLLISION] block")
        end
    end

    for k, projectile in pairs(shoot.Shoots) do
        if utilities.collision(player:getHitbox(), projectile) and isPlayerAlive then
            psystem:emit(50)
            isPlayerAlive = false
            deathTimer = timer.new()
            print("[COLLISION] projectile")
        end
    end

    if not isPlayerAlive then
        deathTimer:update(elapsed)
        deathTimer:after(3, function()
            gamestate.switch(states.DeathState)
        end)
    end

    psystem:update(elapsed)
end
-------------------------------

function cameraBump(amount)
    camZoom = amount
end

function newBullet(y, speed)
    
end

return playstate