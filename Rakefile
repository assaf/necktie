version = Gem::Specification.load(File.expand_path("necktie.gemspec", File.dirname(__FILE__))).version.to_s.freeze

task :push do
  sh "git push"
  puts "Tagging version #{version} .."
  sh "git tag #{version}"
  sh "git push --tag"
  puts "Building and pushing gem .."
  sh "gem build necktie.gemspec"
  sh "gem push necktie-#{version}.gem"
end
