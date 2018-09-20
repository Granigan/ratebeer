class Beerclub < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user

  def joinable_clubs
    # binding.pry
    # create a list of clubs current_user is NOT in
  end
end
