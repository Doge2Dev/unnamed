saw = {}

saw.Saws = {}

function saw.new(x, y, speed, size)

    Saw = {
        x = x or math.random(1, 5),
        y = y or math.random(1, 5),
        speed = speed or math.random(1, 5),
        size = size,
    }
    Saw.texture = love.graphics.newImage("resources/images/objects/saw.png")
    Saw.w = Shoot.texture:getWidth()
    Saw.h = Shoot.texture:getHeight()
    Saw.angle = 0
    table.insert(saw.Saws, Saw)
end

function saw.render()
    for k, saw in pairs(saw.Saws) do
        love.graphics.draw(saw.texture, saw.x, saw.y, saw.angle, saw.size, saw.size)
        love.graphics.rectangle("line", saw.x, saw.y, saw.w, saw.h)
    end
end

function saw.update(elapsed)
    for k, saw in pairs(saw.Saws) do
        saw.x = saw.x - saw.speed
        saw.angle = saw.angle - 0.02
    end
end

return saw