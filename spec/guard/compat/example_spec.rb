# This is the only file the plugin should require
require 'guard/compat/test/helper'
require 'guard/compat/example'

RSpec.describe Guard::MyPlugin, exclude_stubs: [Guard::Plugin] do
  let(:options) { { foo: :bar } }
  subject { described_class.new(options) }

  before do
    allow(Guard::Notifier).to receive(:notify)
    %w(info warning error deprecation debug).each do |type|
      allow(Guard::UI).to receive(type.to_sym)
    end
  end

  it 'passes options' do
    expect(subject.options).to include(foo: :bar)
  end

  it 'uses the notifier' do
    expect(Guard::Notifier).to receive(:notify).with('foo')
    subject.start
  end

  it 'uses the notifier with options' do
    expect(Guard::Notifier).to receive(:notify).with('foo', title: 'bar')
    subject.run_all
  end

  %w(info warning error deprecation debug).each do |type|
    it "outputs #{type} messages" do
      expect(Guard::UI).to receive(type.to_sym).with('foo')
      subject.start
    end

    it "outputs #{type} messages with options" do
      expect(Guard::UI).to receive(type.to_sym).with('foo', bar: :baz)
      subject.run_all
    end
  end
end
