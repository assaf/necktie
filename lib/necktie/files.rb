module Necktie::Files
  # Return the contents of the file (same as File.read).
  def read(name)
    File.read(name)
  end

  # Writes contents to a new file, or overwrites existing file.
  # Takes string as second argument, or yields to block. For example:
  #   write "/etc/mailname", "example.com"
  #   write("/var/run/bowtie.pid") { Process.pid }
  def write(name, contents = nil)
    contents ||= yield
    File.open name, "w" do |f|
      f.write contents
    end
  end

  # Append contents to a file, creating it if necessary.
  # Takes string as second argument, or yields to block. For example:
  #   append "/etc/fstab", "/dev/sdh /vol xfs\n" unless read("/etc/fstab")["/dev/sdh "]
  def append(name, contents = nil)
    contents ||= yield
    File.open name, "a" do |f|
      f.write contents
    end
  end

  # Updates a file: read contents, substitue and write it back.
  # Takes two arguments for substitution, or yields to block.
  # These two are equivalent:
  #   update "/etc/memcached.conf", /^-l 127.0.0.1/, "-l 0.0.0.0"
  #   update("/etc/memcached.conf") { |s| s.sub(/^-l 127.0.0.1/, "-l 0.0.0.0") }
  def update(name, from = nil, to = nil)
    contents = File.read(name)
    if from && to
      contents = contents.sub(from, to)
    else
      contents = yield(contents)
    end
    write name, contents
  end
end

include Necktie::Files
