module Services
  def self.start(name)
    puts " ** Starting service #{name}"
    system "update-rc.d #{name} defaults" and
      system "service #{name} start" or
      fail "failed to start #{name}"
  end

  def self.enable(name)
    system "update-rc.d #{name} defaults" or "cannot enable #{name}"
  end

  def self.stop(name)
    puts " ** Stopping service #{name}"
    system "service #{name} stop" and
    system "update-rc.d -f #{name} remove" or
      fail "failed to stop #{name}"
  end

  def self.disable(name)
    system "update-rc.d -f #{name} remove" or fail "cannot disable #{name}"
  end

  def self.restart(name)
    puts " ** Stopping service #{name}"
    system "service #{name} restart" or fail "failed to restart #{name}"
  end

  def self.status(name)
    status = File.read("|sudo service --status-all 2>&1")[/^ \[ (.) \]  #{Regexp.escape name}$/,1]
    stauts == "+" ? true : status == "-" ? false : nil
  end
end
