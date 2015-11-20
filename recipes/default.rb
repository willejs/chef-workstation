#
# Cookbook Name:: workstation
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'build-essential'

directory '/Library/Caches' do
  mode 01777
end

include_recipe 'workstation::_settings'
include_recipe 'homebrew'
include_recipe 'homebrew::cask'
include_recipe 'homebrew::install_taps'
include_recipe 'homebrew::install_formulas'

node['workstation']['homebrew']['brews'].each do |brew|
  # Homebrew is the default provider for mac
  package brew
end

node['workstation']['homebrew']['casks'].each do |cask|
  homebrew_cask cask
end

remote_file "#{Chef::Config[:file_cache_path]}/menumeters.zip" do
  action :create_if_missing
  mode '0644'
  source 'http://member.ipmu.jp/yuji.tachikawa/MenuMetersElCapitan/zips/MenuMeters_1.9.1.zip'
  notifies :run, 'execute[unzip_menumeters]'
end

execute 'unzip_menumeters' do
  command "unzip menumeters.zip -d /Users/#{ENV['SUDO_USER']}/Library/PreferencePanes/"
  cwd Chef::Config[:file_cache_path]
  action :nothing
end
