class Style < ApplicationRecord
  include RatingAverage

  has_many :beers
  has_many :ratings, through: :beers

  def to_s
    name.to_s
  end

  def self.top_rated(n)
    self.all.sort_by{ |b| -(b.average_rating || 0) }.first(n)
  end

end
