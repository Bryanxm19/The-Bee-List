class UsersController < ApplicationController

  def show
    @user = User.find_by(id: params[:id])
    @categories = Category.all
  end

  def new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to "/users/#{@user.id}"
    else
      @errors = @user.errors.full_messages
      render 'new'
    end
  end

  def friends
    @user = User.find_by(id: params[:user_id])
  end

  def friend_search
    @user = current_user
    @categories = Category.all
    @results = User.search_for_friends(params[:search])

    if request.xhr?
      render '/users/_user_search_results', layout: false
    else
      render 'show'
    end
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :username, :email, :password, :password_confirmation)
    end
end
