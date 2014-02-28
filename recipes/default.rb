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
  include_recipe "subversion"
when "arch"
  include_recipe "pacman"
  bash "update packages" do
    user "root"
    code <<-EOH
    pacman -Syu --noconfirm
  EOH
  end
  pacman_group "base-devel" do
    action :install
  end
  package "fakeroot"
  package "subversion"
  chef_gem "digest"
  include_recipe "git"
  pacman_aur "omnibus-chef" do
    action [:build, :install]
  end
end

include_recipe "users"
include_recipe "openssh"
include_recipe "git"
include_recipe "mercurial"
package "cvs"
include_recipe "emacs"

users_manage "sysadmin" do
  group_id 2300
  action [ :create, :modify ]
end

include_recipe "oh-my-zsh"

search(:users, "id:martin").each do |user|
  git "/home/#{user['id']}/.emacs.d" do
    repository "git@github.com:myrjola/oh-my-emacs.git"
    action :sync
    user user['id']
  end
end
