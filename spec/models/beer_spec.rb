require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "is not saved without a name" do
    beer = Beer.create

    expect(beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end

  it "is not saved without a style" do
    beer = Beer.create name:"testbeer"

    expect(beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end

  describe "with a name, a style, and a brewery" do
    let(:test_brewery) {Brewery.new name:"test", year:2000}
    let(:beer) {Beer.create name:"testbeer", style:"teststyle", 
      brewery:test_brewery}

    it "is saved" do
      expect(beer).to be_valid
      expect(Beer.count).to eq(1)
    end
  end
end
