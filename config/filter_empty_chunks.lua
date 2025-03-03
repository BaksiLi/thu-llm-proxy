local ctx = ngx.ctx

-- Initialize buffer if not already done
if not ctx.buffer then
    ctx.buffer = {}
end

local chunk = ngx.arg[1]  -- Current chunk of data
local eof = ngx.arg[2]    -- End-of-stream flag

if not eof then
    if chunk then
        -- Process multi-line chunks by splitting and filtering
        local lines = {}
        local empty_data_pattern = "^data:%s*\r?\n"
        local empty_line_patterns = {"data:\n", "data: \n"}
        
        for line in string.gmatch(chunk, "[^\n]+\n?") do
            local keep_line = true
            
            -- Check if this is an empty data line
            if string.match(line, empty_data_pattern) then
                keep_line = false
            else
                for _, pattern in ipairs(empty_line_patterns) do
                    if line == pattern then
                        keep_line = false
                        break
                    end
                end
            end
            
            if keep_line then
                table.insert(lines, line)
            end
        end
        
        -- Reassemble the filtered chunk
        if #lines > 0 then
            local filtered_chunk = table.concat(lines)
            table.insert(ctx.buffer, filtered_chunk)
            ngx.arg[1] = filtered_chunk
        else
            ngx.arg[1] = nil
        end
    else
        ngx.arg[1] = nil
    end
else
    if #ctx.buffer > 0 then
        ngx.arg[1] = table.concat(ctx.buffer)
        ctx.buffer = {}
    else
        ngx.arg[1] = nil
    end
end