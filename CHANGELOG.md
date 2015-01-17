httpd Cookbook CHANGELOG
========================

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
