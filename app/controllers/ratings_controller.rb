class RatingsController < ApplicationController
    before_action :set_rating, only: [:show, :edit, :update, :destroy]

    def index
        @ratings = Rating.all
    end

end
