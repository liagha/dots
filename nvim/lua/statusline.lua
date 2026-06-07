local function current_keys()
    local keys = vim.fn.mode(1)
    if keys == "n" then return "" end
    local map = {
        i  = "INS",
        R  = "REP",
        v  = "VIS",
        V  = "V-L",
        ["\22"] = "V-B",
        c  = "CMD",
        t  = "TRM",
    }
    return " " .. (map[keys] or keys:upper()) .. " "
end

function vim.opt.statusline:expand()
    local parts = {}

    table.insert(parts, " %f")
    table.insert(parts, "%m")
    table.insert(parts, "%=%#ModeMsg#")
    table.insert(parts, current_keys())
    table.insert(parts, "%* %y")
    table.insert(parts, " %l:%c ")

    return table.concat(parts)
end
