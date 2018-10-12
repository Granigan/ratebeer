require 'rails_helper'

describe "Breweries page" do
  it "should not have any list items before being created" do
    visit breweries_path
    expect(page).to have_content 'Breweries'
    expect(page).to have_content 'Number of Breweries: 0'
  end
   
  describe "when breweries exist" do
    before :each do
      @breweries = ["Koff", "Karjala", "Schlenkerla"]
      year = 1896
      @breweries.each do |bname|
        FactoryBot.create(:brewery, name: bname, year:year += 1)

      end
    
      visit breweries_path
    end

    it "lists the existing breweries and their total number" do
      expect(page).to have_content "Breweries total: #{@breweries.count}"
    
      @breweries.each do |brewery_name|
        expect(page).to have_content brewery_name
      end
    end

    it "allows user to navigate to a page of a Brewery" do
      click_link "Koff"

      expect(page).to have_content "Koff"
      expect(page).to have_content "Established in 1897"
    end
  end
end