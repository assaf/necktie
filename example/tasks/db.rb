task "/etc/cron/snapshot" do
  cp "etc/cron/snapshot", "/etc/cron.hourly/"
  chmod 0755, "/etc/cron/snapshot"
end

task "/vol" do
  # Assumes we attach EBS volume to /dev/sdh, formatted it to XFS, mounted to /vol.
  append "/etc/fstab", "/dev/sdh /vol xfs noatime,nobarrier 0 0\n" unless read("/etc/fstab")["/dev/sdh "]
  sh "mount /vol"
end

task "/etc/mysql"=>"/vol" do
  # Mount the respective MySQL directories. Make sure they exist on your EBS volume first, see:
  # http://developer.amazonwebservices.com/connect/entry.jspa?externalID=1663
  mounts = { "/vol/etc/mysql"=>"/etc/mysql",
             "/vol/lib/mysql"=>"/var/lib/mysql",
             "/vol/log/mysql"=>"/var/log/mysql" }
  mounts.each do |vol, path|
    mkdir_p path
    append "/etc/fstab", "#{vol} #{path} none bind\n" unless read("/etc/fstab")["#{vol} "]
    sh "mount #{path}"
  end
  chmod 0755, "/etc/mysql/debian-start"
end

task "mysql"=>"/etc/mysql" do
  services.start "mysql" unless services.running?("mysql")
end

task :db=>[:mysql, "/etc/cron/snapshot"]
