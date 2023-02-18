atlasparser = {}

debugcomponent = require 'src.components.Debug'

function atlasparser.getQuads(filename)
    local image = love.graphics.newImage("resources/images/" .. filename .. ".png")
    local jsonData = love.filesystem.read("resources/images/" .. filename .. ".json")
    local sparrow = json.decode(jsonData)

    local Quads = {}
    for i = 1, #sparrow.frames, 1 do
        local Quad = love.graphics.newQuad(
            sparrow.frames[i].frame.x,
            sparrow.frames[i].frame.y,
            sparrow.frames[i].frame.w,
            sparrow.frames[i].frame.h,
            image
        )

        table.insert(Quads, Quad)
    end
    return image, Quads
end

return atlasparser