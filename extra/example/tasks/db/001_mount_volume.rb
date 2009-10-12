# Assumes we attach EBS volume to /dev/sdh, formatted it to XFS, mounted to /vol.
box["/etc/fstab"].append "\n/dev/sdh /vol xfs noatime,nobarrier 0 0" unless box["/etc/fstab"].search("/dev/sdh ")
bash "mount /vol"

# Mount the respective MySQL directories. Make sure they exist on your EBS volume first, see:
# http://developer.amazonwebservices.com/connect/entry.jspa?externalID=1663
mounts = { "/vol/etc/mysql"=>"/etc/mysql",
           "/vol/lib/mysql"=>"/var/lib/mysql",
           "/vol/log/mysql"=>"/var/log/mysql" }
mounts.each do |vol, path|
  box["#{path}/"].create
  box["/etc/fstab"].append "\n#{vol} #{path} none bind" unless box["/etc/fstab"].search("#{vol} ")
  bash "mount #{path}"
end
box["/etc/mysql/debian-start"].access = { user_group_can: :read_write_execute }

# Now is a good time to start MySQL.
Services.start "mysql"
