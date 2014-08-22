HTTPD Cookbook
=======================

The HTTPD Cookbook is a "Pure Library Cookbook" (Module Cookbook?)
that provides resource primitives for use in recipes. It is designed
to be an example to reference for creating highly re-usable cross
platform cookbooks. 

This cookbook does its best to follow platform native idioms at all
times. This means things like logs, pid files, sockets, and service
managers work "as expected" by an administrator familiar with a given
platform.

Scope
-----
This cookbook is concerned with
[The Apache HTTP Server](http://httpd.apache.org/), particularly those
shipped with F/OSS Unix and Linux distributions. It does not address
other httpd server implementations like Lighttpd, Nginx, or IIS.


Requirements
------------
* Chef 11 or higher
* Ruby 1.9 or higher (preferably from the Chef full-stack installer)

Resources
---------------------
### httpd_service

The `httpd_service` does minimal configuration to get the service up
and running. Its parameters can select and tune the multi-processing
module, along with a small selection of server-wide configuration
options such as listen_ports and run_user.

All other configuration options are offloaded to the user, and should
be dropped off with the `httpd_config` resource.

`httpd_service` supports multiple Apache instances on a single
machine, enabling advanced Apache configuration in scenarios where
multiple servers need different loaded modules and global
configurations.

## Examples

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

## Parameters
Most of the parameters on the `httpd_service` resource map to their
CamelCase equivalents found at
http://httpd.apache.org/docs/2.4/mod/directives.html

`contact` - The email address rendered into the main configuration file as the ServerAdmin directive.

`hostname_lookups` - The HostnameLookups Directive. Can be 'on' 'off'
or 'double'. Defaults to 'off'.

`instance` - A string name to identify the `httpd_service` instance.
By convention, this will result in configuration, log, and support
directories being created and used in the form '/etc/instance-name',
'/var/log/instance-name', etc. If set to 'default', the platform
native defaults are used.

`keepalive` - Enables HTTP persistent connections. Values can be true or false.

`keepalivetimeout` -  Amount of time the server will wait for
subsequent requests on a persistent connection. 

`listen_addresses` - IP addresses that the server listens
to. Defaults to ['0.0.0.0'].

`listen_ports` - Ports that the server listens
to. Defaults to ['80', '443'].

`log_level` - Controls the verbosity of the ErrorLog. Defaults to 'warn'.

`maxclients` - Maximum number of connections that will be processed
simultaneously. Valid only with prefork and worker MPMs.

`maxconnectionsperchild` - Limit on the number of connections that an individual child server
will handle during its life. Valid with Apache 2.4 prefork, worker and event MPMs.

`maxkeepaliverequests` - Number of requests allowed on a persistent
connection. Defaults to 100.

`maxrequestsperchild` -  The Apache 2.2 version of maxconnectionsperchild. Still supported as of 2.4
 
`maxrequestworkers` - Maximum number of connections that will be
processed simultaneously. Valid on prefork, worker, and event MPMs.
 
`maxspareservers` - Maximum number of idle child server processes.
Valid only for prefork MPM.

`maxsparethreads` - Maximum number of idle threads. Valid only for
worker and event MPMs.

`minspareservers` - Minimum number of idle child server processes.
Valid only for preform MPM.

`minsparethreads` - Minimum number of idle threads available to handle
request spikes. Valid only for worker and event MPMs.

`mpm` - The Multi-Processing Module to use for the `httpd_service`
instance. Values can be 'prefork', 'worker', and 'event'. Defaults to
'worker' for Apache 2.2 and 'event' for Apache 2.4.

`package_name` - Name of the server package to install on the machine
using the system package manager. Defaults to 'apache2' on Debian and
'httpd' on RHEL.

`run_group` - System group to start the `httpd_service` as. Defaults to
'www-data' on Debian and 'apache' on RHEL.

`run_user` - System user to start the `httpd_service` as. Defaults to
'www-data' on Debian and 'apache' on RHEL.

`servername` - Hostname and port that the server uses to identify
itself. Syntax: [scheme://]fully-qualified-domain-name[:port].
Defaults to node['hostname'].

`startservers` - Number of child server processes created at startup.
Valid for prefork, worker, and event MPMs. Default value differs from MPM to MPM.

`threadlimit` - Sets the upper limit on the configurable number of
threads per child process. Valid on worker and event MPMs.

`threadsperchild` - Number of threads created by each child process.
Valid on worker and event MPMs.

`timeout` - Amount of time the server will wait for certain events
before failing a request. Defaults to '400'

`version` - Apache software version to use. Available options are
'2.2', and '2.4', depending on platform. Defaults to latest available.
    
### httpd_module
## Examples
## Parameters
`filename`
`httpd_version`
`instance`
`module_name`
`package_name`

### httpd_config
## Examples
## Parameters
`config_name`
`cookbook`
`httpd_version`
`instance`
`source`
`variables`

License & Authors
-----------------
- Author:: Sean OMeara (<someara@opscode.com>)

```text
Copyright:: 2009-2014 Chef Software, Inc

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
