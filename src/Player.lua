player = {}

atlasparser = require 'src.components.AtlasParser'

function player:set(x, y)
    self.x = x
    self.y = y
    self.img, self.quads = atlasparser.getQuads("player")
    self.hitbox = {}
    self.hitbox.x = x
    self.hitbox.y = y
    self.hitbox.w = 76
    self.hitbox.h = 32
    self.AnimFrame = 1
    self.AnimFrameUpdate = 0
end

function player:render()
    love.graphics.draw(self.img, self.quads[self.AnimFrame], self.x, self.y, 0, 1.5, 1.5, 18, 20)
end

function player:update(elapsed)
    if isPlayerAlive then
        if love.keyboard.isDown(Controls.Keyboard.UP) then
            self.y = self.y - 5
        end
        if love.keyboard.isDown(Controls.Keyboard.DOWN) then
            self.y = self.y + 5
        end
        if love.keyboard.isDown(Controls.Keyboard.LEFT) then
            self.x = self.x - 5
        end
        if love.keyboard.isDown(Controls.Keyboard.RIGHT) then
            self.x = self.x + 5
        end
    end

    if self.x < math.floor(editorOffset) - love.graphics.getWidth() / 2 then
        self.x = self.x + 5
    end
    if self.x + self.hitbox.w > math.floor(editorOffset) + love.graphics.getWidth() / 2 then
        self.x = self.x - 5
    end
    if self.y < 0 then
        self.y = self.y + 5
    end
    if self.y + self.hitbox.h > love.graphics.getHeight() then
        self.y = self.y - 5
    end

    if isPlayerAlive then
        if joystick ~= nil then
            if joystick:isGamepadDown(Controls.Gamepad.UP) then
                self.y = self.y - 5
            end
            if joystick:isGamepadDown(Controls.Gamepad.DOWN) then
                self.y = self.y + 5
            end
            if joystick:isGamepadDown(Controls.Gamepad.LEFT) then
                self.x = self.x - 5
            end
            if joystick:isGamepadDown(Controls.Gamepad.RIGHT) then
                self.x = self.x + 5
            end

            self.x = self.x + (5 * joystick:getGamepadAxis("leftx"))
            self.y = self.y + (5 * joystick:getGamepadAxis("lefty"))
        end
    end

    self.hitbox.x = self.x
    self.hitbox.y = self.y

    -- animtion controller
    self.AnimFrameUpdate = self.AnimFrameUpdate + 1
    if self.AnimFrameUpdate > 20 then
        self.AnimFrame = self.AnimFrame + 1
        self.AnimFrameUpdate = 0
        if self.AnimFrame > 3 then
            self.AnimFrame = 1
        end
    end
end

-- expose hitbox table
function player:getHitbox()
    return self.hitbox
end

function player:position()
    return self.x, self.y
end

return player