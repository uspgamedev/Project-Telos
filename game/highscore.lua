--MODULE WITH FOR HANDLING HIGHSCORES AND STUFF--

local hs = {}

--[[Highscore table: Goes from 1 to MAX_HIGHSCORE, where HIGHSCORES[1] is the biggest score, and
   HIGHSCORES[MAX_HIGHSCORE] is the lowest ]]

--Print all highscores on the terminal (for debugging purposes)
function hs.print()

    if not HIGHSCORES then
        print("Highscores not found")
        return
    end

    print("--HIGHSCORE--")
    for i = 1, MAX_HIGHSCORE do
        print(HIGHSCORES[i].name, HIGHSCORES[i].score)
    end
    print("-----------")

end

--Reset all highscores to name "---" and score 0
function hs.reset()

    for i = 1, MAX_HIGHSCORE do
        HIGHSCORES[i].name = "---"
        HIGHSCORES[i].score = 0
    end
    print("---------\nHighscores reseted\n---------")

end

--If given score will enter highscore, return the position it will enter. Returns false otherwise. Ties will always enter.
function hs.isHighscore(score)

    for i = 1, MAX_HIGHSCORE do
        if HIGHSCORES[i].score <= score then return i end
    end

    return false
end

--Add a name (3 letters only) and score to the highscore table.
--IMPORTANT: Score given must be inside highscore table. Score at worst case will always enter last position
function hs.addHighscore(name, score)

    local position = MAX_HIGHSCORE
    --Find position for new score
    for i = 1, MAX_HIGHSCORE do
        if HIGHSCORES[i].score <= score then
            position = i
            break
        end
    end

    local temp_name = HIGHSCORES[position].name
    local temp_score = HIGHSCORES[position].score
    --Shift every position to the one below
    for j = MAX_HIGHSCORE, position+1,-1 do
        HIGHSCORES[j].name = HIGHSCORES[j-1].name
        HIGHSCORES[j].score = HIGHSCORES[j-1].score
    end

    --Update highscore table with new score and name
    HIGHSCORES[position].score = score
    HIGHSCORES[position].name = name

end



--Return functions
return hs
