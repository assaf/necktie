set :necktie_url, "git@example.com:striped"

task :necktie do
  # Copy Gem over so not depending on gem server being online, and all servers get
  # to use the same version of Necktie.
  gem_spec = Gem::SourceIndex.from_installed_gems.find_name("necktie").last
  gem_file = File.join(Gem.dir, "cache", spec.file_name)
  upload gem_file, File.basename(gem_file), :via=>:scp
  sudo "gem install #{File.basename(gem_file)}"
  # Run Necktie as sudo.
  sudo "necktie #{necktie_url} #{ENV["ROLES"].gsub(',', ' ')} RAILS_ENV=#{fetch(:rails_env, "production")}"
end
before "deploy:cold", "necktie"
