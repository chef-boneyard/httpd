#
# Hello world recipe
#
# Attempting to get to the default behavior of Debian 7

s = httpd_service 'default' do
  action :create
end

if s.parsed_version == '2.2'
  %w(
    alias autoindex dir
    env mime negotiation
    setenvif status auth_basic
    deflate authz_default authz_user
    authz_groupfile authn_file
    authz_host reqtimeout
  ).each do |m|
    httpd_module m do
      action :create
      notifies :restart, 'httpd_service[default]'
    end
  end
else
  %w(
    authz_core authz_host authn_core
    auth_basic access_compat authn_file
    authz_user alias dir autoindex
    env mime negotiation setenvif
    filter deflate status
  ).each do |m|
    httpd_module m do
      action :create
      notifies :restart, 'httpd_service[default]'
    end
  end
end

httpd_config '000-default' do
  source '000-default.erb'
  notifies :restart, 'httpd_service[default]'
end

file '/var/www/index.html' do
  content 'hello there\n'
  action :create
end
