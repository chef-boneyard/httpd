PATH=$PATH:/usr/local/bin/

sparrow 1>/dev/null || exit 1

sparrow project create foo

sparrow check add foo httpd

sparrow check set foo httpd swat-httpd-cookbook 127.0.0.1

match_l=300 \
prove_options="'--color --verbose'" \
sparrow check run foo httpd

st=$?

# find /root/.swat/.cache/ -type f -exec tail -n +1 {} \;

exit $st


     
