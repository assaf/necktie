# cap necktie task
Capistrano::Configuration.instance.load do
  namespace :necktie do
    desc "[internal] Install necktie on remote server"
    task :install do
      spec = Gem::Specification.load(File.expand_path("../../necktie.gemspec", File.dirname(__FILE__)))
      gem_spec = Gem::SourceIndex.from_installed_gems.find_name(spec.name, spec.version).last
      gem_file = File.join(Gem.dir, "cache", gem_spec.file_name)
      upload gem_file, File.basename(gem_file), :via=>:scp
      sudo "gem install #{File.basename(gem_file)}"
    end

    desc "[internal] Pull updates from Git"
    task :pull do
      fail "You need to set :necktie_url, <git_url>" unless necktie_url
      sudo "necktie --source #{necktie_url} --update"
    end

    desc "[internal] Run necktie upgrade"
    task :upgrade do # run necktime
      tasks = ENV["ROLES"].to_s.split(",") # ROLES => task names
      sudo "necktie --environment #{fetch(:rails_env, "production")} #{tasks.join(" ")}"
    end

    desc "Run necktie on all servers (you can use HOSTS or RAILS env vars)"
    task :default do
      fail "You need to set :necktie_url, <git_url>" unless necktie_url
      install
      pull
      upgrade
    end

    before "necktie:upgrade", "deploy:web:disable"
    after  "necktie:upgrade", "deploy:web:enable"
  end
end
