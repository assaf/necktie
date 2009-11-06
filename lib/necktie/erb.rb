require "erb"
 
module Necktie
  
  # Rake task that makes it stupid-easy to render ERB templates to disk. Just
  # add parameters to the yielded object, and they will be available to your
  # Template.
  #
  # Loosely based on: http://gist.github.com/215270
  class ErbTask < Rake::FileTask
    
    # Path to the input ERB template. This value will default to the value of
    # "#{output}.erb"
    attr_accessor :template
    
    def initialize(name, app) # :nodoc:
      super
      @output = name
      @template = "#{name}.erb"
      @values = {}
    end
 
    def execute(*args)
      super
      content = File.read(template)
      result = ERB.new(content, nil, '>').result(binding)
      write name, result
      puts " * Created ERB output at: #{name}" if application.options.trace
    end
 
    def self.define_task(args)
      task = super
      if task.is_a?(Necktie::ErbTask)
        yield task if block_given?
        task.prerequisites << file(task.template)
      end
      return task
    end

    def method_missing(method, *params, &block)
      if method.to_s[/^(.*)=$/, 1]
        return @values[$1] = params.first
      elsif @values.keys.include?(method.to_s)
        return @values[method.to_s]
      else
        super
      end
    end
    
  end
end
 
# Rake task that makes it stupid-easy to render ERB templates to disk. Just add
# parameters to the yielded object, and they will be available to your
# Template.
#
# For example:
#   erb 'config/SomeFile.xml' do |t|
#     t.param1 = 'value'
#     t.other_param = 'other value'
#     t.another_param = ['a', 'b', 'c']
#     t.template = 'config/SomeFile.xml.erb' # Optional - will automatically look here...
#   end
def erb(args, &block)
  Necktie::ErbTask.define_task(args, &block)
end
