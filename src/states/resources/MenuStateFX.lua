fx = {}

fxs = {}

function fx.new(x, y)
    Fx = {}
    Fx.x = x
    Fx.y = y
    Fx.alpha = 1
    Fx.size = 0
    Fx.texture = love.graphics.newImage("resources/images/FX/fx.png")
    table.insert(fxs, Fx)
end

function fx.render()
    for k, FX in pairs(fxs) do
        love.graphics.setColor(1, 1, 1, FX.alpha)
        love.graphics.draw(FX.texture, FX.x, FX.y, 0, FX.size, FX.size, FX.texture:getWidth() / 2, FX.texture:getHeight() / 2)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function fx.update()
    for k, FX in pairs(fxs) do
        FX.alpha = FX.alpha - 0.01
        FX.size = FX.size + 0.01
        if FX.alpha < 0 then
            table.remove(fxs, k)
        end
    end
end

return fx