class Beer < ApplicationRecord
  include RatingAverage

  validates :name, presence: true

  belongs_to :brewery
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user

  def average
    return 0 if ratings.empty?

    average_rating
  end

  def to_s
    "#{name} by #{brewery.name}"
  end

  def self.top_rated(amount)
    all.sort_by{ |b| -(b.average_rating || 0) }.first(amount)
  end
end
