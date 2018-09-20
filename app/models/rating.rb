class Rating < ApplicationRecord
  belongs_to :beer
  belongs_to :user

  def to_s
    "#{beer.name} got a rating of #{score}/50"
  end
end
