default[:hlds][:dir]       = "/home"
default[:hlds][:data_dir]  = "/home"
default[:hlds][:log_dir]   = "/home"
# one of: debug, verbose, notice, warning
default[:hlds][:loglevel]  = "notice"
default[:hlds][:user]      = "hlds"
default[:hlds][:port]      = 27015

case plateform
when "windows"
  default[:hlds][:steamcmd_url] = "media.steampowered.com/client/steamcmd_win32.zip"
else
default[:hlds][:steamcmd_url] = "http://media.steampowered.com/client/steamcmd_linux.tar.gz"
end

