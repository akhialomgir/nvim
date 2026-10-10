# Personal Neovim configuration

基于 LazyVim，保留透明 Catppuccin、Telescope 搜索、标签页/分屏快捷键、颜色预览、Incline 文件名、Zen Mode，以及 TypeScript / Tailwind / JSON / CSS / HTML / YAML 支持。新增完整 Go 开发支持。

## 安装

需要 Neovim ≥ 0.11.2（LuaJIT）、Git、C 编译器、Node.js / npm，以及 Go。macOS 示例：

```sh
brew install neovim git ripgrep fd fzf lazygit tree-sitter-cli node go
brew install --cask font-jetbrains-mono-nerd-font
# 若已有配置，先备份 ~/.config/nvim，勿覆盖自己的改动。
git clone https://github.com/akhialomgir/nvim.git ~/.config/nvim
nvim
```

首次启动会下载插件、Treesitter 解析器和 Mason 工具。保持 Neovim 打开，等 `:Lazy` 和 `:Mason` 的安装任务完成。用 `:LazyHealth` 检查环境。

在 iTerm2 的 Settings → Profiles → Text 选择 **JetBrainsMono NFM**，建议 14 号。终端控制字体；Nerd Font 提供图标，中文由 macOS 字体回退显示。此仓库不修改终端偏好或写入个人代理地址。

网络需要代理时，在启动命令前设置自己的 `https_proxy` / `http_proxy`；插件、Mason 和解析器安装会继承它们。Go 模块下载可按自己的网络环境配置 `GOPROXY`。

## Go

Go 支持采用 [LazyVim Go extra](https://www.lazyvim.org/extras/lang/go)，调试采用 DAP extra：

- `gopls`：补全、跳转、重命名、诊断、代码操作；自动识别 `go.mod` / `go.work`。
- `goimports` + `gofumpt`：保存时整理 import、格式化。
- `golangci-lint`：集成诊断，遵循项目的 `.golangci.yml` / `.golangci.yaml` 配置。
- Go / gomod / gowork / gosum 语法解析器。
- Delve / nvim-dap-go：运行、断点、单步调试；从父目录打开 Go 文件也会按模块目录构建。也可用 `:lua require('dap-go').debug_test()` 调试光标所在测试。

`gd` 跳转定义（保留 Telescope、不复用窗口），`K` 查看文档，`<leader>cr` 重命名，`<leader>ca` 代码操作，`<leader>cf` 格式化。`<leader>db` 设置断点、`<leader>dc` 运行/继续、`<leader>dt` 终止，`<leader>du` 打开调试面板。Go 测试可在终端运行 `go test ./...`。

内联提示默认关闭；`<leader>i` 对当前缓冲区切换。`:ToggleAutoformat` 切换全局保存自动格式化，LazyVim 的 `<leader>uf` / `<leader>uF` 仍然可用。

## 保留的个人操作

Leader 是空格。

| 操作 | 按键 |
| --- | --- |
| 搜索文件 / 内容 | `;f` / `;r` |
| 缓冲区 / 帮助 / 恢复搜索 | `\\` / `;t` / `;;` |
| 诊断 / 文档符号 / 调入调用 | `;e` / `;s` / `;c` |
| 当前目录文件浏览器 | `sf` |
| 查找插件文件 | `<leader>fP` |
| 新标签页 / 下一页 / 上一页 | `te` / Tab / Shift-Tab |
| 横向 / 纵向分屏 | `ss` / `sv` |
| 移动到分屏 | `sh` / `sj` / `sk` / `sl` |
| 全选 / 智能递增 / 递减 | Ctrl-A / `+` / `-` |
| 不污染寄存器的字符删除 | `x` |
| 从 yank 寄存器粘贴 | `<leader>p` / `<leader>P` |
| 不污染寄存器的修改 / 删除 | `<leader>xc` / `<leader>xd`（大写处理到行尾） |
| 十六进制颜色转 HSL | 光标放在 `#RGB` 或 `#RRGGBB`，按 `<leader>r` |
| Git blame / 打开 GitHub 页面 | `<leader>gb` / `<leader>go` |
| 清理隐藏 / 无名缓冲区 | `<leader>th` / `<leader>tu` |
| 专注模式 | `<leader>z` |

## 本次迁移

- 缺失的 `craftzdog.hsl` / `craftzdog.lsp` 改为本地颜色工具和 Neovim / LazyVim API。
- TypeScript 的 `tsserver` 改为当前 TypeScript extra 的 `vtsls`；去掉强制 `.git` 根目录，恢复语言服务的项目识别。
- 旧 Treesitter Playground / query-linter 改用 Neovim 内置 `:InspectTree` / `:EditQuery`；保留额外语言和 MDX，高亮/缩进沿用 LazyVim 配置。
- 将 `<leader>c` / `<leader>d` 的寄存器操作移到 `<leader>x…`，释放代码操作和 DAP 快捷键组。移除会覆盖 Enter 的 Ctrl-M 映射；解决 Ctrl-A 全选与 Dial 递增的冲突。
- Incline 复用 Catppuccin 配色和 MiniIcons；Git 浏览/Blame 复用 Snacks / Gitsigns。移除 Linux `notify-send` 路由。
- 不再安装未被配置使用的 selene / luacheck；当前插件不依赖 LuaRocks，因此关闭其自动安装。
- 更新 `lazy-lock.json`，记录验证过的插件版本。

## 更新与验证

```vim
:Lazy sync
:Mason
:LazyHealth
```

Lua 格式检查：`stylua --check init.lua lua`。更新插件后建议打开一个 Go 模块，确认 `:LspInfo` 中 `gopls` 已连接，并检查保存格式化、`gd`、补全和调试。

没有安装 PHP / Java / Rust 等运行时或远程插件宿主时，完整健康报告可能提示可选依赖缺失；关闭的终端图片预览也会报告可选工具。按实际使用的语言补装即可。

### 本次验证（2026-10-10）

环境：Apple Silicon、Neovim 0.12.6、Go 1.27.2。验证了插件启动、Telescope 的 fzf / file-browser 扩展、颜色转换、自定义按键及自动格式化开关，以及 Go 解析、gopls 连接/定义跳转/补全/错误诊断、goimports + gofumpt 和 `go test ./...`。

Delve 1.27.2 已安装，DAP 握手及模块目录构建已验证；本机的实际断点验证停在 macOS `debugserver` 的进程附加阶段，因此未宣称调试完全通过。系统 Developer mode 当前关闭。若终端运行 `dlv debug` 也停住，请检查系统对所用终端的 Developer Tools 权限并处理 macOS 的调试授权提示；这里没有自动修改系统调试权限。
