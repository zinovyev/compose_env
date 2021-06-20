# frozen_string_literal: true

require "compose_env"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.before(:suite) do
    path = File.expand_path('./tmp', __dir__)
    Dir.entries("#{path}/").reject { |f| f.match?(/^\./) }.map do |f|
      File.delete(File.expand_path("./tmp/#{f}", __dir__))
    end
  end

  config.after(:suite) do
    path = File.expand_path('./tmp', __dir__)
    Dir.entries("#{path}/").reject { |f| f.match?(/^\./) }.map do |f|
      File.delete(File.expand_path("./tmp/#{f}", __dir__))
    end
  end

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
