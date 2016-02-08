#
# Cookbook Name:: workstation
# Recipe:: _tmus_setup
#
# Copyright (c) 2015 Will Salt, All Rights Reserved.

execute 'install_tmux_plugin_manager' do
  command "git clone https://github.com/tmux-plugins/tpm /Users/#{ENV['SUDO_USER']}/.tmux/plugins/tpm"
  creates "/Users/#{ENV['SUDO_USER']}/.tmux/plugins/tpm"
  action :run
  user ENV['SUDO_USER']
  group 'staff'
end
