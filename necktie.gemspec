Gem::Specification.new do |spec|
  spec.name           = "necktie"
  spec.version        = "1.0.6"
  spec.author         = "Assaf Arkin"
  spec.email          = "assaf@labnotes.org"
  spec.homepage       = "http://github.com/assaf/necktie"
  spec.summary        = "Dress to impress"
  spec.description    = "Configure your servers using Ruby and Git"

  spec.files          = Dir["{bin,lib,vendor,example}/**/*", "CHANGELOG", "README.rdoc", "necktie.gemspec"]
  spec.executable     = "necktie"

  spec.has_rdoc         = true
  spec.extra_rdoc_files = "README.rdoc", "CHANGELOG"
  spec.rdoc_options     = "--title", "Necktie #{spec.version}", "--main", "README.rdoc",
                          "--webcvs", "http://github.com/assaf/#{spec.name}"
end
