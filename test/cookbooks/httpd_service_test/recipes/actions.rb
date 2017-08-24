apt_update 'update'

# This recipe creates a separate httpd_service listening on its own port(s) to
# test each httpd_service action.  Integration tests determine whether each
# action was successful by checking for on-disk configuration, listening ports,
# and contents of PID files.

# Delete any services left over from previous converges.
%w(create delete start stop restart reload).each do |act|
  httpd_service "cleanup #{act}_test" do
    instance "#{act}_test"
    action :delete
  end
end

########################################
# action :create
# setup: create an httpd_service
# test: confirm that httpd configuration files exist.

httpd_service 'create create_test' do
  instance 'create_test'
  listen_ports [8101]
  startservers '1'
  minspareservers '1'
  maxspareservers '1'
  action :create
end

########################################
# action :delete
# setup: create an httpd_service, then delete it.
# test: confirm that httpd configuration files do not exist.

httpd_service 'create & start delete_test' do
  instance 'delete_test'
  listen_ports [8102]
  startservers '1'
  minspareservers '1'
  maxspareservers '1'
  action [:create, :start]
end

httpd_service 'delete delete_test' do
  instance 'delete_test'
  action :delete
end

########################################
# action :start
# setup: create an httpd_service, then start it.
# test: confirm that httpd service is listening on its assigned port.

httpd_service 'create start_test' do
  instance 'start_test'
  listen_ports [8103]
  startservers '1'
  minspareservers '1'
  maxspareservers '1'
  action :create
end

httpd_service 'start start_test' do
  instance 'start_test'
  action :start
end

########################################
# action :stop
# setup: create and start an httpd_service, then stop it.
# test: confirm that httpd service is not listening on its assigned port.

httpd_service 'create & start stop_test' do
  instance 'stop_test'
  listen_ports [8104]
  startservers '1'
  minspareservers '1'
  maxspareservers '1'
  action [:create, :start]
end

httpd_service 'stop stop_test' do
  instance 'stop_test'
  action :stop
end

########################################
# action :restart
# setup: 1. create and start an httpd_service
#        2. make a copy of its PID file,
#        3. add another listen directive to the service's config
#        4. restart the httpd_service
#        5. make another copy of its PID file.
# test: confirm that the two PID files contain valid PIDs, that the two PIDs
#       differ, and that the service is listening on both ports.

restart_res = httpd_service 'create & start restart_test' do
  instance 'restart_test'
  listen_ports [8105]
  startservers '1'
  minspareservers '1'
  maxspareservers '1'
  action [:create, :start]
end

ruby_block 'wait for restart pid' do
  block do
    (1..15).each do |_v|
      sleep(1) unless ::File.exist?(restart_res.pid_file)
    end
  end
end

remote_file '/restart-pre-action-pids' do
  source "file://#{restart_res.pid_file}"
end

httpd_config 'new-listener' do
  instance 'restart_test'
  source 'new-listener.erb'
  variables(port: 8106)
end

httpd_service 'restart restart_test' do
  instance 'restart_test'
  action :restart
  notifies :run, 'ruby_block[wait for restart pid]', :immediately
end

remote_file '/restart-post-action-pids' do
  source "file://#{restart_res.pid_file}"
end

########################################
# action :reload
# setup: 1. create and start an httpd_service
#        2. make a copy of its PID file,
#        3. add another listen directive to the service's config
#        4. reload the httpd_service
#        5. make another copy of its PID file.
# test: confirm that the two PID files contain valid PIDs, that the two PIDs
#       are the same, and that the service is listening on both ports.

reload_res = httpd_service 'create & start reload_test' do
  instance 'reload_test'
  listen_ports [8107]
  startservers '1'
  minspareservers '1'
  maxspareservers '1'
  action [:create, :start]
end

ruby_block 'wait for reload pid' do
  block do
    (1..15).each do |_v|
      sleep(1) unless ::File.exist?(reload_res.pid_file)
    end
  end
end

remote_file '/reload-pre-action-pids' do
  source "file://#{reload_res.pid_file}"
end

httpd_config 'new-listener' do
  instance 'reload_test'
  source 'new-listener.erb'
  variables(port: 8108)
end

httpd_service 'reload reload_test' do
  instance 'reload_test'
  action :reload
  notifies :run, 'ruby_block[wait for reload pid]', :immediately
end

remote_file '/reload-post-action-pids' do
  source "file://#{reload_res.pid_file}"
end
