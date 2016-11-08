--MODULE WITH FOR HANDLING SAVING/LOADING AND OTHER FILES STUFF--

local fm = {}

--[[Load from the save files and return arguments. If not found save or metafiles, will create new ones.
ARGUMENTS(format):

continue(x.y): if x.y exists, it tells which level the player stopped playing (level x, part y). Can be false if there isn't one

first_time(bool): true if player never played, false otherwise

]]
function fm.load()
    local args, metafile_args, sucess, err, file

    args = {} --Table holding all necessary info from save

    --Looks for a metafile
    if love.filesystem.exists("metafile") then
        print("Metafile found.")

        metafile_args, err = table.load("metafile") --Load table from metafile
        if err then print("Can't load the current metafile. Error:"); print(err); os.exit() end

        --Check if versions are different, and handle conflicts
        if metafile_args["version"] ~= SAVE_VERSION then
            --For now, just delete metafile and savefile if version is different
            print("Version of save you are using is not compatible. You have version "..metafile_args["version"].." while the game is using version "..SAVE_VERSION)
            print("Will now delete current metafile and savefile and create compatible ones.")


        end
    else
        print("Metafile not found")
    end

    --If there isn't a metafile (or there was and it was deleted), create one
    if not love.filesystem.exists("metafile") then
        print("Creating a new metafile. Save version is "..SAVE_VERSION)

        file = love.filesystem.newFile("metafile") --Create metafile file

        sucess, err = table.save({version = SAVE_VERSION}, "metafile") --Save the version of the save
        if err then print("Can't save the created metafile. Error:"); print(err); os.exit() end
    end


    ------------------------

    --Looks for a savefile
    if not love.filesystem.exists("savefile") then
        print("Savefile not found. Creating a new savefile.")

        love.filesystem.newFile("savefile") --Create savefile file

        --Setting initial argumentsfor savefile
        args = {
            continue = false, --Reset continue status
            first_time = true --Make player play the tutorial the first time
        }

        sucess, err = table.save(args, "savefile") --Save the version of the save
        if err then print("Can't save the created metafile. Error:"); print(err); os.exit() end

    else
        print("Found savefile")
    end

    args, err = table.load("savefile") --Load table from savefile
    if err then print("Can't load the current savefile. Error:"); print(err); os.exit() end

    return args

end



--Return functions
return fm
