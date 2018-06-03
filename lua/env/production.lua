-- Copyright (C) idevz (idevz.org)


local singletons = require "motan.singletons"
local APP_ROOT = singletons.var["APP_ROOT"]
local sys_conf = {
        MOTAN_CLIENT_CONF_FILE = "MOTAN_CLIENT_CONF",
        MOTAN_SERVER_CONF_FILE = "MOTAN_SERVER_CONF",
        MOTAN_SERVICE_PROTOCOL = "motan2",
        MOTAN_LUA_SERVICE_PERFIX = "com.weibo.motan.",
        SERVICE_PATH = APP_ROOT .. "lua/motan-service",
    }

return sys_conf