# -*- coding: utf-8 -*-
#
# Cookbook Name:: marbase
# Recipe:: default
#
case node['platform']
when "ubuntu","debian"
  include_recipe "apt"
  include_recipe "build-essential"
  package "texinfo"
when "arch"
  bash "install base-devel" do
  user "root"
  not_if "gcc --version && bison --version"
  code <<-EOH
    pacman -Syu --noconfirm
    pacman -S --noconfirm ruby ntp base-devel
    ntpdate -u pool.ntp.org
    gem install ohai --no-rdoc --no-ri
    gem install chef --no-rdoc --no-ri
  EOH
  end
end

include_recipe "users"

include_recipe "git"
#include_recipe "subversion"
include_recipe "mercurial"
package "cvs"
include_recipe "emacs"

users_manage "sysadmin" do
  group_id 2300
  action [ :create ]
end

include_recipe "oh-my-zsh"

search(:users, "id:martin").each do |user|
  git "/home/#{user['id']}/.emacs.d" do
    repository "git@github.com:myrjola/oh-my-emacs.git"
    action :sync
    user user['id']
  end
end
