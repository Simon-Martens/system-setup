local M = {}

local function module_path(name)
    return (name:gsub("%.", "/")) .. ".lua"
end

local function file_exists(path)
    local f = io.open(path, "r")
    if f then
        f:close()
        return true
    end

    return false
end

function M.safe_require(name)
    local path = module_path(name)
    local search_paths = {}

    for entry in package.path:gmatch("[^;]+") do
        if entry:find("%?%.lua", 1, false) then
            search_paths[#search_paths + 1] = entry:gsub("%?", name:gsub("%.", "/"))
        elseif entry:find("%?/init%.lua", 1, false) then
            search_paths[#search_paths + 1] = entry:gsub("%?", name:gsub("%.", "/"))
        end
    end

    local exists = false
    for _, candidate in ipairs(search_paths) do
        if file_exists(candidate) then
            exists = true
            break
        end
    end

    if not exists and not file_exists(path) then
        return nil
    end

    local ok, mod = pcall(require, name)
    if ok then
        return mod
    end

    return nil
end

return M
