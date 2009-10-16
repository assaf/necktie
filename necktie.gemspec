Gem::Specification.new do |spec|
  spec.name           = "necktie"
  spec.version        = "0.3.6"
  spec.author         = "Assaf Arkin"
  spec.email          = "assaf@labnotes.org"
  spec.homepage       = "http://github.com/assaf/necktie"
  spec.summary        = "Dress to impress"
  spec.description    = "Configure your servers remotely using Ruby and Git"

  spec.files          = Dir["{bin,lib,vendor}/**/*", "*.{gemspec,rdoc}"]
  spec.executable     = "necktie"
end
