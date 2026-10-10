return {
  -- messages, cmdline and the popupmenu
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })
      opts.commands = {
        all = {
          -- options for the message history that you get with `:Noice`
          view = "split",
          opts = { enter = true, format = "details" },
          filter = {},
        },
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(event)
          vim.schedule(function()
            require("noice.text.markdown").keys(event.buf)
          end)
        end,
      })

      opts.presets.lsp_doc_border = true
    end,
  },

  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 5000,
    },
  },

  {
    "snacks.nvim",
    opts = {
      scroll = { enabled = false },
    },
    keys = {},
  },

  -- buffer line
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },
    opts = {
      options = {
        mode = "tabs",
        -- separator_style = "slant",
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
  },

  -- filename
  {
    "b0o/incline.nvim",
    dependencies = { "nvim-mini/mini.icons", "catppuccin/nvim" },
    event = "BufReadPre",
    priority = 1200,
    config = function()
      local colors = require("catppuccin.palettes").get_palette("mocha")
      require("incline").setup({
        highlight = {
          groups = {
            InclineNormal = { guibg = colors.mauve, guifg = colors.base },
            InclineNormalNC = { guifg = colors.lavender, guibg = colors.mantle },
          },
        },
        window = { margin = { vertical = 0, horizontal = 1 } },
        hide = {
          cursorline = true,
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if vim.bo[props.buf].modified then
            filename = "[+] " .. filename
          end

          if filename == "" then
            filename = "[No Name]"
          end
          local icon, icon_hl = MiniIcons.get("file", filename)
          local color = vim.api.nvim_get_hl(0, { name = icon_hl, link = false }).fg
          return { { icon, guifg = color }, { " " }, { filename } }
        end,
      })
    end,
  },

  -- Keep the cwd-relative filename style from the original configuration.
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_c[4] = {
        LazyVim.lualine.pretty_path({
          length = 0,
          relative = "cwd",
          modified_hl = "MatchParen",
          directory_hl = "",
          filename_hl = "Bold",
          modified_sign = "",
          readonly_icon = " 󰌾 ",
        }),
      }
    end,
  },

  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      plugins = {
        gitsigns = true,
        tmux = true,
        kitty = { enabled = false, font = "+2" },
      },
    },
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = false,
  },

  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
 ██████╗ ███████╗██╗   ██╗ █████╗ ███████╗██╗     ██╗███████╗███████╗
 ██╔══██╗██╔════╝██║   ██║██╔══██╗██╔════╝██║     ██║██╔════╝██╔════╝
 ██║  ██║█████╗  ██║   ██║███████║███████╗██║     ██║█████╗  █████╗
 ██║  ██║██╔══╝  ╚██╗ ██╔╝██╔══██║╚════██║██║     ██║██╔══╝  ██╔══╝
 ██████╔╝███████╗ ╚████╔╝ ██║  ██║███████║███████╗██║██║     ███████╗
 ╚═════╝ ╚══════╝  ╚═══╝  ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝╚═╝     ╚══════╝
   ]],
        },
      },
    },
  },
}
