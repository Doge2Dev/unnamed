playstate = {}

playstate.levelToLoad = "nip-trip"
playstate.bpm = 87.0

function playstate:init()
    player = require 'src.Player'
    conductor = require 'src.components.Conductor'
    camera = require 'libraries.camera'
    eventhandler = require 'src.components.EventHandler'
    Math = require 'src.Math'
    shoot = require 'src.events.Shoot'
    saw = require 'src.events.Saw'
    timer = require 'libraries.timer'

    conductor.setBPM(playstate.bpm)
    Beat = conductor.songPositionInBeats
    Step = conductor.songPositionInSteps
    
    Camera = camera(love.graphics.getWidth() / 2 , love.graphics.getHeight() / 2)
    bg = love.graphics.newImage("resources/images/bgs/game_bg5.png")
    fadebg = love.graphics.newImage("resources/images/FX/fade.png")
    tileImage, tileQuads = atlasparser.getQuads("atlas_sheet2")

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
    love.graphics.draw(fadebg, 0, 0, 0, 1.2, 1.2)
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
            shoot.render()
            saw.render()
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
        if utilities.collision(player:getHitbox(), saw) and isPlayerAlive then
            psystem:emit(10)
            isPlayerAlive = false
            deathTimer = timer.new()
            print("[COLLISION] saw")
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
end
-------------------------------

function cameraBump(amount)
    camZoom = amount
end

function newBullet(amount)
    shoot.new(
        love.graphics.getWidth() + editorOffset, 
        math.random(1, love.graphics.getHeight()), 
        math.random(1, 4)
    )
end

function newSaw()
    saw.new(
        love.graphics.getWidth() + editorOffset, 
        math.random(1, love.graphics.getHeight()), 
        math.random(1,3), 1
    )
end

return playstate