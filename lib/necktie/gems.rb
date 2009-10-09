require "rubygems/dependency_installer"

def self.install_gem(name, version = nil)
  installer = Gem::DependencyInstaller.new
  spec = installer.find_spec_by_name_and_version(name, version).first.first
  if Gem::SourceIndex.from_installed_gems.find_name(spec.name, spec.version).empty?
    puts " ** Installing the gem #{spec.name} #{spec.version}"
    installer.install name, version
  end
end
