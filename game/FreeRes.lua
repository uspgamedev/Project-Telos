--[[
    FreeRes - An easy way to resize your game.
     FreeRes is a library that makes adding multiple aspect ratio support to your game
     easily.
     It's been created to fill the hole that TLfres left after it became obsolete.
     Because of this its methods use the same names.
]]--
FreeRes = {} -- namespace

 local currentWidth, currentHeight, originalWidth, originalHeight, scale, scaleMultiplier, letterWidth, letterHeight, xLetter, yLetter

-- Sets up FreeRes, call on love.load() [and on resize]
--[[
param c = {w = currentScreenWidth, h = currentScrenHeight} (default = 800, 600)
param o = {w = originalScreenWidth, h = originalScrenHeight} (default = 800, 600)
]]--
function FreeRes.setScreen(scaleMultiplier)
  currentWidth = WINDOW_WIDTH
  currentHeight = WINDOW_HEIGHT
  originalWidth = ORIGINAL_WINDOW_WIDTH
  originalHeight = ORIGINAL_WINDOW_HEIGHT
  scaleMultiplier = scaleMultiplier or 1

  if currentWidth/currentHeight < originalWidth/originalHeight then
    scale = currentWidth/originalWidth
    xTranslate, yTranslate = 0, (currentHeight-(originalHeight*scale))/2
    letterWidth = love.graphics.getWidth()
    letterHeight = yTranslate
    xLetter = 0
    yLetter = yTranslate + originalHeight * scale
  elseif currentWidth/currentHeight > originalWidth/originalHeight then
    scale = currentHeight/originalHeight
    xTranslate, yTranslate = (currentWidth-(originalWidth*scale))/2, 0
    letterWidth = xTranslate
    letterHeight = love.graphics.getHeight()
    xLetter = xTranslate + originalWidth * scale
    yLetter = 0
  else xTranslate, yTranslate = 0, 0
    scale = currentWidth/originalWidth
    letterWidth, letterHeight = 0, 0
    xLetter, yLetter = 0, 0
  end

  scale = scale*scaleMultiplier
end

-- Transforms screen. Call at the beginning of love.draw()
function FreeRes.transform()
  love.graphics.push()
  love.graphics.translate(xTranslate, yTranslate)
  love.graphics.scale(scale, scale)
end

--Draw the letterbox. Call at the end of love.draw()
--[[
param color = {r, g, b, a} (defaults to black)
--]]
function FreeRes.letterbox(color)
  c = color or {255, 0, 0, 255}

  love.graphics.pop()
  love.graphics.setColor(c)
  -- Upper / Left letterbox
  love.graphics.rectangle("fill", 0, 0, letterWidth, letterHeight)

  -- Lower / Right letterbox
  love.graphics.rectangle("fill", xLetter, yLetter, letterWidth, letterHeight)
  love.graphics.setColor(255, 255, 255, 255)
end

--Returns current scale
function FreeRes.scale()
    return scale
end

--Returns distance the actual "gamewindow" starts from the game window top-left corner
function FreeRes.windowDistance()

    --Left/Right letterbox case
    if yLetter == 0 then
        return letterWidth, 0
    --Top/Bottom letterbox case
    else
        return 0, letterHeight
    end

end

function FreeRes.windowDimensions()

    --Left/Right letterbox case
    if yLetter == 0 then
        return WINDOW_WIDTH - 2*letterWidth, WINDOW_HEIGHT
    --Top/Bottom letterbox case
    else
        return WINDOW_WIDTH, WINDOW_HEIGHT - 2*letterHeight
    end
end

--Return functions
return FreeRes
