require 'rails_helper'

include Helpers

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  it "is not saved with a too short password" do
    user = User.create username:"Pekka", password:"Se1",
      password_confirmation:"Se1"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  it "is not saved with a letters-only password" do
    user = User.create username:"Pekka", password:"secrets", 
      password_confirmation:"secrets"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user) { FactoryBot.create(:user) }
    
    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score:10, user: user)
      FactoryBot.create(:rating, score:20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15)
    end
  end

  describe "favourite beer" do
    let(:user){ FactoryBot.create(:user) }

    it "has a method for determining one" do
      expect(user).to respond_to(:favourite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favourite_beer).to eq('None')
    end

    it "is the only rated one if there's only one rating" do
      beer = create_beer_with_rating({ user: user }, 20)

      expect(user.favourite_beer).to eq(beer.name)
    end

    it "is the one with highest rating if several are rated" do
      create_beer_with_rating({ user: user }, 10)
      create_beer_with_rating({ user: user }, 7)
      best = create_beer_with_rating({ user: user }, 25)
      
      expect(user.favourite_beer).to eq(best.name)
    end
  end

  describe "favourite style" do
    let(:user){ FactoryBot.create(:user) }
    let(:beststyle){ FactoryBot.create(:style, name: "beststyle")}
    
    it "has a method for determining one" do
      expect(user).to respond_to(:favourite_style)
    end

    it "is none if there are no ratings by user" do
      expect(user.favourite_style).to eq('None')
    end

    it "is the style of only rated beer" do
      create_beer_with_rating_and_with_style( {user: user}, 1, beststyle)
      expect(user.favourite_style).to eq(beststyle)
    end

    it "is the style with highest average rating" do
      mehstyle = FactoryBot.create(:style, name: 'mehstyle')
      create_beer_with_rating_and_with_style( {user: user}, 10, mehstyle)
      create_beer_with_rating_and_with_style( {user: user}, 30, mehstyle)
      create_beer_with_rating_and_with_style( {user: user}, 20, beststyle)
      create_beer_with_rating_and_with_style( {user: user}, 5, mehstyle)

      expect(user.favourite_style).to eq(beststyle)
    end

  end

  describe "favourite brewery" do
    let(:user){ FactoryBot.create(:user) }
    let(:brewery) { FactoryBot.create(:brewery, name: 'test')}

    it "is none if there are no ratings by user" do
      expect(user.favourite_brewery).to eq('None')
    end

    it "is the maker of the only rated beer" do
      create_beer_with_rating_and_brewery({user: user}, 10, brewery)
      expect(user.favourite_brewery).to eq(brewery.name)
    end

    it "is the brewery with highest average rating" do
      best = FactoryBot.create(:brewery, name: 'best')
      create_beer_with_rating_and_brewery({user: user}, 10, brewery)
      create_beer_with_rating_and_brewery({user: user}, 30, brewery)
      create_beer_with_rating_and_brewery({user: user}, 20, best)
      create_beer_with_rating_and_brewery({user: user}, 5, brewery)

      expect(user.favourite_brewery).to eq(best.name)
    end
  end

end
