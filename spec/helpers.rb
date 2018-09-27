module Helpers

  def sign_in(credentials)
    visit signin_path
    fill_in('username', with:credentials[:username])
    fill_in('password', with:credentials[:password])
    click_button('Log in')
  end
end

def create_beer_with_rating(object, score)
  beer = FactoryBot.create(:beer)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
  beer
end

def create_beers_with_many_ratings(object, *scores)
  scores.each do |s|
    create_beer_with_rating(object, s)
  end
end

def create_beer_with_rating_and_with_style(object, score, style)
  beer = FactoryBot.create(:beer, style: style)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
  beer
end

def create_beer_with_rating_and_brewery(object, score, brewery)
  beer = FactoryBot.create(:beer)
  beer.brewery_id = brewery.id
  beer.save
  FactoryBot.create(:rating, beer:beer, score: score, user: object[:user] )
  beer
end

def create_beer_with_everything(object, name, score, brewery, style)
  beer = FactoryBot.create(:beer, name: name, style:style, brewery_id: brewery.id)
  FactoryBot.create(:rating, beer:beer, score: score, user: object[:user] )
  beer
end
