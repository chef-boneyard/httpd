# HTTPD Cookbook

[![Build Status](https://travis-ci.org/chef-cookbooks/httpd.svg?branch=master)](https://travis-ci.org/chef-cookbooks/httpd) [![Cookbook Version](https://img.shields.io/cookbook/v/httpd.svg)](https://supermarket.chef.io/cookbooks/httpd)

The HTTPD Cookbook is a Library Cookbook that provides resource primitives for use in recipes. It is designed to be an example to reference for creating highly re-usable cross platform cookbooks.

## Scope

This cookbook is concerned with [The Apache HTTP Server](http://httpd.apache.org/), particularly those shipped with F/OSS Unix and Linux distributions. It does not address other httpd server implementations like Lighttpd, Nginx, or IIS.

## Requirements

- Chef 12.7 or higher
- Network accessible package repositories

## Platform Support

The following platforms have been tested with Test Kitchen:

```
|----------------+-----+-----|
|                | 2.2 | 2.4 |
|----------------+-----+-----|
| amazon linux   |     | X   |
|----------------+-----+-----|
| debian-7       | X   |     |
|----------------+-----+-----|
| debian-8       |     | X   |
|----------------+-----+-----|
| debian-9       |     | X   |
|----------------+-----+-----|
| ubuntu-14.04   |     | X   |
|----------------+-----+-----|
| ubuntu-16.04   |     | X   |
|----------------+-----+-----|
| centos-6       | X   |     |
|----------------+-----+-----|
| centos-7       |     | X   |
|----------------+-----+-----|
| fedora         |     | X   |
|----------------+-----+-----|
```

## Cookbook Dependencies

- none

## Usage

Place a dependency on the httpd cookbook in your cookbook's metadata.rb

```ruby
depends 'httpd'
```

Then, in a recipe:

```ruby
httpd_service 'default' do
  action [:create, :start]
end

httpd_config 'default' do
  source 'mysite.cnf.erb'
  notifies :restart, 'httpd_service[default]'
  action :create
end
```

## Resources Overview

### httpd_service

The `httpd_service` does minimal configuration to get the service up and running. Its parameters can select and tune the multi-processing module, along with a small selection of server-wide configuration options such as listen_ports and run_user.

The `:create` action handles package installation, support directories, socket files, and other operating system level concerns. The internal configuration file contains just enough to get the service up and running, then loads extra configuration from a conf.d directory. Further configurations are managed with the `httpd_config` resource.

The `:start`, `:stop`, `:restart`, and `:reload` actions use the appropriate provider for the platform to respectively start, stop, restart, and reload the service on the machine. You should omit the `:start` action in recipes designed to build containers.

`httpd_service` supports multiple Apache instances on a single machine, enabling advanced Apache configuration in scenarios where multiple servers need different loaded modules and global configurations.

#### Examples

```ruby
httpd_service 'default' do
  action :create
end

httpd_service 'instance-1' do
  listen_ports ['81', '82']
  action :create
end

httpd_service 'an websites' do
  instance_name 'bob'
  servername 'www.computers.biz'
  version '2.4'
  mpm 'event'
  threadlimit '4096'
  listen_ports ['1234']
  action :create
end
```

#### Properties

Most of the parameters on the `httpd_service` resource map to their CamelCase equivalents found at <http://httpd.apache.org/docs/2.4/mod/directives.html>

- `contact` - The email address rendered into the main configuration file as the ServerAdmin directive.
- `hostname_lookups` - Enables DNS lookups on client IP addresses. Can be 'on' 'off' or 'double'. Defaults to 'off'.
- `instance` - A string name to identify the `httpd_service` instance. By convention, this will result in configuration, log, and support directories being created and used in the form '/etc/instance-name', '/var/log/instance-name', etc. If set to 'default', the platform native defaults are used.
- `keepalive` - Enables HTTP persistent connections. Values can be true or false.
- `keepalivetimeout` - Amount of time the server will wait for subsequent requests on a persistent connection.
- `listen_addresses` - IP addresses that the server listens to. Defaults to ['0.0.0.0'].
- `listen_ports` - Ports that the server listens to. Defaults to ['80'].
- `log_level` - Controls the verbosity of the ErrorLog. Defaults to 'warn'.
- `maxclients` - Maximum number of connections that will be processed simultaneously. Valid only with prefork and worker MPMs.
- `maxconnectionsperchild` - Limit on the number of connections that an individual child server will handle during its life. Valid with Apache 2.4 prefork, worker and event MPMs.
- `maxkeepaliverequests` - Number of requests allowed on a persistent connection. Defaults to 100.
- `maxrequestsperchild` - The Apache 2.2 version of maxconnectionsperchild. Still supported as of 2.4
- `maxrequestworkers` - Maximum number of connections that will be processed simultaneously. Valid on prefork, worker, and event MPMs.
- `maxspareservers` - Maximum number of idle child server processes. Valid only for prefork MPM.
- `maxsparethreads` - Maximum number of idle threads. Valid only for worker and event MPMs.
- `minspareservers` - Minimum number of idle child server processes. Valid only for preform MPM.
- `minsparethreads` - Minimum number of idle threads available to handle request spikes. Valid only for worker and event MPMs.
- `modules` - A list of initial Apache modules to be loaded inside the httpd_service instance. Defaults to Debian standard on 2.2 and 2.4.
- `mpm` - The Multi-Processing Module to use for the `httpd_service` instance. Values can be 'prefork', 'worker', and 'event'. Defaults to 'worker' for Apache 2.2 and 'event' for Apache 2.4.
- `package_name` - Name of the server package to install on the machine using the system package manager. Defaults to 'apache2' on Debian and 'httpd' on RHEL.
- `run_group` - System group to start the `httpd_service` as. Defaults to 'www-data' on Debian and 'apache' on RHEL.
- `run_user` - System user to start the `httpd_service` as. Defaults to 'www-data' on Debian and 'apache' on RHEL.
- `servername` - Hostname and port that the server uses to identify itself. Syntax: [scheme://]fully-qualified-domain-name[:port]. Defaults to node['hostname'].
- `startservers` - Number of child server processes created at startup. Valid for prefork, worker, and event MPMs. Default value differs from MPM to MPM.
- `threadlimit` - Sets the upper limit on the configurable number of threads per child process. Valid on worker and event MPMs.
- `threadsperchild` - Number of threads created by each child process. Valid on worker and event MPMs.
- `timeout` - Amount of time the server will wait for certain events before failing a request. Defaults to '400'
- `version` - Apache software version to use. Available options are '2.2', and '2.4', depending on platform. Defaults to latest available.

### httpd_module

The `httpd_module` resource is responsible ensuring that an Apache module is installed on the system, as well as ensuring a load configuration snippet is dropped off at the appropriate location.

#### Examples

```ruby
httpd_module 'ssl' do
  action :create
end

httpd_module 'el dap' do
  module_name 'ldap'
  action :create
end

httpd_module 'auth_pgsql' do
  instance 'instance-2'
  action :create
end
```

#### Properties

- `filename` - The filename of the shared object to be rendered into the load config snippet. This can usually be omitted, and defaults to a generated value looked up in an internal map.
- `httpd_version` - The version of the `httpd_service` this module is meant to be installed for. Useful on platforms that support multiple Apache versions. Defaults to the platform default.
- `instance` - The `httpd_service` name to drop the load snippet off for. Defaults to 'default'.
- `module_name` - The module name to install. Defaults to the `httpd_module` name.
- `package_name` - The package name the module is found in. By default, this is looked up in an internal map.

### httpd_config

The `httpd_config` resource is responsible for creating and deleting site specific configuration files on the system. There are slight differences in the resource implementation on platforms. The `httpd_config` resource is a thin wrapper around the core Chef template resource. Instead of a path parameter, `httpd_config` uses the instance parameter to calculate where the config is dropped off.

Check the [Apache HTTP Server Project documentation](http://httpd.apache.org/docs/) for configuration specifics based on Apache version.

#### Examples

```ruby
httpd_config 'mysite' do
  source 'mysite.erb'
  action :create
end

httpd_config 'computers dot biz ssl_config' do
  config_name 'ssl-config'
  instance 'computers_dot_biz'
  source 'ssl_config.erb'
  action :create
end
```

#### Properties

- `config_name` - The name of the config on disk
- `cookbook` - The cookbook that the source template is found in. Defaults to the current cookbook.
- `httpd_version` - Used to calculate the configuration's disk path. Defaults to the platform's native Apache version.
- `instance` - The `httpd_service` instance the config is meant for. Defaults to 'default'
- `source` - The ERB format template source used to render the file.
- `variables` - A hash of variables passed to the underlying template resource

## Maintainers

This cookbook is maintained by Chef's Community Cookbook Engineering team. Our goal is to improve cookbook quality and to aid the community in contributing to cookbooks. To learn more about our team, process, and design goals see our [team documentation](https://github.com/chef-cookbooks/community_cookbook_documentation/blob/master/COOKBOOK_TEAM.MD). To learn more about contributing to cookbooks like this see our [contributing documentation](https://github.com/chef-cookbooks/community_cookbook_documentation/blob/master/CONTRIBUTING.MD), or if you have general questions about this cookbook come chat with us in #cookbok-engineering on the [Chef Community Slack](http://community-slack.chef.io/)

## License

**Copyright:** 2008-2017, Chef Software, Inc.

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
