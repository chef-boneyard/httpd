# comments!

httpd_service node['httpd']['service_name'] do
  action [:create, :start]
end
