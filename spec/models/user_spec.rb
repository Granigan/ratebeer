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
      expect(user.favourite_beer).to eq(nil)
    end

    it "is the only rated one if there's only one rating" do
      beer = create_beer_with_rating({ user: user }, 20)

      expect(user.favourite_beer).to eq(beer)
    end

    it "is the one with highest rating if several are rated" do
      create_beer_with_rating({ user: user }, 10)
      create_beer_with_rating({ user: user }, 7)
      best = create_beer_with_rating({ user: user }, 25)
      
      expect(user.favourite_beer).to eq(best)
    end
  end

  describe "favourite style" do
    let(:user){ FactoryBot.create(:user) }
    
    it "has a method for determining one" do
      expect(user).to respond_to(:favourite_style)
    end

    it "is none if there are no ratings by user" do
      expect(user.favourite_style).to eq('None')
    end

    it "is the style of only rated beer" do
      create_beer_with_rating_and_with_style( {user: user}, 1, 'test')
      expect(user.favourite_style).to eq('test')
    end

    it "is the style with highest average rating" do
      create_beer_with_rating_and_with_style( {user: user}, 10, 'test')
      create_beer_with_rating_and_with_style( {user: user}, 30, 'test')
      create_beer_with_rating_and_with_style( {user: user}, 20, 'best')
      create_beer_with_rating_and_with_style( {user: user}, 5, 'test')

      expect(user.favourite_style).to eq('best')
    end

  end

end
