# encoding: utf-8

require 'spec_helper'

describe Axiom::Types::ValueComparable, '.extended' do
  subject { object.extend(described_class) }

  let(:object) { Class.new(Axiom::Types::Type) }

  it 'delegates to the ancestor' do
    # RSpec will reset stubbed methods after the example. A normal expectation
    # causes a SystemStackError to be thrown, so we stub it first so that RSpec
    # tracks the original method (if any), then we add our own stub that
    # actually works, and finally when the example finishes RSpec will reset the
    # Module#extended method back to it's original state.
    Module.any_instance.stub(:extended).with(object)

    delegated_ancestor = false
    Module.send(:define_method, :extended) { |_| delegated_ancestor = true }
    expect { subject }.to change { delegated_ancestor }.from(false).to(true)
  end

  it 'adds minimum method' do
    expect { subject }.to change { object.respond_to?(:minimum) }.
      from(false).to(true)
  end

  it 'adds maxumum method' do
    expect { subject }.to change { object.respond_to?(:maximum) }.
      from(false).to(true)
  end

  it 'sets the default minimum' do
    expect(subject.minimum).to eql(-::Float::INFINITY)
  end

  it 'sets the default maximum' do
    expect(subject.maximum).to eql(::Float::INFINITY)
  end
end
