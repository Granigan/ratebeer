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

  def favourite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favourite_style
    return 'None' unless ratings.present?
    return ratings.first.beer.style if ratings.count == 1
    return find_highest_averaged_style
  end

  def find_highest_averaged_style
    best_avg = 0
    best_style = "None"

    ratings.map{|r| r.beer.style}.uniq.each do |s|
      if average_rating_by_style(s) > best_avg
        best_avg = average_rating_by_style(s)
        best_style = s
      end
    end
    
    return best_style
  end


  def average_rating_by_style(style)
    ratings.find_all{|r| r.beer.style == style}.map{|r| r.score}.reduce(:+) /ratings.find_all{|r| r.beer.style == style}.count.to_f
  end


end
