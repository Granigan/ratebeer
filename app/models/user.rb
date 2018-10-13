class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true, length: { minimum: 3, maximum: 30 }
  validates_format_of :password, with: /(?=.*[A-Z].*)(?=.*\d.*)\w{4,}/,
                                 message: "must contain at least one uppercase letter and one digit."

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beerclubs, through: :memberships

  def joinable_clubs
    Beerclub.where.not(id: Membership.where(user_id: id).map(&:beerclub_id))
  end

  def member?(club_id)
    Membership.where(user_id: id, beerclub_id: club_id).present?
  end

  def favourite_beer
    return 'None' if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer.name
  end

  def favourite_style
    return 'None' unless ratings.present?

    find_highest_averaged_style
  end

  def find_highest_averaged_style
    best_avg = 0.0
    best_style = "None"

    ratings.map{ |r| r.beer.style }.uniq.each do |s|
      avg = average_rating_by_style(s)
      if avg > best_avg
        best_avg = average_rating_by_style(s)
        best_style = s
      end
    end
    best_style
  end

  def average_rating_by_style(style)
    ratings.find_all{ |r| r.beer.style == style }.map(&:score).reduce(:+) / ratings.find_all{ |r| r.beer.style == style }.count.to_f
  end

  def favourite_brewery
    return 'None' unless ratings.present?

    find_highest_averaged_brewery.name
  end

  def find_highest_averaged_brewery
    best_avg = 0.0
    best_brewery = nil
    ratings.map{ |r| r.beer.brewery }.uniq.each do |b|
      avg = average_rating_by_brewery(b)
      if avg > best_avg
        best_avg = avg
        best_brewery = b
      end
    end
    best_brewery
  end

  def average_rating_by_brewery(brewery)
    ratings.find_all{ |r| r.beer.brewery.id == brewery.id }.
      map(&:score).reduce(:+) / ratings.
                                find_all{ |r| r.beer.brewery.id == brewery.id }.count.to_f
  end

  def self.top_raters(amount)
    all.sort_by{ |u| -(u.ratings.count || 0) }.first(amount)
  end
end
