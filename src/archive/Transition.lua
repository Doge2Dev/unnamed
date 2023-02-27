transition = {}

tween = require 'libraries.tween'

function transition.newIn(time)
    gradient = love.graphics.newImage("resources/images/transitionGradient.png")
    gradientPos = {y = love.graphics.getHeight()}

    gradientTween = tween.new(time, gradientPos, {y = -128})
end

function transition.newOut(time)
    gradient = love.graphics.newImage("resources/images/transitionGradient.png")
    gradientPos = {y = -128}

    gradientTween = tween.new(time, gradientPos, {y = -1200})
end

function transition.render()
    love.graphics.draw(gradient, 0, gradientPos.y)
end

function transition.update(elapsed)
    return gradientTween:update(elapsed)
end

return transition