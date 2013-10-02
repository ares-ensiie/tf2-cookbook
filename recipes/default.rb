#
# Cookbook Name:: hlds
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#These libraries are required to run the server on linux 64 bits
package "ia32-libs" do
  action :install
end

#Create a user dedicated to lauch the server and host the server files
user "hlds" do
  comment "Hlds user"
  uid 440
  gid "users"
  home "/home/hlds"
  shell "/bin/bash"
end

#This user has a personal directory where the server fils live
directory "/home/hlds" do
  owner "hlds"
  group "users"
  mode 0777
  action :create
end 

#At this point we need to mount an external storage partition on the vm
#This step is required as the files take more space than the default vm possesses
#First we unmount it in case it was mounted before
mount "/mnt" do
  device "/dev/vdb"
  fstype "ext3"
  action :umount
end

#Then we mount it
mount "/home/hlds" do
  device "/dev/vdb"
  fstype "ext3"
  action :mount
end


#At this point we start the real installation of the server
#First step is to download the installer called steamCMD
script "download_installer" do
  interpreter "bash"
  cwd "/home/hlds"
  code <<-EOH
  wget http://media.steampowered.com/client/steamcmd_linux.tar.gz
  EOH
end

#We extract the archive
script "decompress_steamCMD" do
  interpreter "bash"
  cwd "/home/hlds"
  code <<-EOH
  tar -xvzf steamcmd_linux.tar.gz
  EOH
end

#We create the directory where the server files will live
#To avoid permissions problems we precise this directory is own by the user we previously created
directory "/home/hlds/tf2_server" do
  owner "hlds"
  group "users"
  mode 0777
  action :create
end

#We again make sure our whole user directory is ours
directory "/home/hlds" do
  owner "hlds"
  group "users"
  mode 0777
  recursive true
end

#With the help of the installer we download the server files
#This step is the longest, it may take up to 30 minutes depending on the internet connection
script "download_files_server" do
  interpreter "bash"
  cwd "/home/hlds"
  user "ubuntu"
  code <<-EOH
  ./steamcmd.sh +login anonymous +force_install_dir ./tf2_server +app_update 232250 validate +quit
  EOH
end

#Again permissions problems, might be unnecessary
directory "/home/hlds" do
  owner "hlds"
  group "users"
  mode 0777
  recursive true
end

#We finally run the server with different options:
# - server is launched in console mode
# - map is pl_badwater
# - max players is 24
#It is temporarily started by the ubuntu user (default chef user), not the hlds user as we would like to
script "run_server" do
  interpreter "bash"
  cwd "/home/hlds"
  user "ubuntu"
  code <<-EOH
 ./tf2_server/srcds_run -steam_dir steamcmd/ -steamcmd_script steamcmd.sh -console -game tf +map pl_badwater -maxplayers 24 
  EOH
end

#Configure the server
#This step is not mandatory and thus stays commented

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

