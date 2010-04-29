#
# Cookbook Name:: resque
# Recipe:: default
#

# Set your application name here
appname = "seatsmart"
flavor = "resque"
workers_count = 2
queue_name = '*'

if ['solo', 'app', 'app_master'].include?(node[:instance_role])

  # be sure to replace "app_name" with the name of your application.
  run_for_app(appname) do |app_name, data|

    ey_cloud_report "Resque" do
      message "configuring #{flavor}"
    end

    template "/etc/monit.d/resque.#{app_name}.monitrc" do
      source "resque.monitrc.erb"
      owner node[:owner_name]
      group node[:owner_name]
      mode 0644
      variables({
        :app_name => app_name,
	:queue_name => queue_name,
	:workers_count => workers_count,
        :user => node[:owner_name],
        :flavor => flavor
      })
    end

    execute "restart-monit-resque" do
      command "/usr/bin/monit reload && " +
              "/usr/bin/monit restart all -g resque_#{app_name}"
      action :run
    end

  end

end

