if defined?(ChefSpec)
  def create_httpd_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:httpd_service, :create, resource_name)
  end
end
