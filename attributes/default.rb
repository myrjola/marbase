case node[:platform]
when :ubuntu,:debian
  default[:authorization][:sudo][:sudoers_defaults] = ['env_reset']
end

default[:authorization][:sudo][:groups] = ["wheel", "sysadmin"]
default[:authorization][:sudo][:agent_forwarding] = true

default[:aide][:report_url] = "mailto:root@localhost"
