module TopRated
  extend ActiveSupport::Concern

  def self.top_rated(n)
    self.all.sort_by{ |b| -(b.average_rating || 0) }.first(n)
  end
end
