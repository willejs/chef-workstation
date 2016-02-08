#
# Cookbook Name:: workstation
# Recipe:: _settings
#
# Copyright (c) 2015 Will Salt, All Rights Reserved.

app_array = []
node['workstation']['settings']['dock']['keep'].each do |app|
	app_array << "<dict>
			        <key>tile-data</key>
			        <dict>
			            <key>file-data</key>
			            <dict>
			                <key>_CFURLString</key>
			                <string>#{app}</string>
			                <key>_CFURLStringType</key>
			                <integer>0</integer>
			            </dict>
			        </dict>
			    </dict>"
end

file "#{Chef::Config[:file_cache_path]}/persistent-apps" do
  action :create
  content app_array.join()
  notifies :write, 'mac_os_x_userdefaults[com.apple.dock_persistent-apps]'
end

execute "killall Dock" do
  ignore_failure true
  action :nothing
end

mac_os_x_userdefaults "com.apple.dock_persistent-apps" do
	domain "com.apple.dock"
	key 'persistent-apps'
	value app_array
	type 'array'
	user ENV['SUDO_USER']
	action :nothing
	notifies :run, 'execute[killall Dock]'
end

execute 'restart_menubar' do
  command 'killall -KILL SystemUIServer'
  action :nothing
end

mac_os_x_userdefaults 'turn on date & seconds for menubar clock' do
  domain 'com.apple.menuextra.clock'
  key 'DateFormat'
  value 'EEE MMM d  h:mm:ss a'
  type 'string'
  notifies :run, 'execute[restart_menubar]'
end

mac_os_x_userdefaults 'Set terminal color scheme to Homebrew' do
  domain 'com.apple.Terminal'
  key 'Default Window Settings'
  value 'Homebrew'
  type 'string'
end

mac_os_x_userdefaults 'Set startup terminal color scheme to Homebrew' do
  domain 'com.apple.Terminal'
  key 'Startup Window Settings'
  value 'Homebrew'
  type 'string'
end

mac_os_x_userdefaults 'Show hidden files in finder' do
  domain 'com.apple.finder'
  key 'AppleShowAllFile'
  value true
  type 'boolean'
end

# Set the hostname
["scutil --set ComputerName #{node['workstation']['hostname']}",
 "scutil --set LocalHostName #{node['workstation']['hostname']}",
 "scutil --set HostName #{node['workstation']['hostname']}",
 "hostname #{node['workstation']['hostname']}",
 "diskutil rename / #{node['workstation']['hostname']}" ].each do |host_cmd|
  execute host_cmd do
  	not_if { Mixlib::ShellOut.new('hostname -f').run_command.stdout == node['workstation']['hostname'] }
  end
end
