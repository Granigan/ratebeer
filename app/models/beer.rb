class Beer < ApplicationRecord
    belongs_to :brewery
    has_many :ratings

    def average_rating_old
        ratings.average('score')
    end

    def average_rating
        ratings.map{|r| r.score}.reduce(:+) / ratings.count
    end

    def to_s
        "#{name} by #{brewery.name}"
    end

end
