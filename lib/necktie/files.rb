def fix_file(file, &block)
  text = block.call(File.read(file))
  File.open file, "w" do |out|
    out.write text
  end
end
