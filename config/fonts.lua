local wezterm = require('wezterm')
local font_size = 12

return {
   font = wezterm.font_with_fallback({
      'Maple Mono NF CN',
      '鸿蒙黑体',
   }),
   font_size = font_size,

      -- 控制字体特性（对应 VS Code 的 fontLigatures）
      harfbuzz_features = {
         -- 字符变体 (cv01-cv11、cv61-cv66) - Maple Mono 的美化字符渲染选项
         'cv01',   -- 移除间隙
         'cv02',   -- 替换 a
         'cv03',   -- 替换 i
         'cv05',   -- 替换 g
         'cv64',   -- 替换左右箭头

         -- 斜体变体 (cv31-cv44) - Maple Mono 的斜体美化选项
         'cv31',   -- 替换斜体 a
         'cv38',   -- 替换斜体 g

         -- 中文
         'cv96',   -- 全角引号
         'cv97',   -- 全角省略号
         'cv98',   -- 全角破折号
         'cv99',   -- 繁体标点

         -- 样式集 (ss01-ss11) - 预定义的美化风格组合
         'ss01',   -- 分离的等号连字
         'ss02',   -- 分离的比较符号连字
         'ss03',   -- 任意的纯文本标签
         'ss04',   -- 分离的多下划线连字
         'ss05',   -- 回退细的转义符号

         -- 基本连字
         'zero',   -- 点 0 (slashed zero)
      },

   --ref: https://wezfurlong.org/wezterm/config/lua/config/freetype_pcf_long_family_names.html#why-doesnt-wezterm-use-the-distro-freetype-or-match-its-configuration
   freetype_load_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
   freetype_render_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
}
