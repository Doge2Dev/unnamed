shoot = {}

shoot.Shoots = {}

function shoot.new(x, y, xspeed, yspeed)
    Shoot = {
        x = x or love.graphics.getWidth(),
        y = y or math.random(48, love.graphics.getHeight()),
        xspeed = xspeed or math.random(1, 5),
        yspeed = yspeed or math.random(-5, 5),
    }
    Shoot.texture = love.graphics.newImage("resources/images/objects/projectile.png")
    Shoot.w = 48--Shoot.texture:getWidth()
    Shoot.h = 48--Shoot.texture:getHeight()
    table.insert(shoot.Shoots, Shoot)
end

function shoot.render()
    for k, bullet in pairs(shoot.Shoots) do
        love.graphics.draw(bullet.texture, bullet.x, bullet.y, 0, 0.5, 0.5)
    end
end

function shoot.update(elapsed)
    for k, bullet in pairs(shoot.Shoots) do
        bullet.x = bullet.x - bullet.xspeed
        bullet.y = bullet.y - bullet.yspeed
        if bullet.x < 0 then
            table.remove(shoot.Shoots, k)
        end
    end
end

return shoot