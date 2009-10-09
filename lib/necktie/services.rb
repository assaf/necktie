def start_service(name)
  puts " ** Starting service #{name}"
  system "update-rc.d #{name} defaults" and
    system "service #{name} start" or
    fail "failed to start #{name}"
end

def stop_service(name)
  puts " ** Stopping service #{name}"
  system "service #{name} stop" and
  system "update-rc.d -f #{name} remove" or
    fail "failed to shutdown #{name}"
end
