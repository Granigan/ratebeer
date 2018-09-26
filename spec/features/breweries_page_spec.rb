require 'rails_helper'

describe "Breweries page" do
    it "should not have any before being created" do
        visit breweries_path
        expect(page).to have_content 'Breweries'
        expect(page).to have_content 'Number of Breweries: 0'
    end
end
