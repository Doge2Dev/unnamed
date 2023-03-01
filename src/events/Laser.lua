laser = {}

laser.Lasers = {}

function laser.new(y, time)
    Laser = {}
    Laser.x = 0
    Laser.y = y or math.random(0, love.graphics.getHeight() - 64)
    Laser.texture = love.graphics.newImage("resources/images/objects/laser.png")
    Laser.time = time
    Laser.alpha = 0
    Laser.isFading = false
    Laser.allowCollision = false
    Laser.hitbox = {}
    Laser.hitbox.x = player:position() - 300
    Laser.hitbox.y = Laser.y + 20
    Laser.hitbox.w = love.graphics.getWidth()
    Laser.hitbox.h = 24
    table.insert(laser.Lasers, Laser)
end

function laser.render()
    for k, Laser in pairs(laser.Lasers) do
        love.graphics.setColor(1, 1, 1, Laser.alpha)
        love.graphics.draw(Laser.texture, Laser.x, Laser.y, 0, 50, 1)
        love.graphics.setColor(1, 1, 1, 1)
        if Laser.allowCollision then
            love.graphics.setColor(1, 0, 0)
            love.graphics.rectangle("line", Laser.hitbox.x, Laser.hitbox.y, Laser.hitbox.w, Laser.hitbox.h)
            love.graphics.setColor(1, 1, 1, 1)
        end
    end
end

function laser.update(elapsed)
    for k, Laser in pairs(laser.Lasers) do
        if not Laser.isFading then
            Laser.alpha = Laser.alpha + Laser.time
        else
            Laser.alpha = Laser.alpha - Laser.time
        end
        if Laser.alpha > 1 then
            Laser.isFading = true
            Laser.allowCollision = true
        end
        if Laser.alpha < 0.6 then
            Laser.allowCollision = false
        end
        if Laser.alpha < 0 then
            table.remove(laser.Lasers, k)
        end
    end
end

return laser