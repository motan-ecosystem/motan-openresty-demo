-- Copyright (C) idevz (idevz.org)


local utils = require "motan.utils"
local singletons = require "motan.singletons"
local client_map = singletons.client_map
local http_method = ngx.req.get_method()
local params = {}
params = ngx.req.get_uri_args()
ngx.req.read_body()
local body = ngx.req.get_body_data()
if body ~= nil then
    if type(body) == "table" then
        for k,v in pairs(body) do
            params[k] = v
        end
    else
        -- single param get from request body for testing
        params = body
    end
end

local service_name = params["sn"] or "direct_helloworld_service"
local service_call_method_name = params["scmn"] or "Hello"
local service = client_map[service_name]
local service_method = service[service_call_method_name]
local res, err = service_method(service, params)
if err ~= nil then
    res = err
end
ngx.header["X-IDEVZ"] = 'idevz-k-49';
print_r("<pre/>")
print_r(ngx.req.get_headers())
if type(res) == "table" then
    res = sprint_r(res)
end
res = res or "empty"
ngx.say(table.concat({
    ">>> Motan-Mesh-HTTP: \n------->"..sprint_r(singletons.var["ENV_STR"]),
    http_method,
    "\n",
    res
}))