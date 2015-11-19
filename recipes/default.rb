#
# Cookbook Name:: workstation
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'build-essential'

directory '/Library/Caches' do
  mode 01777
end

include_recipe 'homebrew'
include_recipe 'homebrew::cask'
include_recipe 'homebrew::install_taps'
include_recipe 'homebrew::install_formulas'

node['workstation']['homebrew']['casks'].each do |cask|
  homebrew_cask cask
end
