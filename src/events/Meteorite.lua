meteorite = {}

meteorite.Meteorites = {}
meteorite.MiniMeteores = {}

function meteorite.new(x, y, hp, speed)
    local Meteorite = {}
    Meteorite.x = x
    Meteorite.y = y
    Meteorite.texture = love.graphics.newImage("resources/images/objects/unstable_meteorite.png")
    Meteorite.hp = hp or love.math.random(150, 200)
    Meteorite.isAlive = true
    Meteorite.angle = 0

    Meteorite.particleSystem = {}

    -- particle system
    Meteorite.particleSystem.fade = love.graphics.newImage("resources/images/FX/glow.png")
    Meteorite.particleSystem.psystem = love.graphics.newParticleSystem(Meteorite.particleSystem.fade, 1000)
    Meteorite.particleSystem.psystem:setParticleLifetime(2) -- Particles live at least 2s and at most 5s.
	Meteorite.particleSystem.psystem:setSizeVariation(0.5)
	Meteorite.particleSystem.psystem:setLinearAcceleration(-50, -100, 100, 100) -- Randomized movement towards the bottom of the screen.
	Meteorite.particleSystem.psystem:setColors(1, 1, 1, 1, 1, 1, 1, 0) -- Fade to transparency.

    Meteorite.speed = speed or love.math.random(1, 5)
    Meteorite.hitbox = {}
    Meteorite.hitbox.x = Meteorite.x
    Meteorite.hitbox.y = Meteorite.y
    Meteorite.hitbox.w = 64
    Meteorite.hitbox.h = 64
    table.insert(meteorite.Meteorites, Meteorite)
end

function meteorite.render()
    for _, Meteorite in ipairs(meteorite.Meteorites) do
        love.graphics.draw(Meteorite.particleSystem.psystem, Meteorite.x, Meteorite.y)
        love.graphics.draw(Meteorite.texture, Meteorite.x, Meteorite.y, Meteorite.angle, 1, 1, 32, 32)
    end
    renderMeteores()
end

function meteorite.update(elapsed)
    for _, Meteorites in ipairs(meteorite.Meteorites) do
        Meteorites.angle = Meteorites.angle - love.math.random(0.01, 0.1)
        Meteorites.hitbox.x = Meteorites.x
        Meteorites.hitbox.y = Meteorites.y
        if Meteorites.isAlive then
            Meteorites.x = Meteorites.x - Meteorites.speed
            Meteorites.hp = Meteorites.hp - 1
        end
        
        if Meteorites.hp < 0 then
            Meteorites.isAlive = false
            Meteorites.particleSystem.psystem:emit(10)
            newMeteore(Meteorites.x, Meteorites.y, 3, -3)
            newMeteore(Meteorites.x, Meteorites.y, 3, 0)
            newMeteore(Meteorites.x, Meteorites.y, 3, 3)
            newMeteore(Meteorites.x, Meteorites.y, 0, -3)
            newMeteore(Meteorites.x, Meteorites.y, 0, 3)
            table.remove(meteorite.Meteorites, _)
        end
        Meteorites.particleSystem.psystem:update(elapsed)
    end
    updateMeteores()
end

-------------------------------

function newMeteore(x, y, xacc, yacc)
    local Meteore = {}
    Meteore.x = x
    Meteore.y = y
    Meteore.texture = love.graphics.newImage("resources/images/objects/meteorite.png")
    Meteore.hitbox = {}
    Meteore.hitbox.x = Meteore.x
    Meteore.hitbox.y = Meteore.y
    Meteore.angle = 0
    Meteore.hitbox.w = 32
    Meteore.hitbox.h = 32
    Meteore.XAcceleration = xacc
    Meteore.YAcceleration = yacc
    table.insert(meteorite.MiniMeteores, Meteore)
end

function renderMeteores()
    for _, Meteore in ipairs(meteorite.MiniMeteores) do
        love.graphics.draw(Meteore.texture, Meteore.x, Meteore.y, Meteore.angle, 1, 1, 16, 16)
    end
end

function updateMeteores()
    for _, Meteore in ipairs(meteorite.MiniMeteores) do
        Meteore.hitbox.x = Meteore.x - 16
        Meteore.hitbox.y = Meteore.y - 16
        Meteore.x = Meteore.x - Meteore.XAcceleration
        Meteore.y = Meteore.y + Meteore.YAcceleration
        Meteore.angle = Meteore.angle - love.math.random(0.01, 0.1)
    end
end

return meteorite