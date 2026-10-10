local M = {}

function M.hex_to_hsl(hex)
  local value = hex:gsub("^#", "")
  if #value == 3 then
    value = value:gsub(".", "%0%0")
  end
  assert(#value == 6 and value:match("^%x+$"), "Expected a 3- or 6-digit hex color")
  local r, g, b =
    tonumber(value:sub(1, 2), 16) / 255, tonumber(value:sub(3, 4), 16) / 255, tonumber(value:sub(5, 6), 16) / 255
  local high, low = math.max(r, g, b), math.min(r, g, b)
  local delta, lightness = high - low, (high + low) / 2
  local hue, saturation = 0, 0
  if delta > 0 then
    saturation = delta / (1 - math.abs(2 * lightness - 1))
    if high == r then
      hue = ((g - b) / delta) % 6
    elseif high == g then
      hue = (b - r) / delta + 2
    else
      hue = (r - g) / delta + 4
    end
    hue = hue * 60
  end
  local function round(n)
    return math.floor(n + 0.5)
  end
  return string.format("hsl(%d, %d%%, %d%%)", round(hue) % 360, round(saturation * 100), round(lightness * 100))
end

function M.replace_hex_with_hsl()
  local line = vim.api.nvim_get_current_line()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local offset = 1
  while true do
    local first, last = line:find("#%x+", offset)
    if not first then
      break
    end
    local hex = line:sub(first, last)
    if cursor[2] + 1 >= first and cursor[2] + 1 <= last and (#hex == 4 or #hex == 7) then
      vim.api.nvim_buf_set_text(0, cursor[1] - 1, first - 1, cursor[1] - 1, last, { M.hex_to_hsl(hex) })
      return
    end
    offset = last + 1
  end
  vim.notify("Place the cursor on a 3- or 6-digit hex color", vim.log.levels.INFO)
end

return M
