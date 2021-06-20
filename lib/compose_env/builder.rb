module ComposeEnv
  class Builder
    attr_reader :options

    def initialize(options)
      @options = options
    end

    def build_compose_files
      parse_all do |current_env, raw_yaml|
        File.write(environment_file_name(current_env), raw_yaml)
      end
    end
    alias build_compose_files! build_compose_files

    def parse_all
      options.envs.map do |current_env|
        result = [current_env, parse_file(current_env)]
        yield(*result) if block_given?

        result
      end.to_h
    end

    private

    def environment_file_name(current_env)
      Pathname.new(dirname).join("#{basename}.#{current_env}.yml").to_s
    end

    def basename
      @basename ||= File.basename(options.file).split('.').first
    end

    def dirname
      @dirname ||= File.dirname(options.file)
    end

    def parse_file(current_env)
      env_context = Context.new(options, current_env).get_binding
      raw_yaml = erb_template.result(env_context)
      ::YAML.load(raw_yaml).to_yaml
    end

    def erb_template
      @erb_template ||= ::ERB.new(File.read(options.file))
    end
  end
end
