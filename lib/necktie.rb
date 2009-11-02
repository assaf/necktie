require "necktie/application"
require "necktie/files"
require "necktie/gems"
require "necktie/services"
require "necktie/rush"


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
    STRING = Gem::Specification.load(File.expand_path("../necktie.gemspec", File.dirname(__FILE__))).version.to_s.freeze
    MAJOR, MINOR, PATCH = STRING.split(".").map { |i| i.to_i }
  end
end
