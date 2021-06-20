# frozen_string_literal: true

def relative_path(path)
  File.expand_path(path, __dir__)
end

def file_content(file_name)
  file = relative_path(file_name)
  return false unless File.exists?(file)
  
  File.read(file)
end

RSpec.describe 'build compose files for different envs' do
  subject(:run_compose_env) { ComposeEnv.run(argv) }

  let(:argv) { ["--envs", "staging,", "production,development", "--file", file] }
  let(:file) { relative_path('tmp/docker-compose.yml.erb') }
  let(:development_file_content) do
    <<~YAML
       ---
       version: '3.9'
       services:
         db:
           image: postgres
           volumes:
           - "./tmp/db:/var/lib/postgresql/data"
           environment:
             POSTGRES_PASSWORD: password
         web:
           build: "."
           command: bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b
             '0.0.0.0'"
           volumes:
           - ".:/myapp"
           environment:
             RAILS_ENV: development
           ports:
           - 3000:3000
           - 80:3000
           depends_on:
           - db
    YAML
  end
  let(:staging_file_content) do
    <<~YAML
       ---
       version: '3.9'
       services:
         db:
           image: postgres
           volumes:
           - "./tmp/db:/var/lib/postgresql/data"
           environment:
             POSTGRES_PASSWORD: strong123password
         web:
           image: my_app:v0.1
           command: bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b
             '0.0.0.0'"
           volumes:
           - ".:/myapp"
           environment:
             RAILS_ENV: staging
           ports:
           - 80:3000
           depends_on:
           - db
    YAML
  end
  let(:production_file_content) do
    <<~YAML
       ---
       version: '3.9'
       services:
         db:
           image: postgres
           volumes:
           - "./tmp/db:/var/lib/postgresql/data"
           environment:
             POSTGRES_PASSWORD: strong123password
         web:
           image: my_app:v0.1
           command: bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -p 3000 -b
             '0.0.0.0'"
           volumes:
           - ".:/myapp"
           environment:
             RAILS_ENV: production
           ports:
           - 80:3000
           depends_on:
           - db
    YAML
  end

  before do
    FileUtils.copy(relative_path('stub/docker-compose.yml.erb'), file)
  end

  it 'creates new docker-compose env files with appropriate structure' do
    expect(file_content('tmp/docker-compose.development.yml')).to eq(false)
    expect(file_content('tmp/docker-compose.staging.yml')).to eq(false)
    expect(file_content('tmp/docker-compose.production.yml')).to eq(false)

    run_compose_env

    expect(file_content('tmp/docker-compose.development.yml')).to eq(development_file_content)
    expect(file_content('tmp/docker-compose.staging.yml')).to eq(staging_file_content)
    expect(file_content('tmp/docker-compose.production.yml')).to eq(production_file_content)
  end
end
