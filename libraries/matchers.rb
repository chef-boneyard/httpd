if defined?(ChefSpec)
  def create_httpd_config(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:httpd_config, :create, resource_name)
  end

  def delete_httpd_config(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:httpd_config, :delete, resource_name)
  end

  def create_httpd_module(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:httpd_module, :create, resource_name)
  end

  def delete_httpd_module(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:httpd_module, :delete, resource_name)
  end

  def create_httpd_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:httpd_service, :create, resource_name)
  end

  def delete_httpd_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:httpd_service, :delete, resource_name)
  end
end
