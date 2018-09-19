class Rating < ApplicationRecord
  belongs_to :beer

  def to_s
    "#{beer.name} got a rating of #{score}/50"
  end
end
