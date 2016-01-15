PATH=$PATH:/usr/local/bin/

which sparrow 1>/dev/null || exit 1

sparrow project create foo

sparrow check add foo httpd

sparrow check set foo httpd -p swat-httpd-cookbook -u 127.0.0.1

match_l=300 \
sparrow check run foo httpd

st=$?

# find /root/.swat/.cache/ -type f -exec tail -n +1 {} \;

exit $st


     
