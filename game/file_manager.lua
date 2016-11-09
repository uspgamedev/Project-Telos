--MODULE WITH FOR HANDLING SAVING/LOADING AND OTHER FILES STUFF--

local fm = {}

--[[Load from the save files and return arguments. If not found save or metafiles, will create new ones.
ARGUMENTS(format):

continue(x.y): if x.y exists, it tells which level the player stopped playing (level x, part y). Can be false if there isn't one

first_time(bool): true if player never played, false otherwise

]]
function fm.load()
    local args, sucess, err, file, content

    --Looks for a metafile
    if love.filesystem.isFile("metafile") then
        print("Metafile found")

        content = love.filesystem.read("metafile") --Get string from file

        args, err = Tserial.unpack(content, true) --Get table from metafile
        if err then print("Problem loading the current metafile. Error:"); print(err); os.exit() end

        --Check if versions are different, and handle conflicts
        if args["version"] ~= SAVE_VERSION then
            --For now, just delete metafile and savefile if version is different
            print("Version of save you are using is not compatible. You have version "..metafile_args["version"].." while the game is using version "..SAVE_VERSION)
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

        --Setting initial arguments for savefile
        args = {
            continue = false, --Reset continue status
            first_time = true --Make player play the tutorial the first time
        }

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


    return args

end



--Return functions
return fm
