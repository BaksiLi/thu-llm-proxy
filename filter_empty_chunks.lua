local ctx = ngx.ctx

-- Initialize buffers for streaming if not already done
if not ctx.buffers then
    ctx.buffers = {}
    ctx.nbuffers = 0
end

local chunk = ngx.arg[1]  -- Current chunk of data
local eof = ngx.arg[2]    -- End-of-stream flag

if not eof then
    -- If the current chunk is not empty, add it to buffers
    if chunk and chunk ~= "" and chunk ~= "\n" then
        ctx.buffers[#ctx.buffers + 1] = chunk
        ngx.arg[1] = chunk  -- Pass the chunk to the client
    else
        ngx.arg[1] = nil  -- Drop empty chunks
    end
else
    -- On EOF, pass all remaining chunks (if necessary)
    if #ctx.buffers > 0 then
        ngx.arg[1] = table.concat(ctx.buffers)
    else
        ngx.arg[1] = nil  -- No data to send if all chunks were empty
    end
end

