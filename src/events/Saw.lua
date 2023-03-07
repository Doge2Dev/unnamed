saw = {}

saw.Saws = {}

function saw.new(x, y, speed, size)

    Saw = {
        speed = speed or math.random(1, 5),
        size = size,
    }
    
    Saw.texture = love.graphics.newImage("resources/images/objects/saw.png")
    Saw.x = x - (Saw.texture:getWidth() / 2)
    Saw.y = y - (Saw.texture:getHeight() / 2)
    Saw.w = Saw.texture:getWidth()
    Saw.h = Saw.texture:getHeight()
    Saw.hitbox = {}
    Saw.hitbox.x = Saw.x - Saw.texture:getWidth()
    Saw.hitbox.y = Saw.y - Saw.texture:getHeight()
    Saw.hitbox.w = Saw.texture:getWidth()
    Saw.hitbox.h = Saw.texture:getHeight()
    Saw.angle = 0
    table.insert(saw.Saws, Saw)
end

function saw.render()
    for k, saw in pairs(saw.Saws) do
        love.graphics.draw(
            saw.texture, saw.x, saw.y, saw.angle, saw.size, saw.size, Saw.texture:getWidth() / 2, Saw.texture:getHeight() / 2
        )
    end
end

function saw.update(elapsed)
    for k, saw in pairs(saw.Saws) do
        saw.x = saw.x - saw.speed
        saw.hitbox.x = saw.x - (Saw.texture:getWidth() / 2)
        saw.hitbox.y = saw.y - (Saw.texture:getHeight() / 2)
        saw.angle = saw.angle - 0.02
    end
end

return saw