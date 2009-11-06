require "rubygems/dependency_installer"

module Necktie
  module Gems
    # Installs the specified gem, if not already installed. First argument is the
    # name of the gem, or file containing the gem. Second argument is version requirement.
    # For example:
    #   install_gem "unicorn", "~>0.93"
    #
    #   Dir["gems/*.gem"].each do |gem|
    #     install_gem gem
    #   end
    def install_gem(name, version = nil)
      installer = Gem::DependencyInstaller.new
      spec = installer.find_spec_by_name_and_version(name, version).first.first
      if Gem::SourceIndex.from_installed_gems.find_name(spec.name, spec.version).empty?
        puts " ** Installing the gem #{spec.name} #{spec.version}"
        installer.install name, version
      end
    end
  end
end

include Necktie::Gems
