module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    return ratings.map(&:score).reduce(:+) / ratings.count.to_f unless ratings.empty?

    0.0
  end
end
