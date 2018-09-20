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
end
