class Services
  def start(name)
    puts " ** Starting service #{name}"
    system "update-rc.d #{name} defaults" and
      system "service #{name} start" or
      fail "failed to start #{name}"
  end

  def enable(name)
    system "update-rc.d #{name} defaults" or "cannot enable #{name}"
  end

  def stop(name)
    puts " ** Stopping service #{name}"
    system "service #{name} stop" and
    system "update-rc.d -f #{name} remove" or
      fail "failed to stop #{name}"
  end

  def disable(name)
    system "update-rc.d -f #{name} remove" or fail "cannot disable #{name}"
  end

  def restart(name)
    puts " ** Stopping service #{name}"
    system "service #{name} restart" or fail "failed to restart #{name}"
  end

  def running?(name)
    status = File.read("|service --status-all 2>&1")[/^ \[ (.) \]  #{Regexp.escape name}$/,1]
    status == "+" ? true : status == "-" ? false : nil
  end
end

def services
  @services ||= Services.new
end
