require "rush"
include Rush

class Object
  include Rush
  Rush.methods(false).each do |method|
    define_method method do |*args|
      Rush.__send__ method, *args
    end
  end
end
