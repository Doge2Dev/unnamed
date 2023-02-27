local transition = {}

local box = {}
local color = {}

local slideLength = 2 -- How long the slide effect lasts in seconds
local time = 0        -- Current amount of time the effect has lasted

-- State that is set when the transition is loaded
function transition.load()
  box.x = -love.graphics.getWidth()
  box.y = 0
  box.w = love.graphics.getWidth()
  box.h = love.graphics.getHeight()
  color.r = 255
  color.b = 255
  color.g = 255
  color.a = 255
end

-- The transitions update loop
function transition.update(dt)
  time = time + dt
  box.x = (time/slideLength)*love.graphics.getWidth();

  if box.x >= love.graphics.getWidth() then
    -- Call resulting function (second param on TM.load)
    TM.result(TM.params)
  end
end

-- The transitions render loop
function transition.draw()
  love.graphics.setColor(color.r, color.g, color.b, color.a)
  love.graphics.rectangle(
    "fill",
    box.x,
    box.y,
    box.w,
    box.h
  )
end

return transition
