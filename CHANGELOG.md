httpd Cookbook CHANGELOG
========================

0.3.2 (2015-10-28)
------------------
- depending on compat_resource >= 12.5.11

0.3.1 (2015-10-28)
------------------
- Fixed bug in rhel sysvinit provider
- style fixes

0.3.0 (2015-10-08)
------------------
- Heavy refactoring, converting to 12.5 resources with 12.x backcompat
- Removed fugly resource titles, which explodes ChefSpec.
- Commented out a ton of specs, still getting various clone warnings.

0.2.19 (2015-09-15)
------------------
- Updating for Amazon Linux 2015.03

0.2.18 (2015-06-30)
------------------
- Fixes for correct Provider Resolver behavior and more 12.4.0 fixes

0.2.17 (2015-06-28)
-------------------
- Fixing IfModule by including .load before .conf

0.2.16 (2015-06-26)
-------------------
- Dropping Chef 11 support
- fix the priority map dsl method

0.2.15 (2015-06-26)
-------------------
- Fixing up provider resolution code to work properly with 12.4

0.2.14 (2015-06-05)
-------------------
- Fixing up mod_php filename for debian based distros

v0.2.12 (2015-05-11)
-------------------
- Fixing 'provides' bug that was breaking 12.3

v0.2.11 (2015-04-11)
-------------------
- Fix config file load ordering

v0.2.10 (2015-04-06)
-------------------
- Various README fixes
- Fixing action :delete for httpd_config rhel provider

v0.2.9 (2015-04-04)
-------------------
- Adding CONTRIBUTING.md
- Adding issues and source urls to metadata

v0.2.8 (2015-03-20)
-------------------
- Fixing backwards compatibility with Chef 11

v0.2.7 (2015-03-16)
-------------------
- Updating resources and providers to use "provides" keyword instead
  of the old provider_mapping file

v0.2.6 (2015-01-20)
-------------------
- Fixed type mismatch bug for listen_addresses parameter
- Fixing up php-zts for el5/6

v0.2.5 (2015-01-20)
-------------------
- Fixing mpm_worker config rendering

v0.2.4 (2015-01-19)
-------------------
- Refactoring helper methods out of resource classes. Fixing up tests.

v0.2.3 (2015-01-17)
-------------------
- Fixing httpd_module 'php' on rhel family

v0.2.2 (2015-01-12)
-------------------
- Adding license and description metadata

v0.2.1 (2015-01-12)
-------------------
- Adding platform support metadata

v0.2.0 (2014-12-31)
-------------------
- Providers now avoid "system" httpd service for default instance
- Refactoring helper libraries
- Refactoring package info and mpm DSLs
- Adding more platform support
- Refactoring specs.. removing everything but centos-5 for now

v0.1.7 (2014-12-19)
-------------------
- Reverting 0.1.6 changes

v0.1.6 (2014-12-19)
-------------------
- Using "include" instead of "extend" for helper methods

v0.1.5 (2014-08-24)
-------------------
- Adding a modules parameter to httpd_service resource. It now loads a base set of modules by default

v0.1.4 (2014-08-23)
-------------------
- Renaming magic to mime.types

v0.1.3 (2014-08-22)
-------------------
- Fixing notifications by using LWRP DSL actions

v0.1.2 (2014-08-22)
-------------------
- Fixing up maxkeepaliverequests in template

v0.1.1 (2014-08-22)
-------------------
- Fixing up maxkeepaliverequests parameter

v0.1.0 (2014-08-22)
-------------------
- Initial Beta release. Let the bug hunts begin!
