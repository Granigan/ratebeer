module TopRated
  extend ActiveSupport::Concern

  def self.top_rated(amount)
    all.sort_by{ |b| -(b.average_rating || 0) }.first(amount)
  end
end
