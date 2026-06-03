-- lua/statusline.lua

function vim.opt.statusline:expand()
    local parts = {}

    table.insert(parts, " %f")
    table.insert(parts, "%m")
    table.insert(parts, "%=")
    table.insert(parts, "%y")
    table.insert(parts, " %l:%c ")

    return table.concat(parts)
end
