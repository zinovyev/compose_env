# frozen_string_literal: true

RSpec.describe ComposeEnv::Context do
  subject(:context) { described_class.new(options, current_env) }

  let(:options) { ComposeEnv::InputParser::Options.new(%i[production development], '/foo/boo/some-file.yml.erb') }
  let(:current_env) { :development }
  let(:callback) do
    ->{ puts :foo }
  end

  describe '#env' do
    specify { expect(context.env).to eq(context) }
  end

  describe '#env?' do
    specify 'when testing agains current environment' do
      expect(callback).to receive(:call)
      context.env?(:development, :testing, &callback)
    end

    specify 'when testing against other environment' do
      expect(callback).not_to receive(:call)
      context.env?(:production, :testing, &callback)
    end

    specify 'when no callback is given' do
      expect(callback).not_to receive(:call)
      expect(context.env?(:development, :testing)).to eq(nil)
    end
  end

  describe 'environment verification via the question method' do
    specify do
      expect(context.production?).to eq(false)
      expect(context.development?).to eq(true)
      expect { context.staging? }.to raise_error(NoMethodError)
    end
  end

  describe 'environment verification by passing a block' do
    specify 'when testing against current environment' do
      expect(callback).to receive(:call)
      context.development(&callback)
    end

    specify 'when testing against other environment' do
      expect(callback).not_to receive(:call)
      context.production(&callback)
    end

    specify 'when no callback is given' do
      expect(callback).not_to receive(:call)
      expect(context.production).to eq(nil)
    end

    specify 'when environment is not defined' do
      expect { context.staging }.to raise_error(NoMethodError)
    end
  end
end
