# httpd Cookbook CHANGELOG

This file is used to list changes made in each version of the httpd cookbook.

## 0.6.2 (2018-02-16)

- Allow sensitive flag for httpd_config.

## 0.6.1 (2017-10-20)

- Fix a failure in the systemd template

## 0.6.0 (2017-10-20)

- Remove Debian 6 helpers and simplify Ubuntu helper to support non-LTS ubuntu releases like 17.04
- Remove the platform priority map logic which isn't needed in modern Chef releases
- Add a missing service name variable in the systemd service resource, which will help us eventually support SUSE systemd setup
- Remove opensuse from the readme for now since we're not actually testing it and there's still issues
- Add support / testing for Debian 9
- Improve debian check logic in the systemd unit file to support derivatives of Debian/Ubuntu

## 0.5.1 (2017-10-19)

- Don't delete directory mods-available with delete action.

## 0.5.0 (2017-08-23)

### Breaking changes

- Remove support for OmniOS / SmartOS, which didn't actually work before
- Remove support for EOL CentOS 5 / Ubuntu 12.04
- Remove compat_resource and instead require Chef 12.7+
- Service creation has been moved from the :start action to the :create action to follow user exceptions. Existing cookbooks using the service resource will need to be updated to use the create action in addition to the start action.

### Other Changes

- The service resource have been DRYed up
- Use a SPDX compliant license string to resolve FoodCritic warnings
- Switch from Rakefile testing to Delivery local mode
- Add support for Amazon Linux 2017 and simplify Amazon detection so we don't have to repeat this next year
- Remove Chef 12.0 compatibility code to simplify init system detection
- Resolve all CHEF-19 deprecation warnings

## 0.4.5 (2017-02-13)

- Resolve Issue #104 with use of security module on RHEL 7.2

## 0.4.4 (2016-09-27)

- Explicitly using new_resource.version in guard clause Centos/RHEL
- Add net-tools to docker configuration

## 0.4.3 (2016-09-27)

- Explicitly using new_resource.version in guard clause Ubuntu

## 0.4.2 (2016-09-27)

- Release reflecting new dep on compat_resource 12.14.6

## 0.4.1 (2016-09-23)

- Fix incompatibilities with the new releases of compat_resource
- Require a more recent compat_resource cookbook to resolve notification issues
- Switch linting to cookstyle
- Fix documentation for httpd_config in the README
- Resolve Foodcritic warnings
- Fix systemd start timeout on ubuntu 16.04
- Avoid node.set deprecation notices in the specs

## 0.4.0 (2016-05-31)

- Removed support for end of life platforms: Ubuntu 10.04, 13.04, 13.10, 14.10 and Suse 12.X
- Added support for Amazon 2016.X
- Added support for opensuse / opensuseleap
- Added support for modern Fedora releases and changed the code so we don't have to perform a new release every time Fedora ships
- Moved systemd unit files to /etc/system instead of /usr/lib/systemd
- Resolved nil deprecation notices in the various providers
- Removed the installation of net-tools, which is only required for integration testing. Moved this to the actual test recipe instead
- Updated kitchen-dokken config to use the latest Chef client and additional platforms
- Added back a standard .kitchen.yml file for local testing
- Fixed the test suites in Test Kitchen to reflect what Apache versions actually exist on platforms
- Added a Gemfile for testing dependencies
- Removed the Guardfile
- Updated .gitignore and chefignore files
- Added a .foodcritic file to disable FC005 and FC023
- Added a Rakefile for simplied testing
- Updated the specs to test on more recent platforms
- Converted integration tests to inspec
- Added initial, yet incomplete, support for Debian 8 / Ubuntu 16.04\. Service management is still lacking and will ship in a future release
- Removed smartos / omnios as tested platforms

## 0.3.6 (2016-04-27)

