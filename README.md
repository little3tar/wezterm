# WezTerm 配置

<div align="center">
  <img src="https://raw.githubusercontent.com/wezterm/wezterm/main/assets/icon/wezterm-icon.svg" width="110" height="100" />
</div>

<p align="center">
基于 Rust 的 GPU 加速跨平台终端 · WebGPU 渲染 · 60 FPS
</p>

## 核心特性

**外观**

- 🎨 Catppuccin Mocha 配色 + 动态背景切换
- 📊 双侧状态栏（时间/电池/Leader 模式指示）
- 🖼️ 半透明背景（96% 不透明度）+ 集成标题栏

**交互**

- ⌨️ 完全自定义快捷键（禁用默认，从零构建）
- 🎯 Leader 键模式（字体/窗格调整）
- 🔗 智能 URL 提取（支持多种括号格式）
- 🚀 F6 快捷命令菜单（代理/更新）

**架构**

- 🔧 模块化配置（config/events/utils 分离）
- 🌐 跨平台适配（Windows/macOS/Linux）
- 🐧 WSL/SSH 域集成
- ✨ 启动自动最大化窗口

## 快速开始

### 安装

```bash
# 1. 安装 WezTerm
# 从 https://github.com/wezterm/wezterm/releases 下载

# 2. 安装字体（必需 Nerd Font 支持图标）
# JetBrainsMono Nerd Font: https://github.com/ryanoasis/nerd-fonts/releases
# 鸿蒙黑体（可选，中文显示）

# 3. 部署配置
# Windows
git clone <your-repo> %USERPROFILE%\.config\wezterm

# Linux/macOS
git clone <your-repo> ~/.config/wezterm
```

### 首次配置

**修改 WSL 配置**（如果使用 WSL）

编辑 `config/domains.lua`：

```lua
wsl_domains = {
   {
      name = 'WSL:Ubuntu',
      distribution = 'Ubuntu',  -- 你的 WSL 发行版名称
      username = 'your-username',  -- wsl whoami
      default_cwd = '/home/your-username',
      default_prog = { 'bash', '-l' },  -- 或 'fish', 'zsh'
   },
},
```

**添加 SSH 连接**（可选）

在 `config/domains.lua` 中添加：

```lua
ssh_domains = {
   {
      name = 'MyServer',
      remote_address = '192.168.1.100',
      username = 'root',
   },
},
```

**自定义背景**

将图片放入 `backdrops/` 目录（支持 jpg/png/gif）

## 配置结构

```
wezterm/
├── wezterm.lua          # 主入口（加载所有模块）
├── config/              # 配置模块
│   ├── init.lua            # Config 类（合并配置）
│   ├── appearance.lua      # 外观（WebGPU/配色/背景/标签栏）
│   ├── bindings.lua        # 快捷键（完全自定义）
│   ├── domains.lua         # WSL/SSH/Unix 域
│   ├── fonts.lua           # 字体（JetBrains Mono + 鸿蒙黑体）
│   ├── general.lua         # 通用（滚动/超链接/行为）
│   └── launch.lua          # 启动（默认 shell/启动菜单）
├── events/              # 事件处理
│   ├── left-status.lua     # 左状态栏（Leader/KeyTable 指示）
│   ├── right-status.lua    # 右状态栏（时间/电池）
│   ├── tab-title.lua       # 标签页标题
│   └── new-tab-button.lua  # 新标签按钮
├── utils/               # 工具函数
│   ├── backdrops.lua       # 背景管理（切换/随机）
│   ├── platform.lua        # 平台检测
│   ├── gpu_adapter.lua     # GPU 适配器选择
│   └── math.lua            # 数学工具
├── colors/
│   └── custom.lua          # Catppuccin Mocha 配色
├── backdrops/           # 背景图片目录
├── KEYBINDINGS.md       # 快捷键文档
├── README.md            # 项目说明
├── .editorconfig        # 编辑器统一配置
├── .stylua.toml         # Lua 格式化规则
├── .luarc.json          # Lua LSP 配置
├── selene.toml          # Lua 代码检查规则
└── .gitignore           # Git 忽略规则
```

