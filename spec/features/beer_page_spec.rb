require 'rails_helper'

include Helpers

describe "Beer" do
  let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }
  let!(:style) {FactoryBot.create :style, name:"Lager"}
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given with an invalid name, displays error and is not added" do
    visit new_beer_path
    fill_in('beer_name', with:'')
    select('Lager', from:'beer[style_id]')
    select('Koff', from:'beer[brewery_id]')

    click_button('Create Beer')
    
    expect(page).to have_content('Name can\'t be blank')
    expect(brewery.beers.count).to eq(0)
  end    
  
  it "when given with a valid name, is registered to a brewery" do
    visit new_beer_path
    fill_in('beer_name', with:'test')
    select('Lager', from:'beer[style_id]')
    select('Koff', from:'beer[brewery_id]')

    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.from(0).to(1)

    expect(brewery.beers.count).to eq(1)
  end
end
