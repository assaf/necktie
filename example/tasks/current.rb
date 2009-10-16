user, group = "nginx", "nginx"

shared_path = "#{@deploy_to}/shared"
cached_copy = "#{shared_path}/cached-copy"
releases_path = "#{@deploy_to}/releases"
release = Time.now.utc.strftime("%Y%m%d%H%M%S")
release_path = "#{releases_path}/#{release}"
current_path = "#{@deploy_to}/current"

file @deploy_to do
  mkdir_p @deploy_to
  chown user, group, @deploy_to
  chmod 0770, @deploy_to
end

file shared_path=>@deploy_to do
  mkdir_p ["#{shared_path}/system", "#{shared_path}/pids", "#{shared_path}/log"]
  chown_R user, group, shared_path
  chmod_R 0770, shared_path
end

file releases_path=>@deploy_to do
  mkdir_p releases_path
  chown user, group, releases_path
  chmod 0770, releases_path
end

file cached_copy=>shared_path do
  sh "git clone #{@git_url} #{cached_copy}"
  chown_R user, group, cached_copy
end

file release_path=>[releases_path, cached_copy] do
  cp_r cached_copy, release_path
  revision = bash("git --git-dir=#{cached_copy}/.git rev-parse --verify HEAD")
  write "#{release_path}/REVISION", revision
  touch release_path
  sh "chmod -R g+w #{release_path}"
  rm_rf ["#{release_path}/log", "#{release_path}/public/system", "#{release_path}/tmp/pids"]
  mkdir_p ["#{release_path}/public", "#{release_path}/tmp"]
  ln_s "#{shared_path}/log", "#{release_path}/log"
  ln_s "#{shared_path}/system", "#{release_path}/public/system"
  ln_s "#{shared_path}/pids", "#{release_path}/tmp/pids"
end

file current_path=>[release_path, shared_path] do
  rm_f current_path
  ln_s release_path, current_path
end
