set :necktie_git, "git@example.com:striped"
set :env, "staging"

task :setup, :roles=>:app do
  gem_spec = Gem::SourceIndex.from_installed_gems.find_name("necktie").last
  gem_file = File.join(Gem.dir, "cache", spec.file_name)
  upload gem_file, File.basename(gem_file), :via=>:scp
  sudo "gem install #{File.basename(gem_file)}"
  sudo "necktie #{necktie_git} app env=#{env}"
end
