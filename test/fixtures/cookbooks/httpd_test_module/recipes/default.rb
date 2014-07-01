# modules that ship with main apache httpd package
# Usually "core" or "base" status
# http://httpd.apache.org/docs/current/mod/module-dict.html#Status

# mod_alias
httpd_module 'alias' do
  action :create
end

# mod_ssl
httpd_module 'ssl' do
  action :create
end

# modules that need a package
httpd_module 'perl' do
  action :create
end

# modules that have non-standard filenames on disk
httpd_module 'php' do
  httpd_instance 'instance-1'
  httpd_version '2.4'
  action :create
end
