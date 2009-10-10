def patch(file, &block)
  text = block.call(File.read(file))
  File.open file, "w" do |out|
    out.write text
  end
end

def write(name, content = "")
  File.open name, "w" do |f|
    f.write content
  end
end

def append(name, content = "")
  File.open name, "a" do |f|
    f.write content
  end
end

def read(name)
  File.read(name)
end

def touch(name)
  if File.exist?(name)
    File.utime time = Time.now, time, "foo"
  else
    File.open(name, "a").close
  end
end
