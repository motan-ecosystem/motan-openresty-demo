-- Copyright (C) idevz (idevz.org)


local _M = {
    _VERSION = '0.0.1'
}

local mt = {__index = _M}

-- @TODO add metadata to service_instance when new
function _M.new(self, opts)
    local helloworld = {
        name = "helloworld"
    }
    return setmetatable(helloworld, mt)
end

function _M.Hello(self, params, aaa)
    if type(params) == "string" then
        return "Motan OpenResty Lua: " .. params
    end
    local res
    for k,v in pairs(params) do
        res = "Motan OpenResty Lua: " .. k .. " ---> " .. sprint_r(v) .. "\n"
    end
    res = sprint_r({params, aaa})
    return res
end

return _M
