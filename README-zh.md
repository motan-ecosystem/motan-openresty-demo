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

以下是一个 Motan-OpenResty 项目须关注的关键配置（详情请参考[更多](https://github.com/weibocom/motan-openresty)）

### Nginx 配置文件

Nginx 配置文件关注两个关键的点：

1. nginx.conf 中 `lua_package_path` 和 `lua_package_cpath` 的设置保证了 Motan-OpenResty 和 应用两部分包的正常加载。
2. motan-demo.conf 和 motan-stream-demo.conf 中，演示了在 OpenResty 的 HTTP 和 Stream 子系统中，Motan 的相关配置。

关键配置：

* `init_by_lua` 阶段初始化了 `motan`
* `init_worker_by_lua` 阶段完成了 Motan Client 和 Server 端的初始化

```bash
├── conf
│   ├── mime.types
│   ├── motan-demo.conf                 # OpenResty Http 子系统配置实例（演示 Motan Client 的配置）
│   ├── motan-stream-demo.conf          # OpenResty Stream 子系统配置实例（演示 Motan Server 通过 Stream 模块提供服务）
│   └── nginx.conf                      # 默认的应用 Nginx 启动配置，主要初始化了环境变量已经 Lua 和 C Lib 的加载路径
```

### 应用配置 （不同的运行环境加载不同的配置，默认为 `production` 生产环境）

应用配置关注以下四个关键点：

1. `singletons`，是 Motan-OpenResty 用来在 LuaVM 范围共享一些配置、常规数据的表。
2. `MOTAN_LUA_SERVICE_PERFIX` 是提供 RPC 服务的前缀设置，结合 `SERVICE_PATH` 的配置，比如在本示例中，`lua/motan-service/` 路径下面有个 `HelloWorldService` Service，那提供的服务便为 `com.weibo.motan.HelloWorldService`。
3. `MOTAN_LUA_SERVICE_PERFIX` 和 `SERVICE_PATH` 一起组合的服务及本示例提供的服务（Server），相关的 Server 的配置在 `lua/motan-service/sys/MOTAN_SERVER_CONF` 文件中。
4. 而 Client 所依赖的服务则在 `lua/motan-service/sys/MOTAN_CLIENT_CONF` 文件中配置。

运行配置：

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

Server 配置 `lua/motan-service/sys/MOTAN_SERVER_CONF`

```ini
[motan.service.direct_helloworld_service]               # 关注这里配置是 `motan.service` 表示提供的服务
port=2234
host=127.0.0.1
registry=direct-test-motan2
path=com.weibo.motan.HelloWorldService
basicRefer=example_base_service
```

Client 配置 `lua/motan-service/sys/MOTAN_CLIENT_CONF`

```ini
[motan.refer.direct_helloworld_service]                 # 关注这里配置是 `motan.refer` 表示依赖的服务
path=com.weibo.motan.HelloWorldService
registry=direct-test-motan2
basicRefer=example_basic_ref
```

# 更多信息

- 参见 [文档](https://github.com/weibocom/motan-openresty)

# License

Motan is released under the 
[Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0).