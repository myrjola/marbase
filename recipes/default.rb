
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
  include_recipe "python"
  package "emacs24-nox"
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
  package "emacs-nox"
end


include_recipe "users::sysadmins"

search("users", "id:martin").each do |user|
  keypairs = Chef::EncryptedDataBagItem.load('ssh_keypairs', user.id).to_hash
  puts keypairs
  file "/home/#{user.id}/.ssh/id_rsa" do
    content keypairs['private_key']
    owner user.id
    group user.id
    mode 0600
  end
  file "/home/#{user.id}/.ssh/id_rsa.pub" do
    content keypairs['public_key']
    owner user.id
    group user.id
    mode 0600
  end
end

include_recipe "sudo"
include_recipe "openssh"
include_recipe "git"
include_recipe "mercurial"
package "cvs"

include_recipe "oh-my-zsh"

git "/home/martin/.emacs.d" do
  repository "git@github.com:myrjola/oh-my-emacs.git"
  action :sync
  revision 'master'
  enable_submodules true
  user 'martin'
  notifies :run, "bash[configure emacs]"
end

bash "configure emacs" do
  action :nothing
  not_if
  user 'martin'
  code <<-EOH
    until [[ `emacs --batch -l /home/martin/.emacs.d/init.el --eval 't'` -eq 0 ]]
    do
      echo "Emacs startup failed"
    done
  EOH
end
