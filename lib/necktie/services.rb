module Necktie
  class Services
    # Enables service to run after boot and starts it. Same as:
    #   update_rc.d <name> defaults
    #   service <name> start
    def start(name)
      puts " ** Starting service #{name}"
      sh "update-rc.d #{name} defaults"
      sh "service #{name} start"
    end

    # Enables service to run after boot.
    def enable(name)
      system "update-rc.d #{name} defaults" or "cannot enable #{name}"
    end

    # Disables service and stops it. Same as:
    #   service <name> stop
    #   update_rc.d <name> remove
    def stop(name)
      puts " ** Stopping service #{name}"
      sh "service #{name} stop"
      sh "update-rc.d -f #{name} remove"
    end

    # Disables service from running after boot.
    def disable(name)
      sh "update-rc.d -f #{name} remove"
    end

    # Restart service. Same as:
    #   service <name> restart
    def restart(name)
      puts " ** Restarting service #{name}"
      sh "service #{name} restart"
    end

    # Reload configuration. Same as:
    #   service <name> reload
    def reload(name)
      sh "service #{name} reload"
    end

    # Checks if service is running. Returns true or false based on the outcome
    # of service <name> status, and nil if service doesn't have a status command.
    # (Note: Not all services report their running state, or do so reliably)
    def running?(name)
      status = File.read("|service #{name} status 2>&1")
      status[/is running/] ? true : status[/is not running/] ? false : status.empty? ? false : nil;
    end
  end
end

# Returns Necktie::Services object. Examples:
#   services.restart "nginx"
#   services.start "mysql" unless services.running?("mysql")
#   services.enable "memcached" # but don't start yet
def services
  @services ||= Necktie::Services.new
end
