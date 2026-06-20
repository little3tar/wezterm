return {

   -- default_gui_startup_args = { 'connect', 'WSL:Ubuntu-24.04' },  -- 或 'WSL:Ubuntu-20.04'

    -- ref: https://wezfurlong.org/wezterm/config/lua/SshDomain.html
    ssh_domains = {
       {
          name = 'OECT',
          remote_address = '192.168.5.5',
          username = 'root',
          multiplexing = 'None', -- 禁用 multiplexer，服务器无需安装 wezterm
       },
    },

    -- serial_ports = {},

   -- ref: https://wezfurlong.org/wezterm/multiplexing.html#unix-domains
   unix_domains = {},

   -- ref: https://wezfurlong.org/wezterm/config/lua/WslDomain.html
     wsl_domains = {
        {
           name = 'WSL:Ubuntu-20.04',
           distribution = 'Ubuntu-20.04',
           username = 'admin',
           default_cwd = '/home/admin',
           default_prog = { 'bash', '-l' },
        },
        {
           name = 'WSL:Ubuntu-24.04',
           distribution = 'Ubuntu-24.04',
           username = 'admin',
           default_cwd = '/home/admin',
           default_prog = { 'bash', '-l' },
        },
     },
}