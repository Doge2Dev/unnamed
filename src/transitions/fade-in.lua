local transition = {}
local color = {}

local fadeLength = 2 -- How long the fade effect lasts in seconds
local time = 0       -- Current amount of time the effect has lasted

-- This is just for getting colors to work across love versions
-- In love 11 colors are values of 0-1, unlike earlier versions.
local major, minor, revision, _ = love.getVersion()

-- State that is set when the transition is loaded
function transition.load()
  color.r = 255
  color.b = 255
  color.g = 255
  color.a = 255

  -- If version is 11.
  if major == 11 and minor >= 0 and revision >= 0 then
    color.r = color.r/255
    color.b = color.b/255
    color.g = color.g/255
    color.a = color.a/255
  end
end

-- The transitions update loop
function transition.update(dt)
  time = time + dt
  if major == 11 and minor >= 0 and revision >= 0 then
    color.a = 1 - (time/fadeLength)*1;
  else
    color.a = 255 - (time/fadeLength)*255;
  end

  if color.a < 0 then
    -- Call resulting function (second param on TM.load)
    TM.result(TM.params)
  end
end

-- The transitions render loop
function transition.draw()
  love.graphics.setColor(color.r, color.g, color.b, color.a)
  love.graphics.rectangle(
    "fill",
    0,
    0,
    love.graphics.getWidth(),
    love.graphics.getHeight()
  )
end

return transition
