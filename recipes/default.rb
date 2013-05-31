#
# Cookbook Name:: hlds
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "ia32-libs" do
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
 
 

script "download_steamCMD" do
  interpreter "bash"
  cwd "/home/hlds"
  code <<-EOH
  wget http://media.steampowered.com/client/steamcmd_linux.tar.gz
  EOH
end

script "decompress_steamCMD" do
  interpreter "bash"
  cwd "/home/hlds"
  code <<-EOH
  tar -xvzf steamcmd_linux.tar.gz
  EOH
end

script "download_files_server" do
  interpreter "bash"
  cwd "/home/hlds"
  code <<-EOH
  ./steamcmd.sh +login anonymous +force_install_dir ./tf_server +app_update 232250 validate +quit
  EOH
end


#script "configure_server" do
#  interpreter "bash"
#  cwd "/home/hlds/"
#  code <<-EOH
#  cfg=etf2l_configs_full_2013_01_17.zip
 
#  wget files.ntraum.de/priv/etf2l_configs_full_2013_01_17.zip
#  unzip $cfg
#  rm $cfg 
#  EOH
#end

#script "run_server" do
#  interpreter "bash"
#  cwd "/home/hlds/"
#  code <<-EOH
#  echo "./srcds_run -game tf -autoupdate -steambin /home/hlds/steam -maxplayers 24 -map pl_badwater" > run.sh
#  EOH
#end
