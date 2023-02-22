leveleditor = {}

function leveleditor:init()
    local UI = require 'src.states.resources.LevelEditorUIState'
    atlasparser = require 'src.components.AtlasParser'
    conductor = require 'src.components.Conductor'
    utilities = require 'src.Utilities'

    MapSettings = {
        speed = 1.0,
        Blocks = {}
    }

    bg = love.graphics.newImage("resources/images/bgs/game_bg5.png")
    tileImage, tileQuads = atlasparser.getQuads("atlas_sheet3")
    currentBlock = 1
    marker = {x=0, y=0}
    canPlace = true
    swipeMode = false
    UI.load()
    editorOffset = 0
end

function leveleditor:draw()
    love.graphics.draw(bg, 0, 0, 0, 1.3, 1.3)

    for x = 0, love.graphics.getWidth(), 32 do
        for y = 0, love.graphics.getHeight(), 32 do
            love.graphics.setColor(utilities.rgbToColor(255, 255, 255, 90))
            love.graphics.rectangle("line", x, y, 32, 32)
            love.graphics.setColor(utilities.rgbToColor(255, 255, 255, 255))
        end
    end
    love.graphics.setColor(utilities.rgbToColor(255, 0, 0, 255))
    love.graphics.rectangle("line", marker.x, marker.y, 32, 32)
    love.graphics.setColor(utilities.rgbToColor(255, 255, 255, 255))

    love.graphics.print("Swipe : " .. tostring(swipeMode), 10, 210)
    love.graphics.print(tostring(editorOffset), 10, 250)


    for k, Block in pairs(MapSettings.Blocks) do
        love.graphics.draw(tileImage, tileQuads[Block.id], Block.x - (editorOffset * 32), Block.y)
    end
    gui:draw()
end

function leveleditor:update(elapsed)
    gui:update(elapsed)
    marker.x = math.floor(love.mouse.getX() / 32) * 32
    marker.y = math.floor(love.mouse.getY() / 32) * 32
    if currentBlock < 1 then
        currentBlock = 1
    end
    if currentBlock > #tileQuads then
        currentBlock = #tileQuads
    end
    
    if mapSpeed.value ~= nil then
        MapSettings.speed = tonumber(mapSpeed.value)
    end

    if swipeMode then
        if love.mouse.isDown(1) and canPlace and not isHoverBlock(marker.x + (editorOffset * 32), marker.y) then
            placeBlock(marker.x + (editorOffset * 32), marker.y, currentBlock)
            print("block placed")
        end
        if love.mouse.isDown(2) then
            removeBlock(marker.x + (editorOffset * 32), marker.y)
            print("block deleted")
        end
    end
end

function leveleditor:keypressed (key, code, isrepeat)
	if gui.focus then
		gui:keypress(key) -- only sending input to the gui if we're not using it for something else
    end
    if key == "z" then
        if #Blocks > 0 then
            table.remove(MapSettings.Blocks, #Blocks)
        end
    end
    if key == "lctrl" then
        if swipeMode then
			swipeMode = false
		else
			swipeMode = true
		end
    end
end

function leveleditor:textinput(key)
	if gui.focus then
		gui:textinput(key)
	end
end

function leveleditor:mousepressed(x, y, button)
	gui:mousepress(x, y, button)

    if not swipeMode then
        if button == 1 and canPlace and not isHoverBlock(marker.x, marker.y) then
            placeBlock(marker.x + (editorOffset * 32), marker.y, currentBlock)
            print("block placed")
        end
        if button == 2 then
            removeBlock(marker.x + (editorOffset * 32), marker.y)
        end
    end
end

function leveleditor:mousereleased(x, y, button)
	gui:mouserelease(x, y, button)
end

function leveleditor:wheelmoved(x, y)
    if y > 0 then
        editorOffset = editorOffset + 1
    end
    if y < 0 then
        editorOffset = editorOffset - 1
    end
end

---------------------------------------------------------------

function placeBlock(x, y, id)
    Block = {
        x = x,
        y = y,
        w = 32,
        h = 32,
        id = id
    }

    table.insert(MapSettings.Blocks, Block)
end

function removeBlock(x, y)
    for k, block in pairs(MapSettings.Blocks) do
        if block.x == x then
            if block.y == y then
                table.remove(MapSettings.Blocks, k)
            end
        end
    end
end

function isHoverBlock(x, y)
    for k, block in pairs(MapSettings.Blocks) do
        if block.x == x then
            if block.y == y then
                print("is hover")
                return true
            else
                print("is not hover")
                return false
            end
        end
    end
end

return leveleditor