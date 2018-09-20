module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    ratings.map(&:score).reduce(:+) / ratings.count.to_f
  end
end
