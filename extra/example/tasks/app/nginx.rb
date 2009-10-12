# setup nginx: copy our site configuration over and enable only it.
unless Services.status("nginx")
  box["/etc/nginx/sites-enabled/"].purge
  launch_dir["etc/nginx/unicorn.conf"].copy_to box["/etc/nginx/sites-available/"]
  ln_sf "/etc/nginx/sites-available/unicorn.conf", "/etc/nginx/sites-enabled/"
  Services.start "nginx"
end
