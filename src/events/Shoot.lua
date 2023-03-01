shoot = {}

shoot.Shoots = {}

function shoot.new(x, y, speed)
    Shoot = {
        x = x or math.random(1, 5),
        y = y or math.random(1, 5),
        speed = speed or math.random(1, 5)
    }
    Shoot.texture = love.graphics.newImage("resources/images/objects/projectile.png")
    Shoot.w = 48--Shoot.texture:getWidth()
    Shoot.h = 48--Shoot.texture:getHeight()
    table.insert(shoot.Shoots, Shoot)
end

function shoot.render()
    for k, shoot in pairs(shoot.Shoots) do
        love.graphics.draw(shoot.texture, shoot.x, shoot.y, 0, 0.5, 0.5)
        love.graphics.rectangle("line", shoot.x, shoot.y, shoot.w, shoot.h)
    end
end

function shoot.update(elapsed)
    for k, shoot in pairs(shoot.Shoots) do
        shoot.x = shoot.x - shoot.speed
    end
end

return shoot