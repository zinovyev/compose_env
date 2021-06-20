# frozen_string_literal: true

require 'pathname'
require 'optparse'
require 'erb'
require 'yaml'
require 'pry'
require_relative "compose_env/version"
require_relative "compose_env/input_parser"
require_relative "compose_env/context"
require_relative "compose_env/builder"

module ComposeEnv
  extend self

  def run(argv)
    options = InputParser.parse(argv)
    Builder.new(options).build_compose_files!
  end
end
