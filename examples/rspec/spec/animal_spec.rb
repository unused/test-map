# frozen_string_literal: true

# Test for Animal class
describe Animal do
  subject(:animal) { described_class.new }

  it 'throws error on speak' do
    expect { animal.speak }.to raise_error NotImplementedError
  end

  it 'has a kind' do
    expect(animal.kind).to eq 'animal'
  end
end
