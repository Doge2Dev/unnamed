achievement = {}

function achievement:enter()
    atlasparser = require 'src.components.AtlasParser'
    Math = require 'src.Math'

    quicksand = love.graphics.newFont("resources/fonts/quicksand-light.ttf", 40)
    quicksand_bold = love.graphics.newFont("resources/fonts/quicksand-bold.ttf", 40)
    love.graphics.setFont(quicksand)

    achiev_img, achiev_quads = atlasparser.getQuads("GUI/achievements_atlas")
    bg = love.graphics.newImage("resources/images/bgs/game_bg5.png")
    cursor = love.graphics.newImage("resources/images/menu/cursor.png")

    CurrentSelection = 1
    cursorY = 90
    maxY = 0

    Achievements = {
        {title = "NixTripped", description = "Complete nip trip",  isCompleted = 1, tag = "niptrip"},
        {title = "Achievement2", description = "This is a teste2",  isCompleted = 1, tag = "test2"},
        {title = "Achievement3", description = "This is a teste3",  isCompleted = 1, tag = "test3"},
        {title = "Achievement4", description = "This is a teste4",  isCompleted = 1, tag = "test4"},
        {title = "Achievement5", description = "This is a teste5",  isCompleted = 1, tag = "test5"},
        {title = "Achievement6", description = "This is a teste6",  isCompleted = 1, tag = "test6"},
        {title = "Achievement7", description = "This is a teste7",  isCompleted = 1, tag = "test7"},
    }

    save()
    Achievements = load()
    print(debugcomponent.showTableContent(Achievements))
end

function achievement:draw()
    local y = 90
    effect(
        function()
            love.graphics.draw(bg, 0, 0, 0, 1.3, 1.3)
            for achiev_item = 1, #Achievements, 1 do
                love.graphics.draw(achiev_img, achiev_quads[Achievements[achiev_item].isCompleted], 90, y, 0, 0.15, 0.15)
                if Achievements[achiev_item].isCompleted == 1 then
                    love.graphics.print("?????", 190, y + 15)
                else
                    love.graphics.print(Achievements[achiev_item].title, 190, y + 15)
                end
                y = y + 80
            end
            maxY = y - 80
            love.graphics.draw(cursor, 40, cursorY + 15)
            love.graphics.print(Achievements[CurrentSelection].description, 100, 690)
        end
    )
end

function achievement:update(elapsed)
    if CurrentSelection < 1 then
        CurrentSelection = 1
    end
    if CurrentSelection > #Achievements then
        CurrentSelection = #Achievements
    end
    if cursorY < 90 then
        cursorY = 90
    end
    if cursorY > maxY then
        cursorY = maxY
    end
end

function achievement:keypressed(k)
    if k == Controls.Keyboard.SELECT_DOWN then
        CurrentSelection = CurrentSelection + 1
        cursorY = cursorY + 80
    end
    if k == Controls.Keyboard.SELECT_UP then
        CurrentSelection = CurrentSelection - 1
        cursorY = cursorY - 80
    end
    if k == Controls.Keyboard.BACK then
        save()
        gamestate.switch(states.Menu)
    end
end

function achievement:gamepadpressed(jstk, button)
    if joystick ~= nil then
        if joystick:isGamepadDown(Controls.Gamepad.SELECT_UP) then
            CurrentSelection = CurrentSelection - 1
            cursorY = cursorY - 80
        end
        if joystick:isGamepadDown(Controls.Gamepad.SELECT_DOWN) then
            CurrentSelection = CurrentSelection + 1
            cursorY = cursorY + 80
        end
        if joystick:isGamepadDown(Controls.Gamepad.BACK) then
            gamestate.switch(states.Menu)
        end
    end
end

function achievement:gamepadaxis(joystick, axis, value)
	if axis == "lefty" then
		if value == -1 then
            CurrentSelection = CurrentSelection - 1
            cursorY = cursorY - 80
        end
        if value == 1 then
            CurrentSelection = CurrentSelection + 1
            cursorY = cursorY + 80
        end
	end
end

-----------------------------------------------------

function save()
    local file = love.filesystem.getInfo("achievements.dat")
    if file == nil then
        local achievementSave = love.filesystem.newFile("achievements.dat", "w")
        achievementSave:write(json.encode(Achievements))
        achievementSave:close()
    else
        local achievementSave = love.filesystem.newFile("achievements.dat", "w")
        achievementSave:write(json.encode(Achievements))
        achievementSave:close()
    end
end

function load()
    return json.decode(love.filesystem.read("achievements.dat"))
end

function achievement.unlock(tag)
    for k, achievement in pairs(Achievements) do
        if achievement.tag == tag then
            achievement.isCompleted = 2
            save()
        end
    end
end

function achievement.lock(tag)
    for k, achievement in pairs(Achievements) do
        if achievement.tag == tag then
            achievement.isCompleted = 1
            save()
        end
    end
end

return achievement