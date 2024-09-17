# frozen_string_literal: true

describe Dog do
  subject(:dog) { described_class.new }

  it 'throws error on speak' do
    expect(dog.speak).to eq 'Wuff'
  end

  it 'has a kind' do
    expect(dog.kind).to eq 'dog'
  end
end
