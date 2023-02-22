UIState = {}

function UIState.load()
    local xb = 250
    local mapName = gui:input("Map name", {x=80, y=10, w=96, h=24}, nil, "level")
    local saveButton = gui:button("save", {x=10, y=180, w=96, h=24})
    local loadButton = gui:button("load", {x=111, y=180, w=96, h=24})
    mapSpeed = gui:input("level speed", {x=80, y=80, w=96, h=24}, nil, "1.0")
    songname = gui:input("Music", {x=80, y=111, w=96, h=24}, nil, "dubnix")
    local loadSongButton = gui:button("load", {x=180, y=111, w=96, h=24})
    
    function songname.enter(this)
        canPlace = false
    end
    function songname.leave(this)
        canPlace = true
    end
    function loadSongButton.enter(this)
        canPlace = false
    end
    function loadSongButton.leave(this)
        canPlace = true
    end
    function mapSpeed.enter(this)
        canPlace = false
    end
    function mapSpeed.leave(this)
        canPlace = true
    end
    function mapName.enter(this)
        canPlace = false
    end
    function mapName.leave(this)
        canPlace = true
    end
    function saveButton.enter(this)
        canPlace = false
    end
    function saveButton.leave(this)
        canPlace = true
    end
    function loadButton.enter(this)
        canPlace = false
    end
    function loadButton.leave(this)
        canPlace = true
    end

    function loadSongButton.click(this, x, y, button)
        conductor.load(songname.value)
    end

    function saveButton.click(this, x, y, button)
        if mapName.value ~= nil then
            local mapdata = json.encode(MapSettings)
            local mapFile = love.filesystem.newFile(mapName.value .. ".lvl", "w")
            print("[EVENT] : File saved")
            mapFile:write(mapdata)
            mapFile:close()
        end
    end
    function loadButton.click(this, x, y, button)
        if mapName.value ~= nil then
            print(mapName.value)
            print("[EVENT] : File loaded")
            mapdata = love.filesystem.read("resources/data/maps/" .. mapName.value .. "/map.lvl")
            MapSettings = json.decode(mapdata)
        end
    end


    tileButton = {}
    for i = 1, #tileQuads, 1 do
        xb = xb + 36
        tileButton = gui:button("", {xb, y=12, w=32, h=32})
        tileButton:setimage("resources/images/icons/atlas_sheet3/tileicon" .. i .. ".png")
        function tileButton.click(this, x, y)
            currentBlock = i
        end
        function tileButton.enter(this)
            canPlace = false
        end
        function tileButton.leave(this)
            canPlace = true
        end
        table.insert(tileButton, tileButton)
    end
end


return UIState