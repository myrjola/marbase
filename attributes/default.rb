default["openssh"]["client"]["github.com"] = {
  "user_known_hosts_file" => "/dev/null",
  "strict_host_key_checking" => "no"
}

case node['platform']
when "ubuntu","debian"
  default['emacs']['packages'] = ["emacs24-nox"]
end

default[:authorization][:sudo] = {
  :groups => ["wheel", "sysadmin"],
}
