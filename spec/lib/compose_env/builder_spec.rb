# frozen_string_literal: true

RSpec.describe ComposeEnv::Builder do
  subject(:builder) { described_class.new(options) }

  let(:options) { ComposeEnv::InputParser::Options.new(%i[production development], file) }
  let(:file) { '/foo/boo/some-file.yml.erb' }

  describe '#parse_all' do
    let(:erb_template) do

    end
  end

  describe '#build_compose_files, #build_compose_files!' do
    subject(:compose_file_name) { builder.__send__(:environment_file_name, 'staging') }

    context 'when single extension' do
      let(:file) { '/foo/boo/some-file.yml.erb' }

      it { is_expected.to eq('/foo/boo/some-file.staging.yml') }
    end

    context 'when multiple extensions' do
      let(:file) { '/foo/boo/some-file.staging.xml.yml.erb.tmp' }

      it { is_expected.to eq('/foo/boo/some-file.staging.yml') }
    end
  end
end
