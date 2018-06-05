## Motan-OpenResty Demo 示例 / ([中文文档](README-zh.md))

*Motan-OpenResty.*


# 快速开始

## 安装 Motan-OpenResty （支持裸机和 Docker）

#### *裸机安装（细节请参考 [Motan-OpenResty](https://github.com/weibocom/motan-openresty) 安装文档）*

``` bash
git clone https://github.com/weibocom/motan-openresty.git
cd motan-openresty
make install
```

#### *使用 Docker*

直接使用最新的 Docker 镜像（当前为 `zhoujing/motan-openresty:0.0.1`）

```bash
docker pull zhoujing/motan-openresty
```

## 运行本示例

* 直接运行根目录的 `run` 脚本
* 使用 docker-composer 命令
* 或者运行 `make up`、`make down` 等命令（也是运行的 docker-composer）

# 示例简述

## 目录布局

```bash
.
├── Makefile
├── README-zh.md
├── README.md
├── conf                                # Nginx 配置文件目录
│   ├── ...
├── dist.ini
├── docker-compose.yml
├── libs                                # Motan-OpenResty 实现的 so 库（生产环境可能需要根据不同平台编译安装）
│   ├── ...
├── logs                                # Nginx 日志目录
│   ├── ...
├── lua                                 # 应用代码目录
│   ├── client_demo.lua                 # Motan-OpenResty Client 示例 （其中有对本机 Server 的调用示例）
│   ├── env                             # 项目支持的默认环境配置（须保证项目可以加载相关包： local sys_conf = require("env." .. singletons.var["ENV_STR"])）
│   │   ├── development.lua
│   │   └── production.lua
│   └── motan-service                   # Motan-OpenResty Service 存放路径，根据 env 配置中的 namespace 进行加载
│       ├── HelloWorldService.lua
│       └── sys
│           ├── MOTAN_CLIENT_CONF
│           └── MOTAN_SERVER_CONF
└── run                                 # 运行脚本
```

## 关键配置

以下是一个 Motan-OpenResty 项目须关注的关键配置（详情请参考[更多](# 更多信息)）

```lua
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
```

# 更多信息

- 参见 [文档](https://github.com/weibocom/motan-openresty)

# License

Motan is released under the 
[Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0).