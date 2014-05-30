* Introduction
  ============

  The HTTPD cookbook is a "reboot" of the apache2 cookbook. The goal
  here is go design it from the ground up, with modern "best
  practices" (2014), taking full advantage of the test tooling.

  The cookbook will provide primitives for manipulating various
  aspects of running an apache web server. Ideally, we want to use
  platform native idioms when dealing with a technology, so that
  administrators will have as few surprises as possible. This is a
  challenge to do in a cross-platform way, for various reasons.

  Most platforms package Apache in their own special way and provide
  different defaults out of the box defaults. These idioms are often
  encoded into the package management systems. For example,
  installing an apache module package will oftem drop off configuration in
  specific locations, and have selinux or apparmor policies that will
  break if you deviate from them.

  For bonus points, the configuration file formats, defaults, and
  idioms change from Apache 2.2 to Apache 2.4.
  
  This document serves as a place to document the exploration of these
  idioms, and will be referenced during the implementation of the
  platform providers. 
   
* Pristine Source
  ===============

  For starters, I thought it would be a good idea to take a look at
  how a pristine source tarball installation handles the
  configuration layout. 
  
  ```   
  wget http://psg.mtu.edu/pub/apache//httpd/httpd-2.2.27.tar.gz
  tar xzvf httpd-2.2.27.tar.gz -C /usr/src/
  cd /usr/src/httpd-2.2.27 && ./configure && make && make install
  ```

  ```
  wget http://www.webhostingjams.com/mirror/apache//httpd/httpd-2.4.9.tar.gz
  tar xzvf httpd-2.4.9.tar.gz -C /usr/src
  cd /usr/src/httpd-2.4.9 && ./configure && make && make install
  ```
 
  Doing either of those yields the following directory layout:

  ```  
  /usr/local/apache2
  /usr/local/apache2/conf
  /usr/local/apache2/conf/httpd.conf
  /usr/local/apache2/conf/magic
  /usr/local/apache2/conf/mime.types
  /usr/local/apache2/conf/extra/httpd-autoindex.conf
  /usr/local/apache2/conf/extra/httpd-dav.conf
  /usr/local/apache2/conf/extra/httpd-default.conf
  /usr/local/apache2/conf/extra/httpd-info.conf
  /usr/local/apache2/conf/extra/httpd-languages.conf
  /usr/local/apache2/conf/extra/httpd-manual.conf
  /usr/local/apache2/conf/extra/httpd-mpm.conf
  /usr/local/apache2/conf/extra/httpd-multilang-errordoc.conf
  /usr/local/apache2/conf/extra/httpd-ssl.conf
  /usr/local/apache2/conf/extra/httpd-userdir.conf
  /usr/local/apache2/conf/extra/httpd-vhosts.conf
  /usr/local/apache2/conf/extra/proxy-html.conf # 2.4 only
  ```

  The default "Apache way" turns out to be gigantic monolithic
  configuration file, with large sections of comments.

  Reading through the default httpd.conf, default configurations are:
  
  ```
  ServerRoot "/usr/local/apache2"
  Listen 80  
  User daemon
  Group Daemon
  ServerAdmin you@example.com
  DocumentRoot "/usr/local/apache2/htdocs"
  <Directory />
  <Directory "/usr/local/apache2/htdocs"> # matches DocumentRoot
  <IfModule dir_module>
  <FilesMatch "^\.ht">
  ErrorLog "logs/error_log"
  LogLevel warn
  <IfModule log_config_module>
  <IfModule alias_module>
  <IfModule cgid_module>  
  <Directory "/usr/local/apache2/cgi-bin">
  DefaultType text/plain
  <IfModule mime_module>
  <IfModule ssl_module>
  ```
  
* RHEL / Fedora
** selinux
   cookbooks will be developed with selinux set to enforcing
   module usage may require selinux boolean manipulation
   httpd_can_network_connect
   httpd_can_network_connect_db
   httpd_use_nfs
   httpd_enable_cgi
   httpd_serve_cobbler_files

** default layout
   /etc/httpd/conf.d/httpd.conf
   monolithic config ala pristine, but layed out differently.
   lots of "comment me out to do blah" blocks everywhere

* Smartos / OmniOS
  Yet more variations on the monolithic config with different things
  broken out into various files. "comment me out" blocks

* Debian
  Debian / Ubuntu do the most elaborate config layout

       /etc/apache2/
       |-- apache2.conf
       |       `--  ports.conf
       |-- mods-enabled
       |       |-- *.load
       |       `-- *.conf
       |-- conf-enabled
       |       `-- *.conf
       `-- sites-enabled
               `-- *.conf

* Windows
  ha.

* Thoughts:
  It's pretty clear that no one platform does things "the right way".
  
  The closest is probably Debian.
  
  Best thing to do would be make the interface and settings uniform
  across all platforms. However, the platform providers should (by
  default) write files into directories that don't require extra
  configuration of security systems like selinux or apparmor.


* Primitives - rough sketch.
  ```
  httpd_service 'default' do
    version '2.4'
    listen_addresses ['1.2.3.4', '5.6.7.8']
    listen_ports ['80','443']
    contact 'sysop@computers.biz'
    timeout '400'
    keepalive true
    keepaliverequests '100'
    keepalivetimeout '5'
    action :create
  end

  httpd_module 'php5' do
    filename 'libphp5.so'
    action :create
  end

  httpd_module 'ssl' do
    action :enable
  end

  httpd_module 'dav' do
    action :disable
  end

  httpd_vhost 'example.computers.biz' do
    servername 'example.computers.biz',
    port '80',
    docroot '/var/www/example.computers.biz',
    action :create
  end

  httpd_vhost 'example.computers.biz ssl' do
    servername 'example.computers.biz'
    port '443'
    docroot '/var/www/example.computers.biz'
    ssl true
    action :create
  end
  ```