- fix some of the copious warnings about 'invalid default value' #63 [@cmenning](https://github.com/cmenning)
- Added package name to httpd_module and fixed httpd_version to match resource attribute parameter #62 [@ikari7789](https://github.com/ikari7789)
- Fix delete action for RHEL that was not removing config files correctly #74 [@darrylb-github](https://github.com/darrylb-github)

## 0.3.5 (2016-03-21)

- bug fix for #66, resolving run directories on reboot on rhel family systems using systemd [@gitjoey](https://github.com/gitjoey) and [@odoell](https://github.com/odoell)

## 0.3.4 (2016-01-26)

- bug fix for #56, ambiguous version method in sysvinit manager

## 0.3.3 (2015-11-30)

- bug fix for 32 bit support on RHEL platforms

## 0.3.2 (2015-10-28)

- depending on compat_resource >= 12.5.11

## 0.3.1 (2015-10-28)

- Fixed bug in rhel sysvinit provider
- style fixes

## 0.3.0 (2015-10-08)

- Heavy refactoring, converting to 12.5 resources with 12.x backcompat
- Removed fugly resource titles, which explodes ChefSpec.
- Commented out a ton of specs, still getting various clone warnings.

## 0.2.19 (2015-09-15)

- Updating for Amazon Linux 2015.03

## 0.2.18 (2015-06-30)

- Fixes for correct Provider Resolver behavior and more 12.4.0 fixes

## 0.2.17 (2015-06-28)

- Fixing IfModule by including .load before .conf

## 0.2.16 (2015-06-26)

- Dropping Chef 11 support
- fix the priority map dsl method

## 0.2.15 (2015-06-26)

- Fixing up provider resolution code to work properly with 12.4

## 0.2.14 (2015-06-05)

- Fixing up mod_php filename for debian based distros

## v0.2.12 (2015-05-11)

- Fixing 'provides' bug that was breaking 12.3

## v0.2.11 (2015-04-11)

- Fix config file load ordering

## v0.2.10 (2015-04-06)

- Various README fixes
- Fixing action :delete for httpd_config rhel provider

## v0.2.9 (2015-04-04)

- Adding CONTRIBUTING.md
- Adding issues and source urls to metadata

## v0.2.8 (2015-03-20)

- Fixing backwards compatibility with Chef 11

## v0.2.7 (2015-03-16)

- Updating resources and providers to use "provides" keyword instead of the old provider_mapping file

## v0.2.6 (2015-01-20)

- Fixed type mismatch bug for listen_addresses parameter
- Fixing up php-zts for el5/6

## v0.2.5 (2015-01-20)

- Fixing mpm_worker config rendering

## v0.2.4 (2015-01-19)

- Refactoring helper methods out of resource classes. Fixing up tests.

## v0.2.3 (2015-01-17)

- Fixing httpd_module 'php' on rhel family

## v0.2.2 (2015-01-12)

- Adding license and description metadata

## v0.2.1 (2015-01-12)

- Adding platform support metadata

## v0.2.0 (2014-12-31)

- Providers now avoid "system" httpd service for default instance
- Refactoring helper libraries
- Refactoring package info and mpm DSLs
- Adding more platform support
- Refactoring specs.. removing everything but centos-5 for now

## v0.1.7 (2014-12-19)

- Reverting 0.1.6 changes

## v0.1.6 (2014-12-19)

- Using "include" instead of "extend" for helper methods

## v0.1.5 (2014-08-24)

- Adding a modules parameter to httpd_service resource. It now loads a base set of modules by default

## v0.1.4 (2014-08-23)

- Renaming magic to mime.types

## v0.1.3 (2014-08-22)

- Fixing notifications by using LWRP DSL actions

## v0.1.2 (2014-08-22)

- Fixing up maxkeepaliverequests in template

## v0.1.1 (2014-08-22)

- Fixing up maxkeepaliverequests parameter

## v0.1.0 (2014-08-22)

- Initial Beta release. Let the bug hunts begin!
