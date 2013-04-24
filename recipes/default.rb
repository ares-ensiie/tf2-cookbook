#
# Cookbook Name:: hlds
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "libc6:i386" do
  action :install
end


user "hlds" do
  comment "Hlds user"
  uid 440   
  gid "users"
  home "/home/hlds"
  shell "/bin/bash"
end

directory "/home/hlds" do
  owner "hlds"
  group "users"
  mode 0755
  action :create
end 

mount "/mnt" do
  device "/dev/vdb"
  fstype "ext3"
  action :umount
end

mount "/home/hlds" do
  device "/dev/vdb"
  fstype "ext3"
  action :mount
end
 
 

script "install_server" do
  interpreter "bash"
  cwd "/home/hlds"
  code <<-EOH
   wget http://storefront.steampowered.com/download/hldsupdatetool.bin
   chmod +x hldsupdatetool.bin
   echo yes | ./hldsupdatetool.bin
  EOH
end

script "prepare_download_files_server" do
  interpreter "bash"
  cwd "/home/hlds"
  code <<-EOH
  chmod +x ./steam
  ./steam > steam.log
  ./steam 
  mkdir gameserver
  EOH
end

script "download_files_server" do
  interpreter "bash"
  cwd "/home/hlds"
  code <<-EOH
  ./steam -command update -game tf -dir gameserver
  EOH
end

script "configure_server" do
  interpreter "bash"
  cwd "/home/hlds/gameserver/orangebox"
  code <<-EOH
  touch steam_appid.txt 
  echo "440" > steam_appid.txt
  chmod +x srcds_run
  chmod +x srcds_linux
  EOH
end

script "configure_server" do
  interpreter "bash"
  cwd "/home/hlds/gameserver/orangebox/tf/cfg"
  code <<-EOH
  cfg=etf2l_configs_full_2013_01_17.zip
 
  wget files.ntraum.de/priv/etf2l_configs_full_2013_01_17.zip
  unzip $cfg
  rm $cfg 
  EOH
end

#script "run_server" do
#  interpreter "bash"
#  cwd "/home/hlds/gameserver/orangebox"
#  code <<-EOH
#  ./srcds_run -game tf -autoupdate -steambin /home/hlds/steam -maxplayers 24 -map pl_badwater
#  EOH
#end

