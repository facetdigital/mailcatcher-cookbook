#
# Cookbook Name:: mailcatcher
# Recipe:: default
# Author:: Scott W. Bradley (scottwb@gmail.com)
#
# Copyright 2014, Facet Digital, LLC
#

package "sqlite-devel" do
  action :install
end

cookbook_file "/etc/rc.d/init.d/mailcatcher" do
  owner "root"
  group "root"
  mode 0755
  action :create
end

script "install rvm, ruby 2.0.0, and mailcatcher" do
  interpreter "bash"
  flags "-l"
  user "root"
  group "root"
  environment("HOME" => "/root")
  timeout 3600

  code <<-EOT
    echo "Installing RVM."
    curl -L get.rvm.io | bash -s stable
    source /etc/profile.d/rvm.sh
    rvm requirements
    usermod -a -G rvm #{node['apache']['user']}

    echo "Installing Ruby 2.0.0."
    rvm install 2.0.0
    rvm use 2.0.0 --default

    echo "Installing Mailcatcher"
    rvm default@mailcatcher --create do gem install mailcatcher --no-ri --no-rdoc
    rvm wrapper default@mailcatcher --no-prefix mailcatcher catchmail
    chkconfig --add mailcatcher
    chkconfig --level 345 mailcatcher on
    /sbin/service mailcatcher start
  EOT

  not_if "chkconfig | grep mailcatcher"
end

iptables_rule "mailcatcher"
