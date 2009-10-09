def fix_file(file, &block)
  text = block.call(File.read(file))
  File.open file, "w" do |out|
    out.write text
  end
end

def touch(name)
  if File.exist?(name)
    File.utime time = Time.now, time, "foo"
  else
    File.open(name, "a").close
  end
end
