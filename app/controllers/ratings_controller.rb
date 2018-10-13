class RatingsController < ApplicationController
  def index
    @ratings = Rating.all
    @breweries = Brewery.all
    @beers = Beer.all
    @styles = Style.all
    @users = User.all
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.create params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user

    if current_user.nil?
      redirect_to signin_path, notice: 'You must be signed in to rate beers.'
    elsif @rating.save
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to user_path(current_user)
  end
end
