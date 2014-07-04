docker-graphite
===============

Graphite docker image running under trusty. Also refactored to remove the need for a "setup.sh" file, and instead do all the building inside the dockerfile.

run it  

docker run -d -i -t -p 3000:80 -p 2003:2003 -p 2004:2004 -p 8125:8125/udp --name statsd jayofdoom/trusty-graphite-standalone
