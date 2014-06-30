# modules that ship with main apache httpd package
# Usually "core" or "base" status
# http://httpd.apache.org/docs/current/mod/module-dict.html#Status

# mod_alias
httpd_module 'mod_alias' do
  action :install
end

# mod_ssl
httpd_module 'mod_ssl' do
  action :install
end

# modules that need a package
httpd_module 'mod_perl' do
  action :install
end

# modules that have non-standard filenames on disk
httpd_module 'mod_php' do
  httpd_service 'instance-1'
  httpd_version '2.4'
  action :install
end

