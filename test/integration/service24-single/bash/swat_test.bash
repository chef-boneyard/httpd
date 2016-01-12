apt-get install -qq curl cpanminus make gcc libc6-dev  -y

# I don't want this test to fail 
# if we don't have cpanminus installed
# just exit with zero code

which cpanm || exit 0

cpanm Sparrow -q || exit 1

sparrow plg install swat-httpd-cookbook

sparrow project create foo

sparrow check add foo httpd

sparrow check set foo httpd -p swat-httpd-cookbook -u 127.0.0.1

match_l=300 sparrow check run foo httpd

st=$?

# find /root/.swat/.cache/ -type f -exec tail -n +1 {} \;

exit $st

     
