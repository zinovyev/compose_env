# frozen_string_literal: true

require_relative 'lib/compose_env/version'

Gem::Specification.new do |spec|
  spec.name          = 'compose_env'
  spec.version       = ComposeEnv::VERSION
  spec.authors       = ["Ivan Zinovyev"]
  spec.email         = ["ivan@zinovyev.net"]

  spec.summary       = 'Prepare docker-compose files for different environments from the ERB template.'
  spec.description   = 'Prepare docker-compose files for different environments from the ERB template.'
  spec.homepage      = 'https://github.com/zinovyev/compose_env'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.4.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.executables   = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_development_dependency 'pry'
end
