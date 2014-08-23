#
# Hello world recipe
#
# Attempting to get to the default behavior of Debian 7
# Work in progress.

httpd_config '000-default' do
  source '000-default.erb'
  notifies :restart, 'httpd_service[default]'
end

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

httpd_service 'default' do
  action :create
end
