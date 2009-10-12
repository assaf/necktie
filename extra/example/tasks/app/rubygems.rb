# These gems are needed in the enviroment (i.e not bundled with your Rails app).
# For example: unicorn, rake, mysql, starling. To install a new gem or upgrade
# existing one, include the .gem file in the gems directory. For example:
#   $ ls gems
#   mysql-2.8.1.gem
#   starling-starling-0.10.0.gem
#   unicorn-0.93.2.gem
launch_dir["gems/*.gem"].each do |gem|
  install_gem gem.to_s
end
