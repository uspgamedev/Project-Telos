--[[--
--
-- Source Buffering Module
--
-- This module is a substitute to the library slam, which leaks memory.
-- We fix the buffer size of sources by type, and thus we work with a constant
-- amount of memory. If there is an overflow of buffer (meaning if we are
-- trying to play one sfx source more times than the buffer allows) we simply
-- won't play it.
--
--]]--

-----------------------------------
-- Constants ----------------------
-----------------------------------
local STATIC_BUFFER_SIZE = 40
local STREAM_BUFFER_SIZE = 4

-----------------------------------
-- Source Buffer Managing ---------
-----------------------------------
local Source = {}

function Source:__newindex(k)
    return error("Attempt to write to protected table")
end

function Source:__index(method)
    return Source[method] or function(_, ...)
        if method:sub(1,3) == 'get' or method:sub(1,2) == 'is' then
            local src = self:getLast()
            return src[method](src, ...)
        end
        local ret
        for idx = 1, self.buffer_size do
            local src = self.buffer[idx]
            ret = ret or src[method](src, ...)
        end
        return ret
    end
end
function Source:getLast()
    return self.buffer[(self.next_index + self.buffer_size - 2) % self.buffer_size + 1]
end
function Source:play()
    self.buffer[self.next_index]:play()
    self.next_index = self.next_index % self.buffer_size + 1
    return self:getLast()
end

-----------------------------------
-- Love Function Wrappings --------
-----------------------------------
local newSource = love.audio.newSource
function love.audio.newSource(filepath, mode)
    local new_src
    local buffer_size
    local buffer
    mode = mode or 'stream'
    if mode == 'static' then
      buffer_size = STATIC_BUFFER_SIZE
    elseif mode == 'stream' then
      buffer_size = STREAM_BUFFER_SIZE
    end
    buffer = {}
    for i = 1, buffer_size do
      buffer[i] = newSource(filepath, mode)
    end
    new_src = {
      buffer = buffer,
      buffer_size = buffer_size,
      next_index = 1,
    }
    return setmetatable(new_src, Source)
end
