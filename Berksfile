source 'https://supermarket.chef.io'

metadata

group :integration do
  cookbook 'apt'
  cookbook 'selinux'
  cookbook 'sparrow', '~> 0.0.5'
end

cookbook 'httpd_config_test', path: 'test/cookbooks/httpd_config_test'
cookbook 'httpd_module_test', path: 'test/cookbooks/httpd_module_test'
cookbook 'httpd_service_test', path: 'test/cookbooks/httpd_service_test'
cookbook 'hello_world_test', path: 'test/cookbooks/hello_world_test'
cookbook 'broken', path: 'test/cookbooks/broken'
