require 'rails_helper'

include Helpers

describe "User" do
  before :each do
    FactoryBot.create :user
  end

  it "when signed up with good credentials, is added to db" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  describe "who has signed up" do
    it "can sign in with right credentials" do
      sign_in(username: "Pekka", password: "Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials give" do
      sign_in(username: "Pekka", password: "wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'User and/or password mismatch.'
    end
  end
end

describe "User page" do
  before :each do
    @user = FactoryBot.create(:user)
    @ratings = [10, 15, 9]
    @ratings.each do |score|
      create_beer_with_rating( {user: @user}, score)
    end

    visit user_path(@user)
  end

  it "lists ratings by user" do
    @ratings.each do |score|  
      expect(page).to have_content score
    end
  end

  it "lists only user's ratings" do
    user = FactoryBot.create(:user, username:'Wilma')
    create_beer_with_rating( {user: user }, 49)
    expect(page).not_to have_content('49')
  end


  it "deletes a rating, it is removed from db" do
    sign_in(username:"Pekka", password:"Foobar1")
    visit user_path(@user)
    expect{
      click_link('delete', match: :first)
    }.to change{Rating.count}.from(3).to(2)
  end

end
