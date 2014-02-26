# -*- coding: utf-8 -*-
#
# Cookbook Name:: marbase
# Recipe:: default
#
case node['platform']
when "ubuntu","debian"
  include_recipe "apt"
  include_recipe "build-essential"
when "arch"
  bash "install base-devel" do
  user "root"
  code <<-EOH
    pacman -Sy --noconfirm base-devel
  EOH
  end
end

include_recipe "users"
include_recipe "openssh"
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
