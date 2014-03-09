case node[:platform]
when :ubuntu,:debian
  default[:authorization][:sudo][:sudoers_defaults] = ['env_reset']
end

default[:authorization][:sudo][:groups] = ["wheel", "sysadmin"]
default[:authorization][:sudo][:agent_forwarding] = true

default[:aide][:report_url] = "mailto:root@localhost"

default['postfix']['main']['smtpd_tls_cert_file'] = "/etc/ssl/certs/#{node[:fqdn]}.pem"
default['postfix']['main']['smtpd_tls_key_file'] = "/etc/ssl/private/#{node[:fqdn]}.key"
default['postfix']['main']['smtpd_tls_CAfile'] = "/etc/ssl/certs/#{node[:hostname]}-bundle.crt"
