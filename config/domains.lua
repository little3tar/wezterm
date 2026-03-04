return {

   -- default_gui_startup_args = { 'connect', 'linux' },

    -- ref: https://wezfurlong.org/wezterm/config/lua/SshDomain.html
    ssh_domains = {
       {
          name = 'OECT',
          remote_address = '192.168.5.5',
          username = 'root',
       },
    },

    -- serial_ports = {},

   -- ref: https://wezfurlong.org/wezterm/multiplexing.html#unix-domains
   unix_domains = {},

   -- ref: https://wezfurlong.org/wezterm/config/lua/WslDomain.html
    wsl_domains = {
       {
          name = 'WSL:Ubuntu',
          distribution = 'Ubuntu',
          username = 'linux',
          default_cwd = '/home/linux',
          default_prog = { 'bash', '-l' },
       },
    },
}
