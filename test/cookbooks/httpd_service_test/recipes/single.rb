apt_update 'update' if platform_family?('debian')

httpd_service node['httpd']['service_name'] do
  action [:create, :start]
end
