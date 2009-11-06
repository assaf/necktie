require "necktie/application"
require "necktie/files"
require "necktie/gems"
require "necktie/services"
require "necktie/rush"
require "necktie/erb"


# Includes all methods from Necktie::Files and Necktie::Gems methods.
#
# Includes Rake DSL, see http://rake.rubyforge.org for more details.
#
# Includes Rush, see http://rush.heroku.com for more details.
class Object
end


module Necktie
  # Version number.
  module Version
    version = Gem::Specification.load(File.expand_path("../necktie.gemspec", File.dirname(__FILE__))).version.to_s.split(".").map { |i| i.to_i }
    MAJOR = version[0]
    MINOR = version[1]
    PATCH = version[2]
    STRING = "#{MAJOR}.#{MINOR}.#{PATCH}"
  end
end
