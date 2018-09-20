class Beerclub < ApplicationRecord
    has_many :memberships, dependent: :destroy
    has_many :members, through: :memberships, source: :users
end
