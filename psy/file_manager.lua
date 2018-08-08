--MODULE WITH FOR HANDLING SAVING/LOADING AND OTHER FILES STUFF--

local fm = {}

local _default_savefile_args = {
    continue = false,  --Continue status
    used_continue = false, --If player used a continue in the current run
    first_time = true, --Make player play the tutorial the first time
    highscores = {     --Reset highscores with default values
        {name = "---", score = 0},
        {name = "---", score = 0},
        {name = "---", score = 0},
        {name = "---", score = 0},
        {name = "---", score = 0}
    },
    gamepad_mapping = { --Mapping of generic joystick buttons
      start = 4,
      confirm = 15,
      back = 14,
      shoot = 12,
      ultrablast1 = 10,
      ultrablast2 = 9,
      focus = 11,
      laxis_horizontal = 1,
      laxis_vertical = 2,
      raxis_horizontal = 3,
      raxis_vertical = 4,
    }
}

--[[Load from the save files and return arguments. If not found save or metafiles, will create new ones.
ARGUMENTS(format):

continue(x.y): if x.y exists, it tells which level the player stopped playing (level x, part y). Can be false if there isn't one

used_continue(bool): true if player has used continue in current run. False otherwise

first_time(bool): true if player never played, false otherwise

highscore(table): table of tuplets "name" and "score" for correspondent highscore

]]
function fm.load()
    local args, sucess, err, file, content

    print("---------------------------")

    --Looks for a metafile
    if love.filesystem.isFile("metafile") then
        print("Metafile found")

        content = love.filesystem.read("metafile") --Get string from file

        args, err = Tserial.unpack(content, true) --Get table from metafile
        if err then print("Problem loading the current metafile. Error:"); print(err); os.exit() end

        --Check if versions are different, and handle conflicts
        if args["version"] ~= SAVE_VERSION then
            --For now, just delete metafile and savefile if version is different
            print("Version of save you are using is not compatible. You have version "..args["version"].." while the game is using version "..SAVE_VERSION)
            print("Will now delete current metafile and savefile and create compatible ones")

            sucess = love.filesystem.remove("metafile")
            if sucess then
                print("Metafile sucessfully removed")
            else
                print("Couldn't erase metafile. Please erase metafile manually and restart the game")
                os.exit()
            end

        end
    else
        print("Metafile not found")
    end

    --If there isn't a metafile (or there was and it was deleted), create one
    if not love.filesystem.isFile("metafile") then
        print("Creating a new metafile. Save version is "..SAVE_VERSION)

        file, err = love.filesystem.newFile("metafile", 'w') --Create metafile file
        if err then print("Problems on creating metafile:", err); os.exit() end

        content = Tserial.pack({version = SAVE_VERSION}) --Pack table with version

        sucess = love.filesystem.write("metafile", content) --Write the version of the save
        if not sucess then print("Can't write on the created metafile"); os.exit() end

        file:close() --Close metafile
    end


    ------------------------

    --Looks for a savefile
    if not love.filesystem.isFile("savefile") then
        print("Savefile not found. Creating a new savefile")

        file, err = love.filesystem.newFile("savefile", "w") --Create savefile file
        if err then print("Problems on creating savefile:", err); os.exit() end

        --Copy default arguments for savefile
        args = {}
        for i,k in pairs(_default_savefile_args) do
            args[i] = k
        end

        content = Tserial.pack(args) --Serialize the table into a string

        sucess = love.filesystem.write("savefile", content) --Write the version of the save
        if not sucess then print("Can't write on the created savefile"); os.exit() end

        file:close() --Close savefile
    else
        print("Found savefile")
    end

    content = love.filesystem.read("savefile") --Get string from savefile

    args, err = Tserial.unpack(content, true) --Get table from savefile
    if err then print("Problem loading the current savefile. Error:"); print(err); os.exit() end

    --Checks if there is any undefined (missing) field in savefile arguments
    --(compares with default savefile args)
    for index,value in pairs(_default_savefile_args) do
        if args[index] == nil then
            args[index] = value
            print("Missing field "..tostring(index).." was added on default value to your savefile.")
        end
    end

    print("---------------------------")

    return args
end

--Attempts to save all content into savefile. If successful, returns true. Returns false otherwise.
function fm.save()
    local args, content

    --Save all status on the files
    args = {
        continue = CONTINUE,
        used_continue = USED_CONTINUE,
        first_time = FIRST_TIME,
        highscores = {},
        gamepad_mapping = {},
    }
    for i,k in ipairs(HIGHSCORES) do
        args.highscores[i] = k
    end
    for i,k in pairs(GAMEPAD_MAPPING) do
        args.gamepad_mapping[i] = k
    end

    content = Tserial.pack(args) --Transform data into a string

    local sucess = love.filesystem.write("savefile", content) --Update game data on the savefile

    if not sucess then
        return false
    else
        return true
    end

end

--Return functions
return fm
