class Beer < ApplicationRecord
    include RatingAverage

    belongs_to :brewery
    has_many :ratings, dependent: :destroy

    def average_rating_old
        ratings.average('score')
    end

    def to_s
        "#{name} by #{brewery.name}"
    end

end
