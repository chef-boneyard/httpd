if defined?(ChefSpec)
  def create_crossplat_thing(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:crossplat_thing, :create, resource_name)
  end
end
