def read(name)
  File.read(name)
end

def write(name, contents = nil)
  contents ||= yield
  File.open name, "w" do |f|
    f.write contents
  end
end

def append(name, contents = nil)
  contents ||= yield
  File.open name, "a" do |f|
    f.write contents
  end
end

def update(name, from = nil, to = nil)
  contents = File.read(name)
  if from && to
    contents = contents.sub(from, to)
  else
    contents = yield(contents)
  end
  File.open name, "w" do |f|
    f.write contents
  end
end
