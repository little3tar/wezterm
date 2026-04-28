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
# JetBrainsMono Nerd Font (NL/No-Ligatures 变体): https://github.com/ryanoasis/nerd-fonts/releases
# 鸿蒙黑体（可选，中文显示）

# 3. 部署配置
# Windows
git clone <your-repo> %USERPROFILE%\.config\wezterm

# Linux/macOS
git clone <your-repo> ~/.config/wezterm
```

### 首次配置

 **F3 启动器（Windows）**

按 `F3` 可打开启动器，选择不同 Shell 或 WSL 域：

- **PowerShell** - Windows 默认
- **Git Bash** - 推荐用于包管理工具（npm/pip/opencode 等）
- **Anaconda PowerShell** - 已激活 conda base 环境的 PowerShell，适合 Python 开发
- **CMD** - 传统命令提示符
- **WSL:Ubuntu** - Ubuntu WSL 环境（如果已配置）
- **WSL:Debian** - Debian WSL 环境（如果已配置）

> 提示：某些工具（如 opencode）在 Git Bash 中更新更稳定。Anaconda PowerShell 会自动激活 conda base 环境。WSL 域需要在 `config/domains.lua` 中配置。

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
   {
      name = 'WSL:Debian',
      distribution = 'Debian',  -- Debian 发行版名称
      username = 'your-debian-username',  -- Debian 中的用户名
      default_cwd = '/home/your-debian-username',
      default_prog = { 'bash', '-l' },
   },
},
```

> 提示：要查找 WSL 发行版的确切名称，运行 `wsl -l -v`。Debian 通常显示为 "Debian"。

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

将图片放入 `backdrops/` 目录（支持 jpg/png/gif），建议：

- 数量：10-30 张
- 单张大小：1-2MB
- 总大小：20MB 以内

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
├── LICENSE              # 许可证
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
|            | `Alt+Z`            | 最大化/还原窗格       |
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

- **Set Proxy (Windows)** - PowerShell 临时代理设置
   > `$env:http_proxy="http://127.0.0.1:2080"; $env:https_proxy="http://127.0.0.1:2080"`
- **Set Proxy (Linux)** - Bash/Zsh 临时代理设置
   > `export HTTP_PROXY=http://127.0.0.1:2080; export HTTPS_PROXY=http://127.0.0.1:2080`
- **Agent Update** - 更新 AI CLI 工具
   > `claude update; npm upgrade -g opencode-ai; npm upgrade -g @openai/codex; npm upgrade -g @google/gemini-cli`

## 使用技巧

### 域（Domains）使用

 **访问 WSL**

- 按 `F3` → 选择 "WSL:Ubuntu" 或 "WSL:Debian"（根据配置的 WSL 域）
- 或在启动菜单中选择

**连接 SSH**

- 配置 `config/domains.lua` 后
- 按 `F3` → 选择你的 SSH 服务器
- 自动保持连接，像本地标签页一样使用

 **自动启动到 WSL**

在 `config/domains.lua` 中取消注释并修改：

```lua
default_gui_startup_args = { 'connect', 'WSL:Ubuntu' },  -- 或 'WSL:Debian'
```

### 背景管理

- `Alt+/` - 随机切换（适合每天换心情）
- `Alt+Ctrl+/` - 打开选择器（模糊搜索）
- `Alt+,` / `Alt+.` - 顺序切换

### Python 开发工作流

**使用 Anaconda PowerShell**：

- 按 `F3` → 选择 "Anaconda PowerShell"
- 自动激活 conda base 环境，无需手动执行 `conda activate`
- 支持 conda 包管理和虚拟环境操作

**快速环境切换**：

1. 新建标签页 → 按 `F3` → 选择 "Anaconda PowerShell"
2. 使用 conda 命令创建/切换环境：`conda create -n myenv python=3.11`
3. 激活环境：`conda activate myenv`

**多环境并行**：

- 每个标签页可以运行不同的 conda 环境
- 使用 `Alt+\` 垂直分割，左侧运行开发服务器，右侧运行测试

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

### 修改 Shell 配置

编辑 `config/launch.lua` 调整启动菜单：

```lua
-- Windows 平台配置示例
if platform.is_win then
   options.launch_menu = {
      { label = 'PowerShell', args = { 'powershell' } },
      { label = 'Git Bash', args = { 'C:\\Program Files\\Git\\bin\\bash.exe', '-l' } },
      { label = 'CMD', args = { 'cmd' } },
      { label = 'Anaconda PowerShell', args = { 'powershell', '-ExecutionPolicy', 'ByPass', '-NoExit', '-Command', "& 'C:\\ProgramData\\miniconda3\\shell\\condabin\\conda-hook.ps1' ; conda activate 'C:\\ProgramData\\miniconda3'" } },
   }
end
```

> 提示：如果 Anaconda/Miniconda 安装在其他路径，修改 `C:\\ProgramData\\miniconda3` 为你的实际安装路径。

## 致谢

参考项目：

- [KevinSilvester/wezterm-config](https://github.com/KevinSilvester/wezterm-config)
- [vivy89/wezterm-config](https://github.com/vivy89/wezterm-config)

## 许可证

MIT License
