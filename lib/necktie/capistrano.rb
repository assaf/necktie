Capistrano::Configuration.instance.load do
  desc "Run necktie on all servers (you can use HOSTS or RAILS env vars)"
  task :necktie do
    fail "You need to set :necktie_url, <git_url>" unless necktie_url
    spec = Gem::Specification.load(File.expand_path("../../necktie.gemspec", File.dirname(__FILE__)))
    gem_spec = Gem::SourceIndex.from_installed_gems.find_name(spec.name, spec.version).last
    gem_file = File.join(Gem.dir, "cache", gem_spec.file_name)
    upload gem_file, File.basename(gem_file), :via=>:scp
    sudo "gem install #{File.basename(gem_file)}"
    tasks = ENV["ROLES"].to_s.split(",") # ROLES => task names
    sudo "necktie --source #{necktie_url} --update --environment #{fetch(:rails_env, "production")} #{task.join(" ")}"
  end
end
