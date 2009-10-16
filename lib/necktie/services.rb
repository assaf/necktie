class Services
  # Enables service to run after boot and starts it. Same as:
  #   update_rc.d <name> defaults
  #   service <name> start
  def start(name)
    puts " ** Starting service #{name}"
    system "update-rc.d #{name} defaults" and
      system "service #{name} start" or
      fail "failed to start #{name}"
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
    system "service #{name} stop" and
    system "update-rc.d -f #{name} remove" or
      fail "failed to stop #{name}"
  end

  # Disables service from running after boot.
  def disable(name)
    system "update-rc.d -f #{name} remove" or fail "cannot disable #{name}"
  end

  # Restart service. Same as:
  #   service <name> restart
  def restart(name)
    puts " ** Restarting service #{name}"
    system "service #{name} restart" or fail "failed to restart #{name}"
  end

  # Checks if service is running. Returns true or false based on the outcome
  # of service <name> status, and nil if service doesn't have a status command.
  # (Note: Not all services report their running state, or do so reliably)
  def running?(name)
    status = File.read("|service --status-all 2>&1")[/^ \[ (.) \]  #{Regexp.escape name}$/,1]
    status == "+" ? true : status == "-" ? false : nil
  end
end

# Returns Services object. Examples:
#   services.restart "nginx"
#   services.start "mysql" unless services.running?("mysql")
#   services.enable "memcached" # but don't start yet
def services
  @services ||= Services.new
end