## 快捷键

> 完整快捷键说明：[KEYBINDINGS.md](./KEYBINDINGS.md)

### 核心快捷键

| 类别       | 快捷键             | 功能                  |
| ---------- | ------------------ | --------------------- |
| **功能键** | `F2`               | 命令面板              |
|            | `F3`               | 启动器（WSL/SSH）     |
|            | `F6`               | 快捷命令（代理/更新） |
| **标签页** | `Alt+Enter`        | 新建标签页            |
|            | `Alt+W`            | 关闭标签页            |
|            | `Alt+H/L`          | 切换标签页            |
| **窗格**   | `Alt+\`            | 垂直分割              |
|            | `Alt+Ctrl+\`       | 水平分割              |
|            | `Alt+Ctrl+H/J/K/L` | Vim 风格导航          |
| **背景**   | `Alt+/`            | 随机切换              |
|            | `Alt+,` / `Alt+.`  | 上一张/下一张         |
| **其他**   | `Alt+U`            | 智能提取 URL          |
|            | `Alt+F`            | 搜索                  |

### Leader 键模式

按 `Alt+Ctrl+Space` 激活 Leader 模式：

- `Leader + F` → 字体调整模式（K/J 放大缩小，R 重置）
- `Leader + P` → 窗格调整模式（H/J/K/L 调整大小）

### F6 快捷命令

- **Set Proxy (Windows)** - PowerShell 代理设置
- **Set Proxy (Linux)** - Bash/Zsh 代理设置
- **Agent Update** - 更新 AI CLI 工具（claude/opencode/codex/gemini）

## 使用技巧

### 域（Domains）使用

**访问 WSL**

- 按 `F3` → 选择 "WSL:Ubuntu"
- 或在启动菜单中选择

**连接 SSH**

- 配置 `config/domains.lua` 后
- 按 `F3` → 选择你的 SSH 服务器
- 自动保持连接，像本地标签页一样使用

**自动启动到 WSL**

在 `config/domains.lua` 中取消注释：

```lua
default_gui_startup_args = { 'connect', 'WSL:Ubuntu' },
```

### 背景管理

- `Alt+/` - 随机切换（适合每天换心情）
- `Alt+Ctrl+/` - 打开选择器（模糊搜索）
- `Alt+,` / `Alt+.` - 顺序切换

### 多任务工作流

**场景 1：开发 + 监控**

1. `Alt+\` 垂直分割
2. 上方运行开发服务器
3. 下方查看日志

**场景 2：多项目切换**

1. 每个项目一个标签页
2. `F4` 模糊搜索快速跳转
3. `Alt+H/L` 顺序切换

## 自定义配置

### 修改字体

编辑 `config/fonts.lua`：

```lua
font = wezterm.font_with_fallback({
   'Your Font',
   'Fallback Font',
}),
font_size = 12,
```

### 修改配色

编辑 `colors/custom.lua` 或使用内置主题：

```lua
-- config/appearance.lua
color_scheme = 'Catppuccin Mocha',  -- 或其他主题
```

### 修改快捷键

编辑 `config/bindings.lua`，注意跨平台适配：

- Windows/Linux: `mod.SUPER` = `ALT`
- macOS: `mod.SUPER` = `SUPER` (Cmd)

## 开发

本配置包含开发工具配置（可选）：

**`.stylua.toml`** - Lua 代码格式化规则

- 120 字符列宽
- 2 空格缩进
- 单引号优先

**`selene.toml`** - Lua 代码检查规则

- 忽略 `wezterm` 和 `vim` 全局变量
- 未定义变量警告

```bash
# 安装并使用
cargo install stylua selene

# 格式化代码
stylua .

# 检查代码
selene .
```

## 致谢

参考项目：

- [KevinSilvester/wezterm-config](https://github.com/KevinSilvester/wezterm-config)
- [vivy89/wezterm-config](https://github.com/vivy89/wezterm-config)

## 许可证

MIT License
