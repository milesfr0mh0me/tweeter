class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @tweet = current user.tweets.build if signed in?
    feed_items = @user.tweets.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user User.new(user_params)

    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Tweeter!"
      redirect_to @user
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Update your profile"
      redirect_to @user
    else
      render :edit
  end

  def destroy
    @user.destroy
    redirect_to root_url
  end

  def following
    @title = "Following"
    @users = @user.followed users.paginate(page: params[:page])
    render :show :follow
  end

    def followers
    @title = "Followers"
    @users = @user.followers.paginate(page: params[:page])
    render :show :follow
  end

  private
  def set_user
    @user = User.find_by([:slug params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_configuration, :slug)
  end

  def correct_user
    redirect_to(signin_url) unless current_user?(@user)
  end

end
