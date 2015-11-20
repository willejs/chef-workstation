#
# Cookbook Name:: workstation
# Recipe:: _settings
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

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
	action :write
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

hostname = 'mbp'

["scutil --set ComputerName #{hostname}",
 "scutil --set LocalHostName #{hostname}",
 "scutil --set HostName #{hostname}",
 "hostname #{hostname}",
 "diskutil rename / #{hostname}" ].each do |host_cmd|
  execute host_cmd
end
