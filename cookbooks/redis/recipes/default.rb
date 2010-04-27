#
# Cookbook Name:: redis
# Recipe:: default
#
package "dev-db/redis" do
  action :install
end

gem_package "ezmobius-redis-rb" do
  source "http://gems.github.com"
  action :install
end

template "/etc/redis.conf" do
  owner 'root'
  group 'root'
  mode 0644
  source "redis.conf.erb"
  variables({
    :basedir => '/data/redis',
    :logfile => '/data/redis/redis.log',
    :bind_address => '127.0.0.1',
    :port => '6379',
    :loglevel => 'notice',
    :timeout => 3000,
    :sharedobjects => 'no'
  })
end

directory "/data/redis" do
  owner node[:owner_name]
  group node[:owner_name]
  mode 0755
  recursive true
end

execute "ensure-redis-is-running" do
  command %Q{
    /usr/bin/redis-server /etc/redis.conf
  }
  not_if "pgrep redis-server"
end
