require 'rails_helper'

include Helpers

describe "Ratings page" do
  it "should have no ratings before being created" do
    visit ratings_path
    expect(page).to have_content 'List of Ratings'
    expect(page).to have_content 'Number of Ratings: 0'
  end

  describe "when ratings exist" do
    before :each do
      user = FactoryBot.create(:user)
      @ratings = [10, 15, 9]
      @ratings.each do |score|
        create_beer_with_rating( {user: user}, score)
      end
      visit ratings_path
    end

    it "lists all ratings and their total number" do
      expect(page).to have_content 'Number of Ratings: 3'
      @ratings.each do |score|
        expect(page).to have_content score
      end
    end


  end

end


describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryBot.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and current user" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button('Create Rating')
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

end
