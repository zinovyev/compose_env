# frozen_string_literal: true

RSpec.describe ComposeEnv::InputParser do
  subject(:input_parser) { described_class.new }

  def file_path(file)
    "#{Dir.pwd}/#{file}"
  end

  describe '#parse' do
    subject(:options) { input_parser.parse(argv) }

    let(:argv) { [] }
    let(:expected_attributes) { {envs: %i[development staging production], file: file_path('docker-compose.yml.erb')} }

    it { is_expected.to have_attributes(**expected_attributes) }

    context 'with comma separated envs' do
      let(:argv) { ['--envs', 'test,production', '--file', 'docker-compose.yml.erb'] }
      let(:expected_attributes) { {envs: %i[test production], file: file_path('docker-compose.yml.erb')} }

      it { is_expected.to have_attributes(**expected_attributes) }

      context 'when envs contain whitespaces' do
        let(:argv) { ['--envs', 'test,', 'production', '--file', 'docker-compose.yml.erb'] }

        it { is_expected.to have_attributes(**expected_attributes) }
      end
    end
  end
end
