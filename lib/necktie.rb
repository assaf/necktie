require "necktie/rake"
require "necktie/files"
require "necktie/gems"
require "necktie/services"
require "necktie/rush"


Rake.application = Necktie::Application.new
Rake.application.run
