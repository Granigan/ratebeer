class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery
  has_many :ratings, dependent: :destroy

  def average_rating_old
    ratings.average('score')
  end

  def average
    return 0 if ratings.empty?

    ratings.map(&:score).sum / ratings.count.to_f
  end

  def to_s
    "#{name} by #{brewery.name}"
  end
end
