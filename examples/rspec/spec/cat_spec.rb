# frozen_string_literal: true

# Test for Cat class
describe Cat do
  subject(:cat) { described_class.new }

  it 'throws error on speak' do
    expect(cat.speak).to eq 'Miau'
  end

  it 'has a kind' do
    expect(cat.kind).to eq 'cat'
  end
end
