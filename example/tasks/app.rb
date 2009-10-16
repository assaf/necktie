task :rubygems do
  # These gems are needed in the enviroment (i.e not bundled with your Rails app).
  # For example: unicorn, rake, mysql, starling. To install a new gem or upgrade
  # existing one:
  #   $ cp /opt/local/lib/ruby/gems/1.9.1/cache/unicorn-0.93.3.gem gems/
  #   $ git add gems
  #   $ git commit -m "Added Unicorn gem"
  #   $ git push && cap necktie
  Dir["gems/*.gem"].each do |gem|
    install_gem gem
  end
end

task :memcached do
  # Out of the box, memcached listens to local requests only. We want all servers
  # in the same security group to access each other's memcached.
  unless processes.find { |p| p.cmdline[/memcached\s.*-l\s0.0.0.0/] }
    update "/etc/memcached.conf", /^-l 127.0.0.1/, "-l 0.0.0.0"
    services.start "memcached"
  end
end

task :unicorn=>[:rubygems, "#{@deploy_to}/current"] do
  # Install init.d script to manage Unicorn, before we can start it.
  cp "etc/init.d/unicorn", "/etc/init.d/"
  chmod 0755, "/etc/init.d/unicorn"
  services.start "unicorn"
end

task :nginx=>:unicorn do
  # We only care about one Nginx configuration, so enable it and disable all others.
  unless services.running?("nginx")
    rm_rf Dir["/etc/nginx/sites-enabled/*"]
    cp "etc/nginx/unicorn.conf", "/etc/nginx/sites-available/"
    ln_sf "/etc/nginx/sites-available/unicorn.conf", "/etc/nginx/sites-enabled/"
    services.start "nginx"
  end
end

task :email do
  # Have postfix send emails on behalf of our host, and start it. 
  unless services.running?("postfix")
    update "/etc/postfix/main.cf", /^myhostname\s*=.*$/, "myhostname = #{@hostname}"
    write "/etc/mailname", @hostname
    services.start "postfix"
  end
end

task :app=>[:environment, :memcached, :nginx, :email]
