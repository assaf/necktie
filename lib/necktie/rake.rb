require "rake"

module Necktie
  class Application < Rake::Application #:nodoc:

    def initialize
      super
      @name = "necktie"
      @rakefiles = ["Necktie", "necktie", "Necktie.rb", "necktie.rb"]
      options.nosearch = true
      options.env = "production"
    end

    def run
      standard_exception_handling do
        init
        repo = File.expand_path(".necktie")
        if File.exist?(repo)
          Dir.chdir repo do
            puts "Pulling latest updates ..."
            sh "git pull origin #{ENV["BRANCH"] || "master"}", :verbose=>false
          end if options.pull
        else
          git_url = ENV["GIT_URL"] or fail "Need GIT_URL variable to point to Git repository, can't clone without it"
          puts "Cloning #{git_url} to #{repo}"
          sh "git clone #{git_url} #{repo.inspect}", :verbose=>false
        end
        Dir.chdir repo do
          load_rakefile
          top_level
        end
      end
    end

    def necktie_options
      [
        ['--env', '-e NAME', "Sets the environment (defaults to 'production').",
          lambda { |value|
            options.env = value
          }
        ],
        ['--describe', '-D [PATTERN]', "Describe the tasks (matching optional PATTERN), then exit.",
          lambda { |value|
            options.show_tasks = :describe
            options.show_task_pattern = Regexp.new(value || '')
            TaskManager.record_task_metadata = true
          }
        ],
        ['--execute-print',  '-p CODE', "Execute some Ruby code, print the result, then exit.",
          lambda { |value|
            puts eval(value)
            exit
          }
        ],
        ['--execute-continue',  '-E CODE',
          "Execute some Ruby code, then continue with normal task processing.",
          lambda { |value| eval(value) }            
        ],
        ['--prereqs', '-P', "Display the tasks and dependencies, then exit.",
          lambda { |value| options.show_prereqs = true }
        ],
        ['--tasks', '-T [PATTERN]', "Display the tasks (matching optional PATTERN) with descriptions, then exit.",
          lambda { |value|
            options.show_tasks = :tasks
            options.show_task_pattern = Regexp.new(value || '')
            Rake::TaskManager.record_task_metadata = true
          }
        ],
        ['--trace', '-t', "Turn on invoke/execute tracing, enable full backtrace.",
          lambda { |value|
            options.trace = true
            verbose(true)
          }
        ],
        ['--verbose', '-v', "Log message to standard output.",
          lambda { |value| verbose(true) }
        ],
        ['--version', '-V', "Display the program version.",
          lambda { |value|
            spec = Gem::Specification.load(File.expand_path("../../necktie.gemspec", File.dirname(__FILE__)))
            puts "Necktie, version #{spec.version}"
            exit
          }
        ],
        ['--where', '-W [PATTERN]', "Describe the tasks (matching optional PATTERN), then exit.",
          lambda { |value|
            options.show_tasks = :lines
            options.show_task_pattern = Regexp.new(value || '')
            Rake::TaskManager.record_task_metadata = true
          }
        ],
        ['--update', '-U', "Update .necktie directory (git pull)",
          lambda { |value| options.pull = true }
        ]
      ]
    end

    # Read and handle the command line options.
    def handle_options
      options.rakelib = ['necktie']
      options.top_level_dsl = true

      OptionParser.new do |opts|
        opts.banner = "necktie git_url {options} tasks..."
        opts.separator ""
        opts.separator "Options are ..."

        opts.on_tail("-h", "--help", "-H", "Display this help message.") do
          puts opts
          exit
        end

        necktie_options.each { |args| opts.on(*args) }
        opts.environment('RAKEOPT')
      end.parse!

      Rake::DSL.include_in_top_scope
    end

    def raw_load_rakefile # :nodoc:
      @rakefile = have_rakefile
      fail "No Necktie file found (looking for: #{@rakefiles.join(', ')})" if @rakefile.nil?
      Rake::Environment.load_rakefile(File.expand_path(@rakefile)) if @rakefile && @rakefile != ''
      options.rakelib.each do |rlib|
        glob("necktie/*.rb") do |name|
          add_import name
        end
      end
      load_imports
    end

  end

  # Returns the environment name (set using -e command line option).
  def self.env
    Rake.application.options.env
  end
end
