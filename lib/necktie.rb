require "fileutils"
extend FileUtils
require "necktie/gems"
require "necktie/services"
require "necktie/files"

def necktie(args)
  etc = "/etc/necktie"
  File.writable?(etc) or File.writable?(File.dirname(etc)) or fail "Can't write to #{etc}. You should be running necktie as sudo."

  envs, args = args.partition { |a| a[/=/] }
  git_url = args.shift or fail "Usage: necktie git-url role* name=value*"
  roles = args
  # Setup environment variable from name=value arguments.
  envs.each do |env|
    name, value = env.split("=")
    ENV[name] = value
  end

  # Default role is app. For all rules, execute setup scripts.
  if roles.empty?
    puts "    Default role: app"
    roles = ["app"]
  end

  repo = File.expand_path(".necktie")
  if File.exist?(repo)
    puts "  * Pulling latest updates to #{repo}"
    system "cd #{repo.inspect} && git pull origin #{ENV["branch"] || "master"}" or fail
  else
    puts "  * Cloning #{git_url} to #{repo}"
    system "git clone #{git_url} #{repo.inspect}" or fail
  end

  Dir.chdir repo do
    executed = File.exist?(etc) ? File.read(etc).split("\n") : []
    roles.each do |role|
      tasks = Dir["tasks/#{role}/*.rb"].sort.map { |name| File.basename(name).gsub(/(.*)\.rb$/, "#{role}/\\1") }
      todo = tasks - executed
      if tasks.empty?
        puts "  * No tasks for role #{role}"
      elsif todo.empty?
        puts "  * All tasks completed for role #{role}"
      else
        puts "  * Now in role: #{role}"
        File.open etc, "a" do |f|
          todo.each do |task|
            puts " ** Executing #{task.split("/").last}"
            load "tasks/#{task}.rb"
            f.puts task
          end
        end
      end
    end
  end

end
