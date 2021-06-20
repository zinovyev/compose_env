require 'pry'
module ComposeEnv
  class Context
    attr_reader :options, :current_env

    def initialize(options, current_env)
      @options = options
      @current_env = current_env
    end

    def method_missing(name, *args, &block)
      method_name = name.to_sym
      return handle_test_method(method_name) if test_method?(method_name)
      return handle_restriction_method(method_name, &block) if restriction_method?(method_name)

      super
    end

    def env
      self
    end

    def env?(*env_names, &block)
      return unless block_given?

      first_env = env_names.first
      env_names = first_env.is_a?(Array) ? first_env : env_names
      return unless env_names.map(&:to_sym).include?(current_env)

      block.call(self)
    end

    def get_binding
      binding
    end

    def handle_test_method(method_name)
      return method_name == "#{current_env}?".to_sym
    end

    def handle_restriction_method(method_name, &block)
      return unless block_given? && method_name == current_env

      block.call(self)
    end

    def test_method?(method_name)
      test_methods.include?(method_name)
    end

    def restriction_method?(method_name)
      restriction_methods.include?(method_name)
    end

    def test_methods
      @test_methods ||= env_methods[:test]
    end

    def restriction_methods
      @restriction_methods ||= env_methods[:restriction]
    end

    def env_methods
      return @env_methods unless @env_methods.nil?

      options.envs.each_with_object({test: [], restriction: []}) do |env, acc|
        test_method = "#{env}?".to_sym
        acc[:test] << test_method
        acc[:restriction] << env
      end
    end
  end
end
