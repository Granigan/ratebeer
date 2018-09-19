module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    ratings.map(&:score).reduce(:+) / ratings.count
  end
end
