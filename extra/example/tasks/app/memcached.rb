# Out of the box, memcached listens to local requests only.
# Allow access from all servers (in the same security group).
unless processes.find { |p| p.cmdline[/memcached\s.*-l\s0.0.0.0/] }
  box["/etc/memcached.conf"].replace_contents! /^-l 127.0.0.1/, "-l 0.0.0.0"
  Services.start "memcached"
end
