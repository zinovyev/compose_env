module ComposeEnv
  # Parse input options.
  # Prepare the options for being pipelined to the follow-up processors.
  class InputParser
    DEFAULT_ENVS = %i[development staging production].freeze
    DEFAULT_FILE = 'docker-compose.yml.erb'.freeze

    Options = Struct.new(:envs, :file)

    def self.parse(options)
      new.parse(options)
    end

    def parse(options)
      prepared_options = prepare(options)
      option_parser.parse!(prepared_options)
      return args
    end

    private

    def option_parser
      OptionParser.new do |opts|
        opts.banner = "Usage: compose-env [options]"

        opts.on("-eENVIROMENTS", "--envs=ENVIRONMENTS", "List of environments") do |envs|
          args.envs = normalize_envs(envs)
        end

        opts.on("-fFILE", "--file=FILE", "The name of a template file to parse") do |file|
          args.file = normalize_file(file)
        end

        opts.on("-h", "--help", "Prints this help") do
          puts opts
          exit
        end
      end
    end

    def args
      @args ||= Options.new(DEFAULT_ENVS, normalize_file(DEFAULT_FILE))
    end

    def normalize_envs(envs)
      envs.split(',').map(&:strip).map(&:to_sym)
    end

    def normalize_file(file)
      Pathname.new(Dir.pwd).join(file).to_s
    end

    # Prepare a comma separated string to be parsed as one argument even with whitespaces in it
    def prepare(options)
      options.join(' ').gsub(/\s*,\s*/, ',').split(' ')
    end
  end
end
